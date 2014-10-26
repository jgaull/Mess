//
//  MEDataLogger.m
//  Mess
//
//  Created by Jon on 9/11/14.
//  Copyright (c) 2014 Modeo. All rights reserved.
//

#import "MEDataLogger.h"
#import "MEDataPoint.h"
#import "MERemoteLogger.h"

@interface MEDataLogger ()

@property (strong, nonatomic) NSArray *sensors;
@property (strong, nonatomic) NSMutableArray *dataPoints;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundTaskId;

@end

@implementation MEDataLogger

- (void)start {
    [self performSelector:@selector(performConnection) withObject:nil afterDelay:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bikeDidDisconnect:) name:kNotificationBikeDidDisconnect object:nil];
}

- (void)performConnection {
    [[MFBike sharedInstance] connectWithCallback:^(NSError *error) {
        if (!error) {
            [self uploadAssistCurve];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void)bikeDidDisconnect:(NSNotification *)notification {
    
    [self stopSensorUpdates];
    [self stopLocationUpdates];
    [self uploadLog];
    
    self.dataPoints = nil;
    
    [self performConnection];
}

- (void)uploadLog {
    NSMutableArray *jsonEncodableLog = [NSMutableArray new];
    for (MEDataPoint *dataPoint in self.dataPoints) {
        [jsonEncodableLog addObject:[dataPoint toDictionary]];
    }
    
    NSError *e = nil;
    NSData *dataObj = [NSJSONSerialization dataWithJSONObject:jsonEncodableLog options:kNilOptions error:&e];
    PFFile *file = [PFFile fileWithName:@"log.ride" data:dataObj];
    
    PFObject *ride = [PFObject objectWithClassName:@"ride"];
    [ride setObject:file forKey:@"log"];
    [ride saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Saved log!");
            
            [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskId];
            self.backgroundTaskId = 0;
        }
        else {
            NSLog(@"Error saving log: %@", error.localizedDescription);
        }
    }];
}

- (void)uploadAssistCurve {
    
    /*
    [[MFBike sharedInstance] setValue:[MFPropertyData propertyDataWithUnsignedShort:UINT16_MAX / 2] forProperty:kModeoControllerTorqueMultiplier  withCallback:^(NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error setting torque multiplier" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        }
    }];
     */
    
    /*
    NSArray *tourAssitPoints = @[[[MFPoint alloc] initWithX:0 Y:0], [[MFPoint alloc] initWithX:0.3660991 Y:0], [[MFPoint alloc] initWithX:0.8227554 Y:0.9955808], [[MFPoint alloc] initWithX:1 Y:1]];
    MFCubicBezier *bezier = [[MFCubicBezier alloc] initWithPoints:tourAssitPoints maxX:58 maxY:255 curveType:kBikeCurveAssist];
    
    [[MFBike sharedInstance] setValue:[MFPropertyData propertyDataWithBezier:bezier] forProperty:kModeoControllerAssist withCallback:^(NSError *error) {
        if (!error) {
            
            self.backgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
                NSLog(@"Background task is expiring!");
                
                [[MERemoteLogger sharedInstance] log:@"Background task is expiring!"];
            }];
            
            [self loadSensors];
            [self startSensorUpdates];
            [self startLocationUpdates];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        }
    }];
     */
    
    self.backgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"Background task is expiring!");
        
        [[MERemoteLogger sharedInstance] log:@"Background task is expiring!"];
    }];
    
    [self loadSensors];
    [self startSensorUpdates];
    [self startLocationUpdates];
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

- (void)startLocationUpdates {
    
    [self.locationManager requestAlwaysAuthorization];
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"Has location services enabled.");
        [self.locationManager startUpdatingLocation];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Error" message:@"Location services is not enabled" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)stopLocationUpdates {
    [self.locationManager stopUpdatingLocation];
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
    
    /*
    MFSensor *currentStrainManager = [[MFSensor alloc] initWithSensor:kBikeSensorCurrentStrain];
    currentStrainManager.delegate = self;
    currentStrainManager.updateInterval = 0.1;
    [sensors addObject:currentStrainManager];
     */
    
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
    batteryVoltageSensor.updateInterval = 0.1;
    [sensors addObject:batteryVoltageSensor];
    
    MFSensor *motorTempSensor = [[MFSensor alloc] initWithSensor:kBikeSensorMotorTemp];
    motorTempSensor.delegate = self;
    motorTempSensor.updateInterval = 5;
    [sensors addObject:motorTempSensor];
    
    MFSensor *filteredRiderEffortSensor = [[MFSensor alloc] initWithSensor:kBikeSensorFilteredRiderEffort];
    filteredRiderEffortSensor.delegate = self;
    filteredRiderEffortSensor.updateInterval = 0.1;
    [sensors addObject:filteredRiderEffortSensor];
    
    MFSensor *batteryPercentageSensor = [[MFSensor alloc] initWithSensor:kBikeSensorBatteryPercentage];
    batteryPercentageSensor.delegate = self;
    batteryPercentageSensor.updateInterval = 1;
    [sensors addObject:batteryPercentageSensor];
    
    self.sensors = [NSArray arrayWithArray:sensors];
}

- (void)sensor:(MFSensor *)sensor didFailWithError:(NSError *)error {
    NSLog(@"sensorDidFailWithError: %@", error.localizedDescription);
}

- (void)sensor:(MFSensor *)sensor didUpdateValue:(MFSensorData *)data {
    //NSLog(@"Sensor: %d, value: %f", data.sensor, data.value);
    
    MEDataPoint *dataPoint = [[MEDataPoint alloc] initWithSensorData:data];
    [self.dataPoints addObject:dataPoint];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    MEDataPoint *dataPoint = [[MEDataPoint alloc] initWithLocationData:location];
    [self.dataPoints addObject:dataPoint];
    
    //NSLog(@"Latitude: %f, Longitude: %f", location.coordinate.latitude, location.coordinate.longitude);
}

- (NSMutableArray *)dataPoints {
    if (!_dataPoints) {
        _dataPoints = [NSMutableArray new];
    }
    return _dataPoints;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    }
    return _locationManager;
}

@end
