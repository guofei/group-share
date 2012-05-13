//
//  GSPerson.m
//  group share
//
//  Created by kaku on 12/05/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GSPerson.h"

@implementation GSPerson

@synthesize name,phone,address;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    name = [[aDecoder decodeObjectForKey:@"name"] retain];
    phone = [[aDecoder decodeObjectForKey:@"phone"] retain];
    address = [[aDecoder decodeObjectForKey:@"address"] retain];
    return self;
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
