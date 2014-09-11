//
//  MEViewController.m
//  Mess
//
//  Created by Jon on 8/21/14.
//  Copyright (c) 2014 Modeo. All rights reserved.
//

#import <ModeoFramework/ModeoFramework.h>
#import <ModeoFramework/ModeoController.h>
#import <Parse/Parse.h>
#import "MFPropertyData+CubicBezier.h"

#import "MEViewController.h"
#import "MEDataPoint.h"

@interface MEViewController ()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (strong, nonatomic) NSArray *sensors;
@property (strong, nonatomic) NSMutableArray *dataPoints;

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
    self.statusLabel.text = @"Connecting...";
    [[MFBike sharedInstance] connectWithCallback:^(NSError *error) {
        if (!error) {
            self.statusLabel.text = @"Connected";
            [self uploadAssistCurve];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void)bikeDidDisconnect:(NSNotification *)notification {
    self.statusLabel.text = @"Disconnected";
    
    [self uploadLog];
    [self stopSensorUpdates];
    [self performConnection];
    
    self.dataPoints = nil;
}

- (void)uploadLog {
    NSMutableArray *jsonEncodableLog = [NSMutableArray new];
    for (MEDataPoint *dataPoint in self.dataPoints) {
        [jsonEncodableLog addObject:[dataPoint toDictionary]];
    }
    
    PFObject *ride = [PFObject objectWithClassName:@"ride"];
    [ride setObject:jsonEncodableLog forKey:@"log"];
    [ride saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Saved log!");
        }
        else {
            NSLog(@"Error saving log: %@", error.localizedDescription);
        }
    }];
}

- (void)uploadAssistCurve {
    
    [[MFBike sharedInstance] setValue:[MFPropertyData propertyDataWithUnsignedShort:UINT16_MAX / 2] forProperty:kModeoControllerTorqueMultiplier  withCallback:^(NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error setting torque multiplier" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        }
    }];
    
    NSArray *tourAssitPoints = @[[[MFPoint alloc] initWithX:0 Y:0], [[MFPoint alloc] initWithX:0.3660991 Y:0], [[MFPoint alloc] initWithX:0.8227554 Y:0.9955808], [[MFPoint alloc] initWithX:1 Y:1]];
    MFCubicBezier *bezier = [[MFCubicBezier alloc] initWithPoints:tourAssitPoints maxX:58 maxY:255 curveType:kBikeCurveAssist];
    
    self.statusLabel.text = @"Uploading Curve";
    [[MFBike sharedInstance] setValue:[MFPropertyData propertyDataWithBezier:bezier] forProperty:kModeoControllerAssist withCallback:^(NSError *error) {
        if (!error) {
            [self loadSensors];
            [self startSensorUpdates];
            self.statusLabel.text = @"Ready";
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void)startSensorUpdates {
    for (MFSensor *sensor in self.sensors) {
        [sensor startUpdating];
    }
}

- (void)stopSensorUpdates {
    for (MFSensor *sensor in self.sensors) {
        [sensor stopUpdating];
    }
}

- (void)loadSensors {
    NSMutableArray *sensors = [NSMutableArray new];
    
    /*
     MFSensor *riderEffortManager = [[MFSensor alloc] initWithSensor:kBikeSensorRiderEffort];
     riderEffortManager.delegate = self;
     riderEffortManager.updateInterval = 0.1;
     [sensors addObject:riderEffortManager];
     */
    
    MFSensor *speedManager = [[MFSensor alloc] initWithSensor:kBikeSensorSpeed];
    speedManager.delegate = self;
    speedManager.updateInterval = 1;
    [sensors addObject:speedManager];
    
    MFSensor *currentStrainManager = [[MFSensor alloc] initWithSensor:kBikeSensorCurrentStrain];
    currentStrainManager.delegate = self;
    currentStrainManager.updateInterval = 0.1;
    [sensors addObject:currentStrainManager];
    
    /*
     MFSensor *rawStrainManager = [[MFSensor alloc] initWithSensor:kBikeSensorRawStrain];
     rawStrainManager.delegate = self;
     rawStrainManager.updateInterval = 0.1;
     [sensors addObject:rawStrainManager];
     */
    
    /*
     MFSensor *torqueAppliedSensor = [[MFSensor alloc] initWithSensor:kBikeSensorTorqueApplied];
     torqueAppliedSensor.delegate = self;
     torqueAppliedSensor.updateInterval = 0.1;
     //[sensors addObject:torqueAppliedSensor];
     */
    
    MFSensor *batteryVoltageSensor = [[MFSensor alloc] initWithSensor:kBikeSensorBatteryVoltage];
    batteryVoltageSensor.delegate = self;
    batteryVoltageSensor.updateInterval = 1;
    [sensors addObject:batteryVoltageSensor];
    
    MFSensor *motorTempSensor = [[MFSensor alloc] initWithSensor:kBikeSensorMotorTemp];
    motorTempSensor.delegate = self;
    motorTempSensor.updateInterval = 1;
    [sensors addObject:motorTempSensor];
    
    MFSensor *filteredRiderEffortSensor = [[MFSensor alloc] initWithSensor:kBikeSensorFilteredRiderEffort];
    filteredRiderEffortSensor.delegate = self;
    filteredRiderEffortSensor.updateInterval = 0.1;
    [sensors addObject:filteredRiderEffortSensor];
    
    self.sensors = [NSArray arrayWithArray:sensors];
}

- (void)sensor:(MFSensor *)sensor didFailWithError:(NSError *)error {
    NSLog(@"sensorDidFailWithError: %@", error.localizedDescription);
}

- (void)sensor:(MFSensor *)sensor didUpdateValue:(MFSensorData *)data {
    NSLog(@"Sensor: %d, value: %f", data.sensor, data.value);
    
    MEDataPoint *dataPoint = [[MEDataPoint alloc] initWithSensorData:data];
    [self.dataPoints addObject:dataPoint];
}

- (NSMutableArray *)dataPoints {
    if (!_dataPoints) {
        _dataPoints = [NSMutableArray new];
    }
    return _dataPoints;
}


@end
