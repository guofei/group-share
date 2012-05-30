//
//  GSNearPersonTest.m
//  group share
//
//  Created by kaku on 12/05/30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GSNearPersonTest.h"

@implementation GSNearPersonTest

- (void)setUp
{
    [super setUp];
    np = [[GSNearPerson alloc] init];
}

- (void)tearDown
{
    [np release];
}

- (void)testGetNearPerson
{
    [np getNearPerson];
}

@end
