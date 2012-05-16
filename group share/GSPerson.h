//
//  GSPerson.h
//  group share
//
//  Created by kaku on 12/05/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSPerson : NSObject <NSCoding>
{
    NSMutableDictionary *name;
    NSMutableDictionary *phone;
    NSMutableDictionary *address;
}
@property (nonatomic, retain) NSMutableDictionary *name;
@property (nonatomic, retain) NSMutableDictionary *phone;
@property (nonatomic, retain) NSMutableDictionary *address;

- (id)initWithRecord:(ABRecordRef)person;
- (void)addToAddressBook;

@end
