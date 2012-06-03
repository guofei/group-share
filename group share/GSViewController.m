//
//  GSViewController.m
//  group share
//
//  Created by kaku on 12/04/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AWSConstants.h"
#import "ABContact.h"
#import "AsyncUploader.h"
#import "AsyncDownloader.h"
#import "GSAsyncCreateItem.h"
#import "GSRemoveItem.h"

#import "GSViewController.h"

@interface GSViewController ()

@end

@implementation GSViewController

@synthesize contactData;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        operationQueue = [[NSOperationQueue alloc] init];
        operationQueue.maxConcurrentOperationCount = 3;
        ddbID = nil;
        keyName = nil;
        contactData = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [contactData release];
    [keyName release];
    contactData = nil;
    keyName = nil;
    // Release any retained subviews of the main view.

}

- (void)dealloc
{
    [ddbID release];
    [contactData release];
    [keyName release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)onRecive:(id)sender
{
    recive.text = @"Waiting for recive";
    NSDate *date = [NSDate date];
    ddbID = [[NSString stringWithFormat:@"%@#%d",[date description],rand()%100000] retain];
    NSString *deviceUDID = [[UIDevice currentDevice] name];
    GSAsyncCreateItem *item = [[GSAsyncCreateItem alloc] initWithName:deviceUDID ID:ddbID];
    item.delegate = self;
    [operationQueue addOperation:item];
    [item release];
}

- (void)onRecived:(id)sender
{
    recive.text = @"";
    if (ddbID) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            GSRemoveItem *rmItem = [[GSRemoveItem alloc] initWithitemID:ddbID];
            [rmItem removeItem];
            [rmItem release];
        });
    }
}

- (void)send:(id)sender
{
    if (contactData) {
        AsyncUploader *uploader = [[AsyncUploader alloc] initWithData:contactData keyName:keyName progressView:uploadProgress1];
        [operationQueue addOperation:uploader];
        [uploader release];
    }
}

- (void)selectPeson:(id)sender
{
    ABPeoplePickerNavigationController *picker =
        [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

- (void)peoplePickerNavigationControllerDidCancel:
    (ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController:
    (ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    ABContact *contact = [ABContact contactWithRecord:person];
    NSData *data = [contact baseDataRepresentation];
    NSLog(@"data %@", [data description]);
    
    keyName = [[NSString stringWithFormat:@"%@_%@", contact.contactName, [[NSDate date] description]] retain];
    self.contactData = data;
    name.text = contact.firstname;
    [self dismissModalViewControllerAnimated:YES];

    return NO;
}

- (BOOL)peoplePickerNavigationController:
    (ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    /*
      ABMultiValueRef phoneProperty = ABRecordCopyValue(person,property);
      NSString *phone = (NSString *)ABMultiValueCopyValueAtIndex(phoneProperty,identifier);

      NSLog(@"phone: %@",phone);
      [phone release];

      [self dismissModalViewControllerAnimated:YES];
    */
    return NO;
}

- (void)itemHasUpdated:(id)sender itemID:(NSString *)id
{
    AsyncDownloader *downloader = [[AsyncDownloader alloc] initWithS3:keyName progressView:downloadProgress1];
    [operationQueue addOperation:downloader];
    [downloader release];
}

@end
