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
#import <CoreLocation/CoreLocation.h>

@interface GSViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate, CLLocationManagerDelegate>
{
    IBOutlet UILabel *name;
    IBOutlet UILabel *recive;
    IBOutlet UIProgressView  *uploadProgress1;
    IBOutlet UIProgressView  *downloadProgress1;
    NSData *contactData;
    NSOperationQueue *operationQueue;
    
    CLLocationManager *locationMan;
}

@property (nonatomic, retain) NSData *contactData;
@property (nonatomic, retain) CLLocationManager *locationMan;

- (IBAction)selectPeson:(id)sender;
- (IBAction)send:(id)sender;
- (IBAction)onRecive:(id)sender;
- (IBAction)onRecived:(id)sender;

@end
