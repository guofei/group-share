//
//  AsyncCreateItem.h
//  group share
//
//  Created by kaku on 12/05/23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSAsyncCreateItem : NSOperation
{
    NSString *userName;
    NSData   *userLocation;
}

-(id)initWithName:(NSString *)name;
-(id)initWithLocation:(NSData *)location withName:(NSString *)name;
@end
