//
//  AmazonClientManager.m
//  group share
//
//  Created by kaku on 12/05/30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <AWSiOSSDK/AmazonCredentials.h>
#import <AWSiOSSDK/STS/AmazonSecurityTokenServiceClient.h>

#import "AmazonClientManager.h"

@implementation AmazonClientManager

+ (AmazonDynamoDBClient *)ddbClient
{
    AmazonDynamoDBClient *ddb = Nil;
    AmazonSecurityTokenServiceClient *tst = [[AmazonSecurityTokenServiceClient alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
    SecurityTokenServiceGetSessionTokenRequest *tokenRequest = [[SecurityTokenServiceGetSessionTokenRequest alloc] init];
    
    @try {
        SecurityTokenServiceGetSessionTokenResponse *rep = [tst getSessionToken:tokenRequest];
        SecurityTokenServiceCredentials *c = [rep credentials];
        AmazonCredentials *credentials = [[AmazonCredentials alloc] initWithAccessKey:c.accessKeyId withSecretKey:c.secretAccessKey withSecurityToken:c.sessionToken];
        ddb = [[[AmazonDynamoDBClient alloc] initWithCredentials:credentials] autorelease];
        [credentials release];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    @finally {
        [tst release];
        [tokenRequest release];
    }
    return ddb;
}

@end
