//
//  AsyncCreateItem.h
//  group share
//
//  Created by kaku on 12/05/23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <AWSiOSSDK/AmazonServiceRequest.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GSAsyncCreateItem : NSOperation<CLLocationManagerDelegate>
{
    NSString *userName;
    NSData   *userLocation;

    CLLocationManager *locationMan;

}

@property(nonatomic, retain) CLLocationManager *locationMan;

-(id)initWithLocation:(NSData *)location withName:(NSString *)name;
-(id)initWithName:(NSString *)name;
@end
