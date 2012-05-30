//
//  GSNearPerson.h
//  group share
//
//  Created by kaku on 12/05/29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSNearPerson : NSObject
{
    NSMutableArray *allItems;
    NSMutableArray *nearPerson;
}

- (void)getNearPerson;

@end
