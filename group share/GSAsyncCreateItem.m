//
//  AsyncCreateItem.m
//  group share
//
//  Created by kaku on 12/05/23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <AWSiOSSDK/STS/AmazonSecurityTokenServiceClient.h>
#import <AWSiOSSDK/S3/AmazonS3Client.h>
#import <AWSiOSSDK/AmazonCredentials.h>
#import <AWSiOSSDK/DynamoDB/AmazonDynamoDBClient.h>
#import <AWSiOSSDK/DynamoDB/DynamoDBAttributeValue.h>

#import "GSAsyncCreateItem.h"
#import "AWSConstants.h"

@implementation GSAsyncCreateItem

#pragma mark - Class Lifecycle

-(id)initWithLocation:(NSData *)location withName:(NSString *)name
{
    self = [super init];
    if (self)
    {
        userLocation = [location retain];
        userName = [name retain];
    }
    return self;
}

-(void)dealloc
{
    [userLocation release];
    [userName release];
    
    
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
    locationMan = [[CLLocationManager alloc] init];
    if([CLLocationManager locationServicesEnabled]){	
        locationMan.delegate = self;    
        locationMan.distanceFilter = kCLDistanceFilterNone;
        locationMan.desiredAccuracy = kCLLocationAccuracyBest;
        [locationMan startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    NSData *d = [[NSKeyedArchiver archivedDataWithRootObject:newLocation] retain];
    AmazonSecurityTokenServiceClient *tst = [[[AmazonSecurityTokenServiceClient alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY] autorelease];
    SecurityTokenServiceGetSessionTokenRequest *tokenRequest = [[[SecurityTokenServiceGetSessionTokenRequest alloc] init] autorelease];
    SecurityTokenServiceGetSessionTokenResponse *rep = [tst getSessionToken:tokenRequest];
    SecurityTokenServiceCredentials *c = [rep credentials];
    AmazonCredentials *credentials = [[[AmazonCredentials alloc] initWithAccessKey:c.accessKeyId withSecretKey:c.secretAccessKey withSecurityToken:c.sessionToken] autorelease];
    AmazonDynamoDBClient *ddb = [[[AmazonDynamoDBClient alloc] initWithCredentials:credentials] autorelease];
    
    @try {
        DynamoDBAttributeValue *v1 = [[[DynamoDBAttributeValue alloc] initWithN:@"123456"] autorelease];
        DynamoDBAttributeValue *v2 = [[[DynamoDBAttributeValue alloc] initWithS:@"guo"] autorelease];
        DynamoDBAttributeValue *v3 = [[[DynamoDBAttributeValue alloc] initWithS:@"fei"] autorelease];
        NSMutableDictionary *userDic = [[NSDictionary dictionaryWithObjectsAndKeys:
                                         v1, @"id", v2, @"firstName", v3, @"lastName", nil] autorelease];
        
        DynamoDBDescribeTableRequest *desRequest = [[[DynamoDBDescribeTableRequest alloc] initWithTableName:TABLE_NAME] autorelease];
        DynamoDBDescribeTableResponse *desResponse = [[ddb describeTable:desRequest] autorelease];
        
        NSLog(@"response:%@",desResponse);
        //NSString *status = response.table.tableStatus;
        
        DynamoDBScanRequest *scanRequest = [[[DynamoDBScanRequest alloc] initWithTableName:TABLE_NAME] autorelease];
        DynamoDBScanResponse *scanResponse = [[ddb scan:scanRequest] autorelease];
        
        NSMutableArray *users = scanResponse.items;
        NSLog(@"array: %@", users);
        
        DynamoDBPutItemRequest *putItemRequest = [[DynamoDBPutItemRequest alloc] initWithTableName:TABLE_NAME andItem:userDic];
        DynamoDBPutItemResponse *putItemResponse = [ddb putItem:putItemRequest];
        NSLog(@"rep   %@", putItemResponse);
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    //[man stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"error: %@",[error localizedDescription]);	
}

@end
