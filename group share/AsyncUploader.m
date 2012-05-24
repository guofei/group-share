//
//  AsyncUploader.m
//  group share
//
//  Created by kaku on 12/05/18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <AWSiOSSDK/S3/AmazonS3Client.h>
#import <AWSiOSSDK/AmazonServiceRequest.h>

#import "AsyncUploader.h"
#import "AWSConstants.h"

@implementation AsyncUploader

#pragma mark - Class Lifecycle

-(id)initWithData:(NSData *)d progressView:(UIProgressView *)theProgressView
{
    self = [super init];
    if (self)
    {
        data      = [d retain];
        progressView = [theProgressView retain];
        
        isExecuting = NO;
        isFinished  = NO;
    }
    
    return self;
}

-(void)dealloc
{
    [progressView release];
    [data release];
    
    [super dealloc];
}

#pragma mark - Overwriding NSOperation Methods

/*
 * For concurrent operations, you need to override the following methods:
 * start, isConcurrent, isExecuting and isFinished.
 *
 * Please refer to the NSOperation documentation for more details.
 * http://developer.apple.com/library/ios/#documentation/Cocoa/Reference/NSOperation_class/Reference/Reference.html
 */

-(void)start
{
    // Makes sure that start method always runs on the main thread.
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    [self performSelectorOnMainThread:@selector(initializeProgressView) withObject:nil waitUntilDone:NO];
    
    NSString *bucketName = BUCKET_NAME;
    NSString *keyName    = @"changeme";
    
    // check bucket.

    AmazonS3Client *s3 = [[[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY] autorelease];
    // Puts the file as an object in the bucket.
    S3PutObjectRequest *putObjectRequest = [[[S3PutObjectRequest alloc] initWithKey:keyName inBucket:bucketName] autorelease];
    putObjectRequest.data = data;
    putObjectRequest.contentType = @"application/octet-stream";
    putObjectRequest.delegate = self;
    [s3 putObject:putObjectRequest];
}

-(BOOL)isConcurrent
{
    return YES;
}

-(BOOL)isExecuting
{
    return isExecuting;
}

-(BOOL)isFinished
{
    return isFinished;
}

#pragma mark - AmazonServiceRequestDelegate Implementations

-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
    [self performSelectorOnMainThread:@selector(hideProgressView) withObject:nil waitUntilDone:NO];
    
    [self finish];
}

-(void)request:(AmazonServiceRequest *)request didSendData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    [self performSelectorOnMainThread:@selector(updateProgressView:) withObject:[NSNumber numberWithFloat:totalBytesWritten / totalBytesExpectedToWrite] waitUntilDone:NO];
}

-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
    [AWSConstants showAlertMessage:CREDENTIALS_ALERT_MESSAGE withTitle:@"error"];
    [self finish];
}

-(void)request:(AmazonServiceRequest *)request didFailWithServiceException:(NSException *)exception
{
    NSLog(@"%@", exception);
    
    [self finish];
}

#pragma mark - Helper Methods

-(void)finish
{
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    isExecuting = NO;
    isFinished  = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

-(void)initializeProgressView
{
    progressView.hidden   = NO;
    progressView.progress = 0.0;
}

-(void)updateProgressView:(NSNumber *)theProgress
{
    progressView.progress = [theProgress floatValue];
}

-(void)hideProgressView
{
    progressView.hidden = YES;
}

#pragma mark -

@end
