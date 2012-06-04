//
//  GSGPSController.m
//  group share
//
//  Created by kaku on 12/05/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GSGPSController.h"
#import "GSAsyncCreateItem.h"

@implementation GSGPSController

@synthesize locationManager, lastReading;

- (id)init {
    if(self = [super init]) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        locationManager.delegate = self;
        self.lastReading = nil;
    }
    return self;
}

- (void)dealloc
{

    [locationManager release];
    [lastReading release];

    [super dealloc];
}

- (void)startLocate
{
    [locationManager startUpdatingLocation]; 
}

- (void)stopLocate
{
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation 
{
    self.lastReading = newLocation;

    //((GSAsyncCreateItem *)resultObj).gpsFinished = YES;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSString * errorString = @"Unable to determine your current location.";
    UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error Locating" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    [errorAlert release];
    [locationManager stopUpdatingLocation];
}

@end
