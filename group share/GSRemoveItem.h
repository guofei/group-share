//
//  GSRemoveItem.h
//  group share
//
//  Created by kaku on 12/06/03.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSRemoveItem : NSObject
{
    NSString *itemID;
}

- (id)initWithitemID:(NSString *)id;
- (void)removeItem;

@end
