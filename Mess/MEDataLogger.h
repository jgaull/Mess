//
//  MEDataLogger.h
//  Mess
//
//  Created by Jon on 9/11/14.
//  Copyright (c) 2014 Modeo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ModeoFramework/ModeoFramework.h>
#import <ModeoFramework/ModeoController.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@interface MEDataLogger : NSObject <MFSensorDelegate, CLLocationManagerDelegate>

- (void)start;

- (void)sensor:(MFSensor *)sensor didFailWithError:(NSError *)error;
- (void)sensor:(MFSensor *)sensor didUpdateValue:(MFSensorData *)data;

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;

@end
