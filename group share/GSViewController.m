//
//  GSViewController.m
//  group share
//
//  Created by kaku on 12/04/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <AWSiOSSDK/STS/AmazonSecurityTokenServiceClient.h>
#import <AWSiOSSDK/S3/AmazonS3Client.h>
#import <AWSiOSSDK/AmazonCredentials.h>
#import <AWSiOSSDK/SimpleDB/AmazonSimpleDBClient.h>
#import <AWSiOSSDK/DynamoDB/AmazonDynamoDBClient.h>
#import <AWSiOSSDK/DynamoDB/DynamoDBAttributeValue.h>
#import "AWSConstants.h"
#import "ABContact.h"
#import "AsyncUploader.h"
#import "AsyncDownloader.h"

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
        operationQueue = [NSOperationQueue new];
        operationQueue.maxConcurrentOperationCount = 3;
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

- (void)onRecived:(id)sender
{
    recive.text = @"Recive";
    
    AmazonSecurityTokenServiceClient *tst = [[[AmazonSecurityTokenServiceClient alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY] autorelease];
    SecurityTokenServiceGetSessionTokenRequest *request = [[[SecurityTokenServiceGetSessionTokenRequest alloc] init] autorelease];
    SecurityTokenServiceGetSessionTokenResponse *rep = [tst getSessionToken:request];
    
    SecurityTokenServiceCredentials *c = [rep credentials];
    
    AmazonCredentials *credentials = [[[AmazonCredentials alloc] initWithAccessKey:c.accessKeyId withSecretKey:c.secretAccessKey withSecurityToken:c.sessionToken] autorelease];
    AmazonDynamoDBClient *ddb = [[[AmazonDynamoDBClient alloc] initWithCredentials:credentials] autorelease];
    
    
    @try {
        /*
        DynamoDBKeySchemaElement *kse = [[[DynamoDBKeySchemaElement alloc] 
                                          initWithAttributeName:@"userNo" 
                                          andAttributeType:@"N"] autorelease];
        
        DynamoDBKeySchema *ks = [[[DynamoDBKeySchema alloc] 
                                  initWithHashKeyElement:kse] autorelease];
        
        DynamoDBProvisionedThroughput *pt = [[[DynamoDBProvisionedThroughput alloc] init] autorelease];
        pt.readCapacityUnits  = [NSNumber numberWithInt:10];
        pt.writeCapacityUnits = [NSNumber numberWithInt:5];
        
        DynamoDBCreateTableRequest *request4 = [[DynamoDBCreateTableRequest alloc] 
                                                initWithTableName:@"test" 
                                                andKeySchema:ks 
                                                andProvisionedThroughput:pt];
        
        DynamoDBCreateTableResponse *response4 = [ddb createTable:request4];
        [request4 release];
        
        */
        
        DynamoDBAttributeValue *v1 = [[[DynamoDBAttributeValue alloc] initWithN:@"123456"] autorelease];
        DynamoDBAttributeValue *v2 = [[[DynamoDBAttributeValue alloc] initWithS:@"guo"] autorelease];
        DynamoDBAttributeValue *v3 = [[[DynamoDBAttributeValue alloc] initWithS:@"fei"] autorelease];
        NSMutableDictionary *userDic = [[NSDictionary dictionaryWithObjectsAndKeys:
                                         v1, @"id", v2, @"firstName", v3, @"lastName", nil] autorelease];
        
        DynamoDBDescribeTableRequest *request = [[[DynamoDBDescribeTableRequest alloc] initWithTableName:@"test"] autorelease];
        DynamoDBDescribeTableResponse *response = [[ddb describeTable:request] autorelease];
        
        NSLog(@"response:%@",response);
        //NSString *status = response.table.tableStatus;
        
        
        DynamoDBScanRequest *requestt = [[[DynamoDBScanRequest alloc] initWithTableName:@"test"] autorelease];
        DynamoDBScanResponse *responses = [[ddb scan:requestt] autorelease];
        
        NSMutableArray *users = responses.items;
        NSLog(@"array: %@", users);
        
        DynamoDBPutItemRequest *request2 = [[DynamoDBPutItemRequest alloc] initWithTableName:@"test" andItem:userDic];
        DynamoDBPutItemResponse *repq = [ddb putItem:request2];
        NSLog(@"rep   %@", repq);
        if (YES) {
            int i = 0;
            i++;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }

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
