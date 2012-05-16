//
//  personTest.m
//  group share
//
//  Created by kaku on 12/05/13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "personTest.h"

@implementation personTest

- (void)setUp
{
    [super setUp];

    ABAddressBookRef book = ABAddressBookCreate();
    CFArrayRef records = ABAddressBookCopyArrayOfAllPeople(book);
    ABRecordRef person = CFArrayGetValueAtIndex(records, 0);

    _person = [[GSPerson alloc] initWithRecord:person];
    [_person addToAddressBook];
    data = [NSKeyedArchiver archivedDataWithRootObject:_person];

    data_to_person = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    [data_to_person addToAddressBook];

    CFRelease(book);
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.

    [_person release];
    //[data release];
    //[data_to_person release];
    [super tearDown];
}

- (void)testInit {
    STAssertNotNil(_person, @"Person cant init");
}

@end
