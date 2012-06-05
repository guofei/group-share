//
//  AsyncUploader.h
//  group share
//
//  Created by kaku on 12/05/18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSiOSSDK/AmazonServiceRequest.h>
#import "GSUpdateItem.h"
#import "GSSender.h"
#import "GSGPSController.h"

@interface AsyncUploader : NSOperation<AmazonServiceRequestDelegate>
{
    id              s3Data;
    NSString        *keyName;
    UIProgressView  *progressView;
    GSGPSController *gpsCtr;
    BOOL            _isUploaded;
    id              <SenderDelegate> delegate;
}

-(id)initWithData:(id)d keyName:(NSString *)name GPS:(GSGPSController *)gps progressView:(UIProgressView *)theProgressView;

-(void)initializeProgressView;
-(void)updateProgressView:(NSNumber *)theProgress;
-(void)hideProgressView;

@property (nonatomic,assign) id<SenderDelegate> delegate;

@end
