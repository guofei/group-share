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

@implementation GSSender

- (id)initWithS3FileName:(NSString *)name s3Data:(id)data gpsCtr:(GSGPSController *)gps progressView:(UIProgressView *)view
{
    if (self = [super init]) {
        s3FileName = [name retain];
        s3Data = [data retain];
        gpsCtntroller = [gps retain];
        progressView = [view retain];
        operationQueue = [[NSOperationQueue alloc] init];
        operationQueue.maxConcurrentOperationCount = 3;
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

- (void)uploaderHasDone:(id)sender dynamoDBKey:(NSString *)pkey
{
    DynamoDBAttributeValue *isReceived = [[DynamoDBAttributeValue alloc] initWithS:@"YES"];
    DynamoDBAttributeValueUpdate *isReceivedUpdate = [[DynamoDBAttributeValueUpdate alloc] initWithValue:isReceived andAction:@"PUT"];
    DynamoDBAttributeValue *url = [[DynamoDBAttributeValue alloc] initWithS:s3FileName];
    DynamoDBAttributeValueUpdate *urlUpdate = [[DynamoDBAttributeValueUpdate alloc] initWithValue:url andAction:@"PUT"];
    [isReceived release];
    [url release];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject: isReceivedUpdate forKey:@"isReceived"];
    [dic setObject:urlUpdate forKey:@"url"];
    
    DynamoDBAttributeValue *id = [[DynamoDBAttributeValue alloc] initWithS:pkey];
    DynamoDBKey *key = [[[DynamoDBKey alloc] initWithHashKeyElement:id] autorelease];
    DynamoDBUpdateItemRequest *request = [[DynamoDBUpdateItemRequest alloc] initWithTableName:TABLE_NAME andKey:key andAttributeUpdates:dic];
    [isReceivedUpdate release];
    [[AmazonClientManager ddbClient] updateItem:request];
    [request release];
}

- (void)updateHasDone:(id)sender
{
    //all receiver's item has been updated
}

@end
