//
//  GSViewController.m
//  group share
//
//  Created by kaku on 12/04/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GSViewController.h"

@interface GSViewController ()

@end

@implementation GSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)onRecive:(id)sender
{
    recive.text = @"Reciving";
}

- (void)onRecived:(id)sender
{
    recive.text = @"Recive";
}

- (void)send:(id)sender
{
    
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
    NSString *first_name = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *last_name = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    NSString *tel1,*tel2;
    ABMultiValueRef tels = ABRecordCopyValue(person, kABPersonPhoneProperty);

    NSString *lab;
    if (ABMultiValueGetCount(tels) > 0) {
        tel1 = (NSString *)ABMultiValueCopyValueAtIndex(tels, 0);
        if (ABMultiValueGetCount(tels) > 1) {
            tel2 = (NSString *)ABMultiValueCopyValueAtIndex(tels, 1);
            lab = (NSString *)ABMultiValueCopyLabelAtIndex(tels, 1);
        }
    }
    CFRelease(tels);
    
    [last_name release];
    [first_name release];
    
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


@end
