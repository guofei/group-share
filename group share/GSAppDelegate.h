//
//  GSAppDelegate.h
//  group share
//
//  Created by kaku on 12/04/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSGPSController.h"

@class GSViewController;

@interface GSAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@property (nonatomic, retain) GSGPSController *gps;

@end
