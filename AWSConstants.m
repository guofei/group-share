//
//  AWSConstant.m
//  group share
//
//  Created by kaku on 12/05/18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AWSConstants.h"

@implementation AWSConstants

+(UIAlertView *)credentialsAlert
{
    return [[[UIAlertView alloc] initWithTitle:@"AWS Credentials" message:CREDENTIALS_ALERT_MESSAGE delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
}

@end
