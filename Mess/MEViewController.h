//
//  MEViewController.h
//  Mess
//
//  Created by Jon on 8/21/14.
//  Copyright (c) 2014 Modeo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ModeoFramework/ModeoFramework.h>

@interface MEViewController : UIViewController <MFSensorDelegate>

- (void)sensor:(MFSensor *)sensor didFailWithError:(NSError *)error;
- (void)sensor:(MFSensor *)sensor didUpdateValue:(MFSensorData *)data;

@end
