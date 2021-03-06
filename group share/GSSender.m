//
//  GSSender.m
//  group share
//
//  Created by kaku on 12/06/05.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <AWSiOSSDK/AmazonServiceRequest.h>
#import <AWSiOSSDK/DynamoDB/DynamoDBAttributeValue.h>

#import "AWSConstants.h"
#import "AmazonClientManager.h"
#import "GSSender.h"
#import "AsyncUploader.h"
#import "GSGPSController.h"

@interface GSSender()
{
    NSString *s3FileName;
    id s3Data;
    GSGPSController *gpsCtntroller;
    UIProgressView  *progressView;
    NSOperationQueue *operationQueue;
    GSNearPerson *_nearPerson;
}

@property (nonatomic, retain) GSNearPerson *nearPerson;

@end

@implementation GSSender

@synthesize nearPerson = _nearPerson;

- (id)initWithS3FileName:(NSString *)name s3Data:(id)data gpsCtr:(GSGPSController *)gps progressView:(UIProgressView *)view
{
    if (self = [super init]) {
        s3FileName = [name retain];
        s3Data = [data retain];
        gpsCtntroller = [gps retain];
        progressView = [view retain];
        operationQueue = [[NSOperationQueue alloc] init];
        operationQueue.maxConcurrentOperationCount = 3;
        self.nearPerson = [[GSNearPerson alloc] initWithLocation:gpsCtntroller.lastReading];
    }
    return self;
}

- (void)dealloc
{
    [s3FileName release];
    [s3Data release];
    [gpsCtntroller release];
    [progressView release];
    [operationQueue cancelAllOperations];
    [operationQueue release];
    [super dealloc];
}

- (void)uploadData
{
    AsyncUploader *uploader = [[AsyncUploader alloc] initWithData:s3Data keyName:s3FileName GPS:gpsCtntroller progressView:progressView];
    uploader.delegate = self;
    [operationQueue addOperation:uploader];
    [uploader release];
}

- (void)uploaderHasDone:(id)sender
{
    NSMutableDictionary *np = [[self.nearPerson getNearPerson] retain];
    NSArray *allKeys = [np allKeys];
    for (int i = 0; i < allKeys.count; ++i) {
        NSString *pKey = [allKeys objectAtIndex:i];
        [self updateItem:pKey];
    }
}

- (void)updateHasDone:(id)sender
{
    //all receiver's item has been updated
}

- (void)updateItem:(NSString *)pkey
{
    DynamoDBAttributeValue *isReceived = [[DynamoDBAttributeValue alloc] initWithS:@"YES"];
    DynamoDBAttributeValueUpdate *isReceivedUpdate = [[DynamoDBAttributeValueUpdate alloc] initWithValue:isReceived andAction:@"PUT"];
    DynamoDBAttributeValue *url = [[DynamoDBAttributeValue alloc] initWithS:s3FileName];
    DynamoDBAttributeValueUpdate *urlUpdate = [[DynamoDBAttributeValueUpdate alloc] initWithValue:url andAction:@"PUT"];
    [isReceived release];
    [url release];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:isReceivedUpdate forKey:@"isReceived"];
    [dic setObject:urlUpdate forKey:@"url"];
    DynamoDBAttributeValue *id = [[DynamoDBAttributeValue alloc] initWithS:pkey];
    DynamoDBKey *key = [[DynamoDBKey alloc] initWithHashKeyElement:id];
    DynamoDBUpdateItemRequest *request = [[DynamoDBUpdateItemRequest alloc] initWithTableName:TABLE_NAME andKey:key andAttributeUpdates:dic];
    [[AmazonClientManager ddbClient] updateItem:request];
    [id release];
    [urlUpdate release];
    [isReceivedUpdate release];
    [key release];
    [request release];
}

@end
