//
//  GSRemoveItem.m
//  group share
//
//  Created by kaku on 12/06/03.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <AWSiOSSDK/AmazonServiceRequest.h>
#import <AWSiOSSDK/DynamoDB/DynamoDBAttributeValue.h>

#import "AmazonClientManager.h"
#import "GSRemoveItem.h"
#import "AWSConstants.h"

@implementation GSRemoveItem

-(id)initWithitemID:(NSString *)id
{
    if(self = [super init]){
        itemID = [id retain];
    }
    return self;
}

- (void)dealloc
{
    [itemID release];
    [super dealloc];
}

- (void)removeItem
{
    DynamoDBAttributeValue *id = [[DynamoDBAttributeValue alloc] initWithS:itemID];
    DynamoDBDeleteItemRequest *request = [[DynamoDBDeleteItemRequest alloc] 
                                          initWithTableName:TABLE_NAME 
                                          andKey:[[[DynamoDBKey alloc] initWithHashKeyElement:id] autorelease]];
    [[AmazonClientManager ddbClient] deleteItem:request];
    [request release];
}

@end
