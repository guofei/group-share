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

#import "GSViewController.h"

@interface GSViewController ()

@end

@implementation GSViewController

@synthesize contactData;
@synthesize locationMan;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        operationQueue = [[NSOperationQueue mainQueue] retain];
        operationQueue.maxConcurrentOperationCount = 3;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    locationMan = [[CLLocationManager alloc] init];
    if([CLLocationManager locationServicesEnabled]){	
        locationMan.delegate = self;    
        locationMan.distanceFilter = kCLDistanceFilterNone;
        locationMan.desiredAccuracy = kCLLocationAccuracyBest;
        [locationMan startUpdatingLocation];
    }
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

    /*
     
     NSString *test = @"test5";
     AsyncDownloader *downloader1 = [[AsyncDownloader alloc] initWithS3:test progressView:downloadProgress1];
     
     [operationQueue addOperation:downloader1];
     [downloader1 release];
     
     */
    
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSData *data = [[NSKeyedArchiver archivedDataWithRootObject:newLocation] retain];
    GSAsyncCreateItem *item = [[GSAsyncCreateItem alloc] initWithLocation:data withName:@"guofei"];
    [operationQueue addOperation:item];
    [item release];
    NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    [locationMan stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"error: %@",[error localizedDescription]);
}

- (void)onRecived:(id)sender
{
    recive.text = @"Recive";
    
}

- (void)send:(id)sender
{
    if (contactData) {
        AsyncUploader *uploader1 = [[AsyncUploader alloc] initWithData:contactData progressView:uploadProgress1];
        
        [operationQueue addOperation:uploader1];
        [uploader1 release];
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
