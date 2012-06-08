//
//  GSReceiver.h
//  group share
//
//  Created by kaku on 12/06/05.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GSGPSController.h"

@protocol ReceiverDelegate <NSObject>
- (void)itemHasUpdated:(id)sender keyName:(NSString *)s3Filename;
- (void)dataHasDownloaded:(id)sender keyName:(NSString *)s3Filename data:(NSData *)data;
@end

@interface GSReceiver : NSObject<ReceiverDelegate>
{
    NSString *dynamoDBID;
    GSGPSController *gpsCtr;
    UIProgressView  *downloadProgress;
    UILabel *nameLabel;
    UILabel *statusLabel;
    UIImageView *imageView;
    NSOperationQueue *operationQueue;
}

- (id) initWithGPSCtr:(GSGPSController *)gps UILabel:(UILabel *)label UILabel:(UILabel *)status UIImageView:(UIImageView *)view progressView:progress;
- (void) createItem;
- (void) removeItem;

@end
