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
#import "GSGPSController.h"

@interface AsyncUploader : NSOperation<AmazonServiceRequestDelegate>
{
    NSString       *keyName;
    NSData         *data;
    UIProgressView *progressView;
    GSGPSController *gpsCtr;
    BOOL           isExecuting;
    BOOL           isFinished;
    id             <UpdateDelegate> delegate;
}

-(id)initWithData:(NSData *)d keyName:(NSString *)name GPS:(GSGPSController *)gps progressView:(UIProgressView *)theProgressView;

-(void)finish;
-(void)initializeProgressView;
-(void)updateProgressView:(NSNumber *)theProgress;
-(void)hideProgressView;

@property (nonatomic,assign) id<UpdateDelegate> delegate;

@end
