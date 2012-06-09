//
//  GSSender.h
//  group share
//
//  Created by kaku on 12/06/05.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GSGPSController.h"
#import "GSNearPerson.h"

@protocol SenderDelegate<NSObject>
- (void)uploaderHasDone:(id)sender nearPerson:(NSMutableDictionary *)nearPerson;
- (void)updateHasDone:(id)sender;
@end

@interface GSSender : NSObject<SenderDelegate>
{
    NSString *s3FileName;
    id s3Data;
    GSGPSController *gpsCtntroller;
    UIProgressView  *progressView;
    NSOperationQueue *operationQueue;
   // GSNearPerson *_nearPerson;
}

//@property (nonatomic, retain) GSNearPerson *nearPerson;

- (id)initWithS3FileName:(NSString *)name s3Data:(id)data gpsCtr:(GSGPSController *)gps progressView:(UIProgressView *)view;
- (void)uploadData;

@end
