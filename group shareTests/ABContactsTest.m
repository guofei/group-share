//
//  ABContactsTest.m
//  group share
//
//  Created by kaku on 12/05/17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "ABContactsHelper.h"
#import "ABContactsTest.h"

@implementation ABContactsTest

- (void)setUp
{
    [super setUp];

    // Set-up code here.
    ABAddressBookRef book = ABAddressBookCreate();
    CFArrayRef records = ABAddressBookCopyArrayOfAllPeople(book);
    ABRecordRef person = CFArrayGetValueAtIndex(records, 0);
    contact = [[ABContact contactWithRecord:person] retain];

    NSData *data = [contact baseDataRepresentation];
    ABContact *newContact = [ABContact contactWithData:data];

    NSError *error;
    [ABContactsHelper addContact:newContact withError:&error];

    CFRelease(records);
    CFRelease(book);
}

- (void)tearDown
{
    // Tear-down code here.
    [contact release];
    
    [super tearDown];
}

- (void)testInit {
    STAssertNotNil(contact, @"contact cant init");
}

@end
