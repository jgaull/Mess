//
//  MEViewController.m
//  Mess
//
//  Created by Jon on 8/21/14.
//  Copyright (c) 2014 Modeo. All rights reserved.
//

#import <ModeoFramework/ModeoFramework.h>
#import <ModeoFramework/ModeoController.h>
#import "MFPropertyData+CubicBezier.h"

#import "MEViewController.h"

@interface MEViewController ()

@end

@implementation MEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self performSelector:@selector(performConnection) withObject:nil afterDelay:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bikeDidDisconnect:) name:kNotificationBikeDidDisconnect object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performConnection {
    NSLog(@"Connecting...");
    [[MFBike sharedInstance] connectWithCallback:^(NSError *error) {
        if (!error) {
            [self uploadAssistCurve];
            NSLog(@"Connected!");
        }
        else {
            NSLog(@"Error Connecting: %@", error.localizedDescription);
        }
    }];
}

- (void)bikeDidDisconnect:(NSNotification *)notification {
    [self performConnection];
    NSLog(@"Disconnected!");
}

- (void)uploadAssistCurve {
    
    NSArray *tourAssitPoints = @[[[MFPoint alloc] initWithX:0 Y:0], [[MFPoint alloc] initWithX:0.3660991 Y:0], [[MFPoint alloc] initWithX:0.8227554 Y:0.9955808], [[MFPoint alloc] initWithX:1 Y:1]];
    MFCubicBezier *bezier = [[MFCubicBezier alloc] initWithPoints:tourAssitPoints maxX:58 maxY:255 curveType:kBikeCurveAssist];
    
    [[MFBike sharedInstance] setValue:[MFPropertyData propertyDataWithBezier:bezier] forProperty:kModeoControllerAssist withCallback:^(NSError *error) {
        if (!error) {
            NSLog(@"Assist level set.");
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

@end
