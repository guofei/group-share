//
//  GSGPSController.h
//  group share
//
//  Created by kaku on 12/05/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GSGPSController : NSObject <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *lastReading;
}

//@property (nonatomic, assign) BOOL finished;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *lastReading;

- (void)startLocate;
- (void)stopLocate;

@end
