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

#import "GSDownloadDelegate.h"

@interface GSViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate, GSDownloadDelegate>
{
    IBOutlet UILabel *name;
    IBOutlet UILabel *recive;
    IBOutlet UIProgressView  *uploadProgress1;
    IBOutlet UIProgressView  *downloadProgress1;
    NSString *ddbID;
    NSString *keyName;
    NSData *contactData;
    NSOperationQueue *operationQueue;
}

@property (nonatomic, retain) NSData *contactData;

- (IBAction)selectPeson:(id)sender;
- (IBAction)send:(id)sender;
- (IBAction)onRecive:(id)sender;
- (IBAction)onRecived:(id)sender;

@end
