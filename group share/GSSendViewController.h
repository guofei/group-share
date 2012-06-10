//
//  GSViewController.h
//  group share
//
//  Created by kaku on 12/04/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "GSSender.h"

#import "GSGPSController.h"

@interface GSSendViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    IBOutlet UILabel *name;
    IBOutlet UIImageView *imageView;
    IBOutlet UIProgressView  *uploadProgress1;
    IBOutlet UIButton *shareButton;
    GSSender *gsSender;
    id s3Data;
    GSGPSController *gps;
}

@property (nonatomic, retain) GSGPSController *gps;
@property (nonatomic, retain) NSString *keyName;
@property (nonatomic, retain) id s3Data;

- (IBAction)selectPeson:(id)sender;
- (IBAction)selectImage:(id)sender;
- (IBAction)send:(id)sender;

@end
