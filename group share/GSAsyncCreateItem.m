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
        _isReceived = NO;
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
    NSLog(@"altitude %@", gps.lastReading.altitude);

    @try {
        AmazonDynamoDBClient *ddb = [self ddbClient];

        NSMutableDictionary *putItem = [self createItem:gps];
        DynamoDBPutItemRequest *putItemRequest = [[[DynamoDBPutItemRequest alloc] initWithTableName:TABLE_NAME andItem:putItem] autorelease];
        DynamoDBPutItemResponse *putItemResponse = [ddb putItem:putItemRequest];
        NSLog(@"rep   %@", putItemResponse);
        
        /*
        DynamoDBDescribeTableRequest *desRequest = [[[DynamoDBDescribeTableRequest alloc] initWithTableName:TABLE_NAME] autorelease];
        DynamoDBDescribeTableResponse *desResponse = [ddb describeTable:desRequest];
        DynamoDBScanRequest *scanRequest = [[[DynamoDBScanRequest alloc] initWithTableName:TABLE_NAME] autorelease];
        DynamoDBScanResponse *scanResponse = [ddb scan:scanRequest];

        NSMutableArray *users = scanResponse.items;
        NSLog(@"array: %@", users);


        DynamoDBAttributeValue *v1 = [[[DynamoDBAttributeValue alloc] initWithS:@"2012-05-27 15:22:53 +0000"] autorelease];
        DynamoDBQueryRequest *queryRequest = [[[DynamoDBQueryRequest alloc] initWithTableName:TABLE_NAME andHashKeyValue:v1] autorelease];
        NSLog(@"hash key v   %@", [queryRequest hashKeyValue]);
        [queryRequest addAttributesToGet:@"name"];
        DynamoDBQueryResponse *queryResponse = [ddb query:queryRequest]; 
        */
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }

    NSTimer *tm = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(checkIsReceived:) userInfo:nil repeats:YES];
    
    while (!_isReceived) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    NSLog(@"over!!!!!!!!!!!!");
    
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

- (NSMutableDictionary *)createItem:(GSGPSController *)gps
{
    NSDate *date = [NSDate date];
    NSString *id = [NSString stringWithFormat:@"%@#%d",[date description],rand()%100000];
    userID = id;
    DynamoDBAttributeValue *v1 = [[[DynamoDBAttributeValue alloc] initWithS:id] autorelease];
    DynamoDBAttributeValue *v2 = [[[DynamoDBAttributeValue alloc] initWithS:userName] autorelease];
    //DynamoDBAttributeValue *v3 = [[[DynamoDBAttributeValue alloc] initWithS:[gps.lastReading description]] autorelease];
    //NSData *locationData = [NSKeyedArchiver archivedDataWithRootObject:gps.lastReading];
    //NSString *locationStr = [locationData base64EncodedString];
    DynamoDBAttributeValue *latitude = [[[DynamoDBAttributeValue alloc] initWithN:[NSString stringWithFormat:@"%f", gps.lastReading.coordinate.latitude]] autorelease];
    DynamoDBAttributeValue *longitude = [[[DynamoDBAttributeValue alloc] initWithN:[NSString stringWithFormat:@"%f", gps.lastReading.coordinate.longitude]] autorelease];
    DynamoDBAttributeValue *altitude = [[[DynamoDBAttributeValue alloc] initWithN:[NSString stringWithFormat:@"%f", gps.lastReading.altitude]] autorelease];
    DynamoDBAttributeValue *hAccuracy = [[[DynamoDBAttributeValue alloc] initWithN:[NSString stringWithFormat:@"%f", gps.lastReading.horizontalAccuracy]] autorelease];
    DynamoDBAttributeValue *vAccuracy = [[[DynamoDBAttributeValue alloc] initWithN:[NSString stringWithFormat:@"%f", gps.lastReading.verticalAccuracy]] autorelease];
    DynamoDBAttributeValue *v4 = [[[DynamoDBAttributeValue alloc] initWithS:@"NO"] autorelease];
    NSMutableDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                    v1, @"id", v2, @"name", latitude, @"latitude", longitude, @"longitude", altitude, @"altitude", hAccuracy, @"hAccuracy", vAccuracy, @"vAccuracy", v4, @"isReceived", nil];
    
    return dic;
}

-(void)checkIsReceived:(NSTimer*)timer{
    
    AmazonDynamoDBClient *ddb = [self ddbClient];
    DynamoDBAttributeValue *v = [[[DynamoDBAttributeValue alloc] initWithS:userID] autorelease];
    DynamoDBKey *k = [[[DynamoDBKey alloc] initWithHashKeyElement:v] autorelease];
    DynamoDBGetItemRequest *getItemRequest = [[[DynamoDBGetItemRequest alloc] initWithTableName:TABLE_NAME andKey:k] autorelease];
    DynamoDBGetItemResponse *getItemResponse = [ddb getItem:getItemRequest];
    NSMutableDictionary *item = getItemResponse.item;
    DynamoDBAttributeValue *isReceived = [item objectForKey:@"isReceived"];
    NSLog(@"item %@", [item objectForKey:@"isReceived"]);
    if ([isReceived.s isEqualToString:@"NO"]) {
        [timer invalidate];
        _isReceived = YES;
    }
    
    NSLog(@"check");
}

@end
