//
//  GSPerson.m
//  group share
//
//  Created by kaku on 12/05/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "GSPerson.h"
#import "GSContactStringConstants.h"

@implementation GSPerson

@synthesize name,phone,address;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self){
        name = [[aDecoder decodeObjectForKey:@"name"] retain];
        phone = [[aDecoder decodeObjectForKey:@"phone"] retain];
        address = [[aDecoder decodeObjectForKey:@"address"] retain];
    }
    return self;
}

-(id)initWithRecord:(ABRecordRef)person
{
    self = [super init];
    if (self) {
        name = [[NSMutableDictionary dictionary] retain];
        NSString *first_name = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString *mid_name = (NSString * )ABRecordCopyValue(person, kABPersonMiddleNameProperty);
        NSString *last_name = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        if (first_name) {
            [name setObject:first_name forKey:FIRST_NAME_STRING];
            [first_name release];
        }
        if (mid_name) {
            [name setObject:mid_name forKey:MIDDLE_NAME_STRING];
            [mid_name release];
        }
        if (last_name) {
            [name setObject:last_name forKey:LAST_NAME_STRING];
            [last_name release];
        }
    }
    return self;
}

-(void)addToAddressBook
{
    NSString *first_name = [name objectForKey:FIRST_NAME_STRING];
    NSString *mid_name = [name objectForKey:MIDDLE_NAME_STRING];
    NSString *last_name = [name objectForKey:LAST_NAME_STRING];

    ABAddressBookRef addressBook;
    bool wantToSaveChanges = YES;
    bool didSave, didSet;
    CFErrorRef error = NULL;
    addressBook = ABAddressBookCreate();

    ABRecordRef aRecord = ABPersonCreate();
    if(first_name)
        didSet = ABRecordSetValue(aRecord, kABPersonFirstNameProperty, first_name, &error);
    if(mid_name)
        didSet = ABRecordSetValue(aRecord, kABPersonMiddleNameProperty, mid_name, &error);
    if(last_name)
        didSet = ABRecordSetValue(aRecord, kABPersonLastNameProperty, last_name, &error);
    if(didSet)
        ABAddressBookAddRecord(addressBook, aRecord, &error);

    if (ABAddressBookHasUnsavedChanges(addressBook)) {
        if (wantToSaveChanges) {
            didSave = ABAddressBookSave(addressBook, &error);
            if (!didSave) {/* Handle error here. */}
        } else {
            ABAddressBookRevert(addressBook);
        }
    }

    CFRelease(aRecord);
    CFRelease(addressBook);
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:phone forKey:@"phone"];
    [aCoder encodeObject:address forKey:@"address"];
}

- (void)dealloc
{
    [name release];
    [phone release];
    [address release];
    [super dealloc];
}


@end
