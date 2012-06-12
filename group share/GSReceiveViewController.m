//
//  GSReceiveViewController.m
//  group share
//
//  Created by kaku on 12/06/07.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "GSReceiveViewController.h"

@interface GSReceiveViewController ()

@end

@implementation GSReceiveViewController

@synthesize gps;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Receive", @"Receive");
        self.tabBarItem.image = [UIImage imageNamed:@"download.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    imageView.userInteractionEnabled = YES;
    imageView.tag = 101;
    name.text = nil;
    imageView.image = nil;
    recive.text = NSLocalizedString(@"Press and hold", @"Press and hold the button to wait for receiving data.");
    recive.textAlignment = UITextAlignmentCenter;
    downloadProgress1.progress = 0;
}

- (void)viewDidUnload
{
    [gsReceiver release];
    [gps release];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [gsReceiver release];
    [gps release];

    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onRecive:(id)sender
{
    if ([CLLocationManager locationServicesEnabled]) {
        recive.text = NSLocalizedString(@"wait receive", @"Waiting for receiving Data...");
        gsReceiver = [[GSReceiver alloc] initWithGPSCtr:gps UILabel:name UILabel:recive UIImageView:imageView progressView:downloadProgress1];
        [gsReceiver createItem];
    }
    downloadProgress1.hidden = NO;
}

- (void)onRecived:(id)sender
{
    recive.text = NSLocalizedString(@"Press and hold", @"Press and hold the button to wait for receiving data.");
    downloadProgress1.hidden = YES;
    [gsReceiver removeItem];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ( touch.view.tag == imageView.tag )
        [self receiveDidTouched:self];
}

- (void)receiveDidTouched:(id)sender
{
    NSLog(@"touch!!");
    if (imageView.image) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];  
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;  
        [sender presentModalViewController:picker animated:YES];  
        [picker release];  
    }
    if (name.text) {
        ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
        picker.peoplePickerDelegate = self;
        [sender presentModalViewController:picker animated:YES];
        [picker release];
    }
}

- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    [self dismissModalViewControllerAnimated:YES];
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

@end
