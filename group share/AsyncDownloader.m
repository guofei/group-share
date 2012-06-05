//
//  AsyncDownloader.m
//  group share
//
//  Created by kaku on 12/05/18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <AWSiOSSDK/S3/AmazonS3Client.h>

#import "AsyncDownloader.h"
#import "AWSConstants.h"
#import "ABContactsHelper.h"

@implementation AsyncDownloader

@synthesize delegate;

#pragma mark - Class Lifecycle

-(id)initWithS3:(NSString *)name progressView:(UIProgressView *)theProgressView
{
    self = [super init];
    if (self)
    {
        //maybe need fix!!
        fileName = [name retain];
        progressView = [theProgressView retain];
        _isDownloaded = NO;
        isExecuting = NO;
        isFinished  = NO;
    }
    
    return self;
}

-(void)dealloc
{
    //[fileName release];
    [contactData release];
    [progressView release];
    
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
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    [self performSelectorOnMainThread:@selector(initialize) withObject:nil waitUntilDone:NO];
    if (self.isCancelled) {
        return;
    }
    // Puts the file as an object in the bucket.
    S3GetObjectRequest *getObjectRequest = [[[S3GetObjectRequest alloc] initWithKey:fileName withBucket:BUCKET_NAME] autorelease];
    getObjectRequest.delegate = self;
    AmazonS3Client *s3 = [[[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY] autorelease];
    [s3 getObject:getObjectRequest];
    while (!_isDownloaded && !self.isCancelled) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    
    [pool release];
}

#pragma mark - AmazonServiceRequestDelegate Implementations

-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
    [self performSelectorOnMainThread:@selector(hideProgressView) withObject:nil waitUntilDone:NO];
    
    if (response.isFinishedLoading) {
        contactData = [response.body retain];
        
        if ([self.delegate respondsToSelector:@selector(dataHasDownloaded:keyName:data:)]) {
            [self.delegate dataHasDownloaded:self keyName:fileName data:contactData];
        }
    }
    _isDownloaded = YES;
    //UIImage *image = [UIImage imageWithData:response.body];
    //[self performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
}

-(void)request:(AmazonServiceRequest *)request didReceiveData:(NSData *)data
{
    // The progress bar for downlaod is just an estimate. In order to accurately reflect the progress bar, you need to first retrieve the file size.
    [self performSelectorOnMainThread:@selector(updateProgressView:) withObject:[NSNumber numberWithFloat:[data length] / 150 / 1024] waitUntilDone:NO];
}

-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"eee%@", error);
    _isDownloaded = YES;
}

-(void)request:(AmazonServiceRequest *)request didFailWithServiceException:(NSException *)exception
{
    NSLog(@"xxx%@", exception);
    _isDownloaded = YES;
}

#pragma mark - Helper Methods

-(void)initialize
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
