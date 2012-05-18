//
//  AWSConstant.h
//  group share
//
//  Created by kaku on 12/05/18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define ACCESS_KEY_ID                @"change me"
#define SECRET_KEY                   @"change me"
#define CREDENTIALS_ALERT_MESSAGE    @"Please update the Constants.h file with your credentials or Token Vending Machine URL."

#define BUCKET_NAME         @"change me"

#import <Foundation/Foundation.h>

@interface AWSConstants : NSObject

/**
 * Utility method to display an alert message.  Used to communicate errors and failures.
 */
+(void)showAlertMessage:(NSString *)message withTitle:(NSString *)title;

+(UIAlertView *)credentialsAlert;

@end
