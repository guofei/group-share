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
#import "ABContactsHelper.h"

#import "GSViewController.h"

@implementation GSViewController

@synthesize gps, ddbID, keyName, s3Data;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        operationQueue = [[NSOperationQueue alloc] init];
        operationQueue.maxConcurrentOperationCount = 3;
        gps = [[GSGPSController alloc] init];
        ddbID = nil;
        keyName = nil;
        s3Data = nil;
        gps = nil;
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
    
    [super viewDidUnload];
}

- (void)dealloc
{
    [ddbID release];
    [s3Data release];
    [keyName release];
    [gps release];
    [gsSender release];
    [gsReceiver release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)onRecive:(id)sender
{
    if ([CLLocationManager locationServicesEnabled]) {
        recive.text = @"Waiting for recive";
        gsReceiver = [[GSReceiver alloc] initWithGPSCtr:gps UILabel:name UIImageView:imageView progressView:downloadProgress1];
        [gsReceiver createItem];
    }
}

- (void)onRecived:(id)sender
{
    recive.text = @"";
    [gsReceiver removeItem];
}

- (void)send:(id)sender
{
    if ([CLLocationManager locationServicesEnabled]) {
        gsSender = [[GSSender alloc] initWithS3FileName:keyName s3Data:s3Data gpsCtr:gps progressView:uploadProgress1];
        [gsSender uploadData];
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
    ABContact *contact = [ABContact contactWithRecord:person];
    NSData *data = [contact baseDataRepresentation];
    NSLog(@"data %@", [data description]);
    
    self.keyName = [NSString stringWithFormat:@"%@_%@.ab", contact.contactName, [[NSDate date] description]];
    self.s3Data = data;
    
    name.text = contact.contactName;
    imageView.image = [UIImage imageNamed:@"name.png"];
    imageView.hidden = NO;
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

- (void) imagePickerController:(UIImagePickerController*)picker  
         didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary*)editingInfo
{  
    name.text = @"";
    [imageView setImage:image];
    imageView.hidden = NO;
    //NSData *data = [[NSData alloc] initWithData:UIImagePNGRepresentation(image)];
    keyName = [[NSString stringWithFormat:@"%@_%@.jpg", @"img", [[NSDate date] description]] retain];
    self.s3Data = image;

    [picker dismissModalViewControllerAnimated:YES];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController*)picker
{  
    //キャンセル時の処理
    [picker dismissModalViewControllerAnimated:YES];  
}

// 完了を知らせるメソッド
- (void) savingImageIsFinished:(UIImage *)_image
      didFinishSavingWithError:(NSError *)_error
                   contextInfo:(void *)_contextInfo
{
    NSLog(@"finished"); //仮にコンソールに表示する
}

@end
