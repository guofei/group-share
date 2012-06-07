//
//  GSReceiveViewController.h
//  group share
//
//  Created by kaku on 12/06/07.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GSReceiver.h"
#import "GSDownloadDelegate.h"

@interface GSReceiveViewController : UIViewController
{
    IBOutlet UILabel *name;
    IBOutlet UILabel *recive;
    IBOutlet UIImageView *imageView;
    IBOutlet UIProgressView  *downloadProgress1;
    
    GSGPSController *gps;
    GSReceiver *gsReceiver;

}

@property (nonatomic, retain) GSGPSController *gps;
- (IBAction)onRecive:(id)sender;
- (IBAction)onRecived:(id)sender;

@end
