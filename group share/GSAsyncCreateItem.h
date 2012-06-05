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
#import "GSGPSController.h"
#import "GSReceiver.h"

@interface GSAsyncCreateItem : NSOperation
{
    //DynamoDB ID
    NSString *userID;
    NSString *userName;
    NSData   *userLocation;
    GSGPSController *gpsCtr;
    BOOL _isReceived;
    
    id<ReceiverDelegate> delegate;

}

@property (nonatomic,assign) id<ReceiverDelegate> delegate;

-(id)initWithName:(NSString *)name ID:(NSString *)id GPS:(GSGPSController *)gps;

@end
