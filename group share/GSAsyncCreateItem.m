//
//  AsyncCreateItem.m
//  group share
//
//  Created by kaku on 12/05/23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <AWSiOSSDK/AmazonServiceRequest.h>
#import <AWSiOSSDK/STS/AmazonSecurityTokenServiceClient.h>
#import <AWSiOSSDK/S3/AmazonS3Client.h>
#import <AWSiOSSDK/AmazonCredentials.h>
#import <AWSiOSSDK/DynamoDB/AmazonDynamoDBClient.h>
#import <AWSiOSSDK/DynamoDB/DynamoDBAttributeValue.h>

#import "GSAsyncCreateItem.h"
#import "AWSConstants.h"
#import "GSGPSController.h"

@implementation GSAsyncCreateItem

@synthesize finished = _finished;

#pragma mark - Class Lifecycle

-(id)initWithName:(NSString *)name
{
    self = [super init];
    if (self)
    {
        self.finished = NO;
        userName = [name retain];
    }
    return self;
}

-(void)dealloc
{
    if (userLocation) {
        [userLocation release];
    }

    if (userName) {
        [userName release];
    }

    [super dealloc];
}

#pragma mark - Overwriding NSOperation Methods

/*
 * For concurrent operations, you need to override the following methods:
 * start, isConcurrent, isExecuting and isFinished.
 *
 * Please refer to the NSOperation documentation for more details.
 * http://developer.apple.com/library/ios/#documentation/Cocoa/Reference/NSOperation_class/Reference/Reference.html
 */

-(void)main
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    GSGPSController *gps = [[[GSGPSController alloc] init] autorelease];
    [gps setResult:self];
    [gps startLocate];

    while (!self.finished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    NSLog(@"location %@", [gps.lastReading description]);

    @try {
        AmazonDynamoDBClient *ddb = [self ddbClient];

        DynamoDBAttributeValue *v1 = [[[DynamoDBAttributeValue alloc] initWithN:@"5"] autorelease];
        DynamoDBAttributeValue *v2 = [[[DynamoDBAttributeValue alloc] initWithS:userName] autorelease];
        NSData *locationData = [NSKeyedArchiver archivedDataWithRootObject:gps.lastReading];
        NSString *locationStr = [locationData base64EncodedString];
        DynamoDBAttributeValue *v3 = [[[DynamoDBAttributeValue alloc] initWithS:locationStr] autorelease];
        NSMutableDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        v1, @"id", v2, @"name", v3, @"location", nil];
        
        DynamoDBPutItemRequest *putItemRequest = [[[DynamoDBPutItemRequest alloc] initWithTableName:TABLE_NAME andItem:userDic] autorelease];
        DynamoDBPutItemResponse *putItemResponse = [ddb putItem:putItemRequest];
        NSLog(@"rep   %@", putItemResponse);

        /*
        DynamoDBDescribeTableRequest *desRequest = [[[DynamoDBDescribeTableRequest alloc] initWithTableName:TABLE_NAME] autorelease];
        DynamoDBDescribeTableResponse *desResponse = [ddb describeTable:desRequest];
        DynamoDBScanRequest *scanRequest = [[[DynamoDBScanRequest alloc] initWithTableName:TABLE_NAME] autorelease];
        DynamoDBScanResponse *scanResponse = [ddb scan:scanRequest];

        NSMutableArray *users = scanResponse.items;
        NSLog(@"array: %@", users);
         */
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }

    [pool release];
}

- (AmazonDynamoDBClient *)ddbClient
{
    AmazonSecurityTokenServiceClient *tst = [[[AmazonSecurityTokenServiceClient alloc] initWithAccessKey:   ACCESS_KEY_ID withSecretKey:SECRET_KEY] autorelease];
    SecurityTokenServiceGetSessionTokenRequest *tokenRequest = [[[SecurityTokenServiceGetSessionTokenRequest alloc] init] autorelease];
    SecurityTokenServiceGetSessionTokenResponse *rep = [tst getSessionToken:tokenRequest];
    SecurityTokenServiceCredentials *c = [rep credentials];
    AmazonCredentials *credentials = [[[AmazonCredentials alloc] initWithAccessKey:c.accessKeyId withSecretKey:c.secretAccessKey withSecurityToken:c.sessionToken] autorelease];
    AmazonDynamoDBClient *ddb = [[[AmazonDynamoDBClient alloc] initWithCredentials:credentials] autorelease];
    return ddb;
}

@end
