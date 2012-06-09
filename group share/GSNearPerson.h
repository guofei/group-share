//
//  GSNearPerson.h
//  group share
//
//  Created by kaku on 12/05/29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GSNearPerson : NSObject
{
    CLLocation *myLocation;
    NSMutableArray *allItems;
    NSMutableDictionary *nearPerson;
}

- (id)initWithLocation:(CLLocation *)location;
- (NSMutableDictionary *)getNearPerson;
- (BOOL)removePerson:(NSString *)id;

@end
