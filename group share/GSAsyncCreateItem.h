//
//  AsyncCreateItem.h
//  group share
//
//  Created by kaku on 12/05/23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GSAsyncCreateItem : NSOperation
{
    NSString *userID;
    NSString *userName;
    NSData   *userLocation;
    BOOL _finished;
    BOOL _isReceived;
}

@property BOOL finished;

-(id)initWithName:(NSString *)name;

@end
