//
//  GSUpdateItem.m
//  group share
//
//  Created by kaku on 12/06/03.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <AWSiOSSDK/AmazonServiceRequest.h>
#import <AWSiOSSDK/DynamoDB/DynamoDBAttributeValue.h>

#import "AWSConstants.h"
#import "AmazonClientManager.h"
#import "GSUpdateItem.h"

@implementation GSUpdateItem

- (id)initWithS3KeyName:(NSString *)s3name DynamoKeyName:(NSString *)ddbname
{
    if (self = [super init]) {
        keyName = [s3name retain];
        primaryKey = [ddbname retain];
    }
    return self;
}

- (void)dealloc
{
    [keyName release];
    [primaryKey release];
    
    [super dealloc];
}

-(void)UpdateItem:(id)sender
{
    DynamoDBAttributeValue *isReceived = [[DynamoDBAttributeValue alloc] initWithS:@"YES"];
    DynamoDBAttributeValueUpdate *isReceivedUpdate = [[DynamoDBAttributeValueUpdate alloc] initWithValue:isReceived andAction:@"PUT"];
    [isReceived release];
    DynamoDBAttributeValue *id = [[DynamoDBAttributeValue alloc] initWithS:primaryKey];
    DynamoDBKey *key = [[[DynamoDBKey alloc] initWithHashKeyElement:id] autorelease];
    DynamoDBUpdateItemRequest *request = [[DynamoDBUpdateItemRequest alloc] initWithTableName:TABLE_NAME andKey:key andAttributeUpdates:[NSMutableDictionary dictionaryWithObject: isReceivedUpdate forKey:@"isReceived"]];
    [isReceivedUpdate release];
    [[AmazonClientManager ddbClient] updateItem:request];
    [request release];
}

@end
