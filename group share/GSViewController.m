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

@interface GSViewController ()

@end

@implementation GSViewController

@synthesize contactData, gps, ddbID, keyName;

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
        gps = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    gps = [[GSGPSController alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [contactData release];
    contactData = nil;
    [keyName release];
    keyName = nil;
    [gps release];
    gps = nil;
    // Release any retained subviews of the main view.

}

- (void)dealloc
{
    [ddbID release];
    [contactData release];
    [keyName release];
    [gps release];
    
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

        self.ddbID = [NSString stringWithFormat:@"%@#%d",[[NSDate date] description],rand()%100000];
        NSString *deviceUDID = [[UIDevice currentDevice] name];
        GSAsyncCreateItem *item = [[GSAsyncCreateItem alloc] initWithName:deviceUDID ID:ddbID GPS:gps];
        item.delegate = self;
        [operationQueue addOperation:item];
        [item release];
    }
}

- (void)onRecived:(id)sender
{
    recive.text = @"";
    [operationQueue cancelAllOperations];
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
    if ([CLLocationManager locationServicesEnabled]) {
        if (contactData) {
            AsyncUploader *uploader = [[AsyncUploader alloc] initWithData:contactData keyName:keyName GPS:gps progressView:uploadProgress1];
            [operationQueue addOperation:uploader];
            [uploader release];
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
    ABContact *contact = [ABContact contactWithRecord:person];
    NSData *data = [contact baseDataRepresentation];
    NSLog(@"data %@", [data description]);
    
    keyName = [[NSString stringWithFormat:@"%@_%@.ab", contact.contactName, [[NSDate date] description]] retain];
    self.contactData = data;
    
    name.text = contact.contactName;
    UIImage *image = [UIImage imageNamed:@"name.png"];
    imageView.image = image;
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
         didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary*)editingInfo {  
    // image を処理
    /*
    UIImage *img_ato;  // リサイズ後UIImage
    float widthPer = 0.5;  // リサイズ後幅の倍率
    float heightPer = 0.5;  // リサイズ後高さの倍率
    CGSize sz = CGSizeMake(image.size.width*widthPer, image.size.height*heightPer);
    UIGraphicsBeginImageContext(sz);
    [image drawInRect:CGRectMake(0, 0, sz.width, sz.height)];
    img_ato = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); 
    */
    //NSDictionary *imageData = [NSDictionary dictionaryWithObject:image forKey:@"image"];
    [image retain];
    @try {
        [NSThread detachNewThreadSelector:@selector(setImageThread:) toTarget:self withObject:image];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }

    //[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(setImage:) userInfo:imageData repeats:NO];
    [picker dismissModalViewControllerAnimated:YES];  
}

- (void) setImageThread:(id)image
{
    NSAutoreleasePool* pool;
    pool = [[NSAutoreleasePool alloc]init];
    
    name.text = @"";
    imageView.image = image;
    imageView.hidden = NO;
    NSData *data = [[NSData alloc] initWithData:UIImagePNGRepresentation(image)];
    keyName = [[NSString stringWithFormat:@"%@_%@.png", @"img", [[NSDate date] description]] retain];
    self.contactData = data;
    [data release];
    
    [pool release];
    [NSThread exit];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController*)picker {  
    //キャンセル時の処理
    [picker dismissModalViewControllerAnimated:YES];  
}

- (void)itemHasUpdated:(id)sender keyName:(NSString *)s3Filename
{
    AsyncDownloader *downloader = [[AsyncDownloader alloc] initWithS3:s3Filename progressView:downloadProgress1];
    [operationQueue addOperation:downloader];
    downloader.delegate = self;
    [downloader release];
}

- (void)dataHasDownloaded:(id)sender keyName:(NSString *)s3Filename data:(NSData *)data
{
    if ([s3Filename hasSuffix:@".ab"]) {
        ABContact *newContact = [ABContact contactWithData:data];
        NSError *error;
        [ABContactsHelper addContact:newContact withError:&error];
        name.text = newContact.contactName;
        UIImage *image = [UIImage imageNamed:@"name.png"];
        imageView.image = image;
        imageView.hidden = NO;
    }
    if ([s3Filename hasSuffix:@".png"]) {
        UIImage* image = [[[UIImage alloc] initWithData:data] autorelease];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(savingImageIsFinished:didFinishSavingWithError:contextInfo:), nil);
        imageView.image = image;
        imageView.hidden = NO;
    }
}

// 完了を知らせるメソッド
- (void) savingImageIsFinished:(UIImage *)_image
      didFinishSavingWithError:(NSError *)_error
                   contextInfo:(void *)_contextInfo
{
    NSLog(@"finished"); //仮にコンソールに表示する
}

@end
