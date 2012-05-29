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
#import "AmazonClientManager.h"

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

    AmazonDynamoDBClient *ddb = [AmazonClientManager ddbClient];

    @try {
        NSMutableDictionary *putItem = [self createItem:gps];
        DynamoDBPutItemRequest *putItemRequest = [[[DynamoDBPutItemRequest alloc] initWithTableName:TABLE_NAME andItem:putItem] autorelease];
        DynamoDBPutItemResponse *putItemResponse = [ddb putItem:putItemRequest];
        NSLog(@"rep   %@", putItemResponse);
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }

    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(checkIsReceived:) userInfo:nil repeats:YES];

    while (!_isReceived) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    NSLog(@"over!!!!!!!!!!!!");

    [pool release];
}

- (NSMutableDictionary *)createItem:(GSGPSController *)gps
{
    NSDate *date = [NSDate date];
    NSString *id = [NSString stringWithFormat:@"%@#%d",[date description],rand()%100000];
    userID = id;
    DynamoDBAttributeValue *v1 = [[[DynamoDBAttributeValue alloc] initWithS:id] autorelease];
    DynamoDBAttributeValue *v2 = [[[DynamoDBAttributeValue alloc] initWithS:userName] autorelease];
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
    
    AmazonDynamoDBClient *ddb = [AmazonClientManager ddbClient];
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
