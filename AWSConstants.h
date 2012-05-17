//
//  AWSConstant.h
//  group share
//
//  Created by kaku on 12/05/18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define ACCESS_KEY_ID                @"xCHANGE ME"
#define SECRET_KEY                   @"xCHANGE ME"
#define CREDENTIALS_ALERT_MESSAGE    @"Please update the Constants.h file with your credentials or Token Vending Machine URL."

#import <Foundation/Foundation.h>

@interface AWSConstants : NSObject

+(UIAlertView *)credentialsAlert;

@end
