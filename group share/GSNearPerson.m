//
//  GSNearPerson.m
//  group share
//
//  Created by kaku on 12/05/29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>

#import <AWSiOSSDK/AmazonServiceRequest.h>
#import <AWSiOSSDK/DynamoDB/DynamoDBAttributeValue.h>

#import "GSNearPerson.h"
#import "AmazonClientManager.h"
#import "AWSConstants.h"

#define Distance 1000

@implementation GSNearPerson

- (id)initWithLocation:(CLLocation *)location
{
    if(self = [super init]) {
        myLocation = [location retain];
        nearPerson = [[NSMutableDictionary dictionary] retain];
        allItems = Nil;
    }
    return self;
}

- (void)dealloc
{
    if (myLocation) {
        [myLocation release];
    }
    if (nearPerson) {
        [nearPerson release];
    }
    [super dealloc];
}

- (void)setAllPerson
{
    DynamoDBScanRequest *request = [[[DynamoDBScanRequest alloc] initWithTableName:TABLE_NAME] autorelease];
    
    @try {
        DynamoDBScanResponse *response = [[AmazonClientManager ddbClient] scan:request];
        allItems = [response.items retain];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

- (NSMutableDictionary *)getNearPerson
{
    [self setAllPerson];
    for (int i = 0; i < allItems.count; ++i) {
        NSMutableDictionary *item = [allItems objectAtIndex:i];
        DynamoDBAttributeValue *latitude = [item objectForKey:@"latitude"];
        DynamoDBAttributeValue *longitude = [item objectForKey:@"longitude"];
        DynamoDBAttributeValue *altitude = [item objectForKey:@"altitude"];
        DynamoDBAttributeValue *hAccuracy = [item objectForKey:@"hAccuracy"];
        DynamoDBAttributeValue *vAccuracy = [item objectForKey:@"vAccuracy"];
        CLLocationCoordinate2D coor = {[latitude.n doubleValue], [longitude.n doubleValue]};
        NSLog(@"lo %@", latitude.n);
        CLLocation *loc = [[CLLocation alloc] initWithCoordinate:coor altitude:[altitude.n doubleValue] horizontalAccuracy:[hAccuracy.n doubleValue] verticalAccuracy:[vAccuracy.n doubleValue] timestamp:[NSDate date]];
        CLLocationDistance distance = [loc distanceFromLocation:myLocation];
        NSLog(@"distance %f", distance);
        if (distance < Distance) {
            DynamoDBAttributeValue *id = [item objectForKey:@"id"];
            DynamoDBAttributeValue *name = [item objectForKey:@"name"];
            //[nearPerson addObject:id.s];
            [nearPerson setObject:name.s forKey:id.s];
        }
    }
    return nearPerson;
}

- (BOOL)removePerson:(NSString *)id
{
    [nearPerson removeObjectForKey:id];
    return YES;
}

@end
