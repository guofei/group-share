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
    NSDictionary *name;
    NSDictionary *phone;
    NSDictionary *address;
}
@property (nonatomic, retain) NSDictionary *name;
@property (nonatomic, retain) NSDictionary *phone;
@property (nonatomic, retain) NSDictionary *address;
@end
