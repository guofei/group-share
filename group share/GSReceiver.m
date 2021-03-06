//
//  GSReceiver.m
//  group share
//
//  Created by kaku on 12/06/05.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GSReceiver.h"
#import "AsyncDownloader.h"
#import "GSRemoveItem.h"
#import "GSAsyncCreateItem.h"
#import "ABContact.h"
#import "ABContactsHelper.h"

@interface GSReceiver()
{
        NSString *dynamoDBID;
        GSGPSController *gpsCtr;
        UIProgressView  *downloadProgress;
        UILabel *nameLabel;
        UILabel *statusLabel;
        UIImageView *imageView;
        NSOperationQueue *operationQueue;
}
@end

@implementation GSReceiver

- (id)initWithGPSCtr:(GSGPSController *)gps UILabel:(UILabel *)label UILabel:(UILabel *)status UIImageView:(UIImageView *)view progressView:(id)progress
{
    if (self = [super init]) {
        downloadProgress = [progress retain];
        gpsCtr = [gps retain];
        nameLabel = [label retain];
        statusLabel = [status retain];
        imageView = [view retain];
        operationQueue = [[NSOperationQueue alloc] init];
        operationQueue.maxConcurrentOperationCount = 3;
    }
    return self;
}

- (void)dealloc
{
    [downloadProgress release];
    [dynamoDBID release];
    [gpsCtr release];
    [nameLabel release];
    [statusLabel release];
    [imageView release];
    [operationQueue cancelAllOperations];
    [operationQueue release];

    [super dealloc];
}

- (void)createItem
{
    dynamoDBID = [[NSString stringWithFormat:@"%@#%d",[[NSDate date] description],rand()%100000] retain];
    NSString *deviceUDID = [[UIDevice currentDevice] name];
    GSAsyncCreateItem *item = [[GSAsyncCreateItem alloc] initWithName:deviceUDID ID:dynamoDBID GPS:gpsCtr];
    item.delegate = self;
    [operationQueue addOperation:item];
    [item release];
}

- (void)removeItem
{
    [operationQueue cancelAllOperations];
    if (dynamoDBID) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            GSRemoveItem *rmItem = [[GSRemoveItem alloc] initWithitemID:dynamoDBID];
            [rmItem removeItem];
            [rmItem release];
        });
    }
}

- (void)itemHasUpdated:(id)sender keyName:(NSString *)filename
{
    AsyncDownloader *downloader = [[AsyncDownloader alloc] initWithS3:filename progressView:downloadProgress];
    [operationQueue addOperation:downloader];
    downloader.delegate = self;
    [downloader release];
}

- (void)dataHasDownloaded:(id)sender keyName:(NSString *)s3Filename data:(NSData *)data
{
    if ([s3Filename hasSuffix:@".ab"]) {
        ABContact *newContact = [ABContact contactWithData:data];
        NSError *error;
        [ABContactsHelper addContact:newContact withError:&error];
        nameLabel.text = newContact.contactName;
        UIImage *image = nil;
        statusLabel.text = @"Received!";
        imageView.image = image;
        imageView.hidden = NO;
    }
    if ([s3Filename hasSuffix:@".jpg"]) {
        UIImage* image = [[[UIImage alloc] initWithData:data] autorelease];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(savingImageIsFinished:didFinishSavingWithError:contextInfo:), nil);
        nameLabel.text = nil;
        statusLabel.text = @"Received!";
        imageView.image = image;
        imageView.hidden = NO;
    }
}

- (void) savingImageIsFinished:(UIImage *)_image
      didFinishSavingWithError:(NSError *)_error
                   contextInfo:(void *)_contextInfo
{
    NSLog(@"save image error");
}

@end
