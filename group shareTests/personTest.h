//
//  personTest.h
//  group share
//
//  Created by kaku on 12/05/13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "GSPerson.h"

@interface personTest : SenTestCase{
    GSPerson *_person;
    NSData *data;
    GSPerson *data_to_person;
}
@end
