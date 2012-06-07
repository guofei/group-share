//
//  GSReceiveViewController.m
//  group share
//
//  Created by kaku on 12/06/07.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GSReceiveViewController.h"

@interface GSReceiveViewController ()

@end

@implementation GSReceiveViewController

@synthesize gps;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Receive", @"Receive");
        self.tabBarItem.image = [UIImage imageNamed:@"download.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [gsReceiver release];

    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onRecive:(id)sender
{
    if ([CLLocationManager locationServicesEnabled]) {
        recive.text = @"Waiting for receiving Data...";
        gsReceiver = [[GSReceiver alloc] initWithGPSCtr:gps UILabel:name UIImageView:imageView progressView:downloadProgress1];
        [gsReceiver createItem];
    }
}

- (void)onRecived:(id)sender
{
    recive.text = @"";
    [gsReceiver removeItem];
}

@end
