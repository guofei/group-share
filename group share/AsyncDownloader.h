//
//  AsyncDownloader.h
//  group share
//
//  Created by kaku on 12/05/18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsyncDownloader : NSOperation<AmazonServiceRequestDelegate>
{
    NSString       *fileName;
    NSData         *contactData;
    UIProgressView *progressView;
    
    BOOL           isExecuting;
    BOOL           isFinished;
}

@property (nonatomic, readonly) NSData* contactData;

-(id)initWithS3:(NSString *)name progressView:(UIProgressView *)theProgressView;
-(void)finish;
-(void)initialize;
-(void)updateProgressView:(NSNumber *)theProgress;
-(void)hideProgressView;

@end
