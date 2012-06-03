//
//  AsyncCreateItem.h
//  group share
//
//  Created by kaku on 12/05/23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "GSDownloadDelegate.h"

@interface GSAsyncCreateItem : NSOperation
{
    //DynamoDB ID
    NSString *userID;
    NSString *userName;
    NSData   *userLocation;
    BOOL _finished;
    BOOL _isReceived;
    
    id <GSDownloadDelegate> delegate;

}

@property BOOL gpsFinished;
@property (nonatomic,assign) id<GSDownloadDelegate> delegate;

-(id)initWithName:(NSString *)name ID:(NSString *)id;

@end
