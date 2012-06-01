//
//  GSNearPersonTest.m
//  group share
//
//  Created by kaku on 12/05/30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>

#import "GSNearPersonTest.h"

@implementation GSNearPersonTest

- (void)setUp
{
    [super setUp];
    c = [[CLLocation alloc] initWithLatitude:37.785834 longitude:-122.406416];
    np = [[GSNearPerson alloc] initWithLocation:c];
}

- (void)tearDown
{
    [np release];
    [c release];
}

- (void)testGetNearPerson
{
    [np getNearPerson];
}

@end
