//
//  AsyncUploader.m
//  group share
//
//  Created by kaku on 12/05/18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <AWSiOSSDK/S3/AmazonS3Client.h>

#import "GSGPSController.h"
#import "AsyncUploader.h"
#import "AWSConstants.h"
#import "GSNearPerson.h"

@implementation AsyncUploader

@synthesize delegate;

#pragma mark - Class Lifecycle

-(id)initWithData:(id)d keyName:(NSString *)name GPS:(GSGPSController *)gps progressView:(UIProgressView *)theProgressView
{
    self = [super init];
    if (self)
    {
        s3Data    = [d retain];
        keyName   = [name retain];
        gpsCtr    = [gps retain];
        progressView = [theProgressView retain];
    }
    
    return self;
}

-(void)dealloc
{
    [progressView release];
    [keyName release];
    [s3Data release];
    [gpsCtr release];

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

-(void)main
{    
    [self performSelectorOnMainThread:@selector(initializeProgressView) withObject:nil waitUntilDone:NO];
    
    NSString *bucketName = BUCKET_NAME;
    
    // check bucket.

    AmazonS3Client *s3 = [[[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY] autorelease];
    // Puts the file as an object in the bucket.
    S3PutObjectRequest *putObjectRequest = [[S3PutObjectRequest alloc] initWithKey:keyName inBucket:bucketName];
    if ([keyName hasSuffix:@".ab"]) {
        putObjectRequest.data = s3Data;
    }
    if ([keyName hasSuffix:@".jpg"]) {
        NSData *data = [[NSData alloc] initWithData:UIImageJPEGRepresentation(s3Data, 0)];
        putObjectRequest.data = data;
        [data release];
    }

    putObjectRequest.contentType = @"application/octet-stream";
    putObjectRequest.delegate = self;
    [s3 putObject:putObjectRequest];
    [putObjectRequest release];
    while (!_isUploaded && !self.isCancelled) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    if ([self.delegate respondsToSelector:@selector(updateHasDone:)] && !self.isCancelled) {
        [self.delegate updateHasDone:self];
    }
}

#pragma mark - AmazonServiceRequestDelegate Implementations

-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
    [self performSelectorOnMainThread:@selector(hideProgressView) withObject:nil waitUntilDone:NO];
    
    while (!gpsCtr.lastReading) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }

    if ([self.delegate respondsToSelector:@selector(uploaderHasDone:)]) {
        [self.delegate uploaderHasDone:self];
    }
    _isUploaded = YES;
}

-(void)request:(AmazonServiceRequest *)request didSendData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    [self performSelectorOnMainThread:@selector(updateProgressView:) withObject:[NSNumber numberWithFloat:totalBytesWritten / totalBytesExpectedToWrite] waitUntilDone:NO];
}

-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
    [AWSConstants showAlertMessage:CREDENTIALS_ALERT_MESSAGE withTitle:@"error"];
    _isUploaded = YES;
}

-(void)request:(AmazonServiceRequest *)request didFailWithServiceException:(NSException *)exception
{
    NSLog(@"%@", exception);
    _isUploaded = YES;
}

#pragma mark - Helper Methods

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
