//
//  GSSender.h
//  group share
//
//  Created by kaku on 12/06/05.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GSGPSController.h"

@protocol SenderDelegate<NSObject>
- (void)uploaderHasDone:(id)sender dynamoDBKey:(NSString *)pkey;
- (void)updateHasDone:(id)sender;
@end

@interface GSSender : NSObject<SenderDelegate>
{
    NSString *s3FileName;
    id s3Data;
    GSGPSController *gpsCtntroller;
    UIProgressView  *progressView;
    NSOperationQueue *operationQueue;
}

- (id) initWithS3FileName:(NSString *)name s3Data:(id)data gpsCtr:(GSGPSController *)gps progressView:(UIProgressView *)view;
- (void) uploadData;

@end
