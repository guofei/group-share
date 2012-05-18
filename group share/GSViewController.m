//
//  GSViewController.m
//  group share
//
//  Created by kaku on 12/04/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <AWSiOSSDK/S3/AmazonS3Client.h>
#import "AWSConstants.h"
#import "ABContact.h"

#import "GSViewController.h"

@interface GSViewController ()

@end

@implementation GSViewController

@synthesize contactData;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    if (contactData) {
        [contactData release];
    }
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
    if (contactData) {
        AmazonS3Client *s3 = [[[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY] autorelease];
        
        @try {
            // Upload image data.  Remember to set the content type.
            S3PutObjectRequest *por = [[[S3PutObjectRequest alloc] initWithKey:@"test2" inBucket:BUCKET_NAME] autorelease];
            por.contentType = @"pplication/octet-stream";
            por.data        = contactData;
            
            // Put the image data into the specified s3 bucket and object.
            [s3 putObject:por];
        }
        @catch (AmazonClientException *exception) {
            [AWSConstants showAlertMessage:exception.message withTitle:@"Upload Error"];
        }
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


@end
