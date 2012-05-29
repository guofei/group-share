//
//  AmazonClientManager.h
//  group share
//
//  Created by kaku on 12/05/30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSiOSSDK/DynamoDB/AmazonDynamoDBClient.h>

#import "AWSConstants.h"

@interface AmazonClientManager : NSObject

+ (AmazonDynamoDBClient *)ddbClient;

@end
