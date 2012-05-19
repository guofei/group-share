//
//  AsyncUploader.h
//  group share
//
//  Created by kaku on 12/05/18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AWSiOSSDK/AmazonServiceRequest.h>

@interface AsyncUploader : NSOperation<AmazonServiceRequestDelegate>
{
    NSData         *data;
    UIProgressView *progressView;
    
    BOOL           isExecuting;
    BOOL           isFinished;
}

-(id)initWithData:(NSData *)d progressView:(UIProgressView *)theProgressView;

-(void)finish;
-(void)initializeProgressView;
-(void)updateProgressView:(NSNumber *)theProgress;
-(void)hideProgressView;

@end
