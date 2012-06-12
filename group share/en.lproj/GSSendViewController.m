//
//  GSViewController.m
//  group share
//
//  Created by kaku on 12/04/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AWSConstants.h"
#import "ABContactsHelper.h"
#import "GSImageHelper.h"
#import "GSSendViewController.h"

@implementation GSSendViewController

@synthesize gps, keyName, s3Data;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = NSLocalizedString(@"Send", @"Send");
        self.tabBarItem.image = [UIImage imageNamed:@"upload.png"];
        keyName = nil;
        s3Data = nil;
        gsSender = nil;
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
    [s3Data release];
    s3Data = nil;
    [keyName release];
    keyName = nil;
    [gps release];
    gps = nil;
    [gsSender release];
    gsSender = nil;
    
    [super viewDidUnload];
}

- (void)dealloc
{
    [s3Data release];
    [keyName release];
    [gps release];
    [gsSender release];    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)send:(id)sender
{
    if ([CLLocationManager locationServicesEnabled]) {
        if (s3Data && keyName) {
            gsSender = [[GSSender alloc] initWithS3FileName:keyName s3Data:s3Data gpsCtr:gps progressView:uploadProgress1];
            [gsSender uploadData];
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

- (void)selectImage:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];  
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;  
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
    //imageView.hidden = YES;
    imageView.image = nil;
    ABContact *contact = [ABContact contactWithRecord:person];
    NSData *data = [contact baseDataRepresentation];
    NSLog(@"data %@", [data description]);
    
    self.keyName = [NSString stringWithFormat:@"%@_%@.ab", contact.contactName, [[NSDate date] description]];
    self.s3Data = data;
    name.text = contact.contactName;
    imageView.hidden = NO;
    shareButton.hidden = NO;
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

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    [picker dismissModalViewControllerAnimated:YES];
    
    imageView.hidden = YES;
    name.text = @"";
    //CGSize size = {90, 90};
    //UIImage *small = [GSImageHelper imageWithImage:[info objectForKey:UIImagePickerControllerOriginalImage] scaledToSize:size];
    imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    imageView.hidden = NO;
    self.keyName = [NSString stringWithFormat:@"%@_%@.jpg", @"img", [[NSDate date] description]];
    self.s3Data = [info objectForKey:UIImagePickerControllerOriginalImage];
    shareButton.hidden = NO;
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController*)picker
{  
    //キャンセル時の処理
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)gotoReceive:(id)sender
{
    
}

@end
