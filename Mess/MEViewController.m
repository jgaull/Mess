//
//  MEViewController.m
//  Mess
//
//  Created by Jon on 8/21/14.
//  Copyright (c) 2014 Modeo. All rights reserved.
//

#import <ModeoFramework/ModeoController.h>
#import <Parse/Parse.h>

#import "MEDataPoint.h"

#import "MEViewController.h"

@interface MEViewController ()

@property (weak, nonatomic) IBOutlet UIButton *toCSVButton;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation MEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)userDidTapToCSVButton:(UIButton *)sender {
    
    //kill(getpid(), SIGKILL);
    
    [[MFBike sharedInstance] valueForSensor:kBikeSensorBatteryPercentage withCallback:^(float value, NSError *error) {
        if (!error) {
            float percentage = (value / UINT16_MAX) * 100;
            self.label.text = [NSString stringWithFormat:@"%.2f%%", percentage];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error reading battery level." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        }
    }];
    
    /*
    PFObject *rideLog = [PFObject objectWithClassName:@"ride"];
    rideLog.objectId = @"siQICd2ybL";
    [rideLog refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            NSLog(@"loaded");
            PFFile *log = [object objectForKey:@"log"];
            [log getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    NSLog(@"Log loaded");
                    
                    NSError *error;
                    NSArray *dataPointDictionaries = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                    
                    NSMutableArray *dataPoints = [NSMutableArray new];
                    
                    for (NSDictionary *dictionary in dataPointDictionaries) {
                        MEDataPoint *dataPoint = [[MEDataPoint alloc] initWithDictionary:dictionary];
                        [dataPoints addObject:dataPoint];
                    }
                    
                    NSString *csv = @"Sensor, Value, Timestamp\n";
                    for (MEDataPoint *dataPoint in dataPoints) {
                        if (dataPoint.type == kDataPointTypeSensor) {
                            
                            MFSensorData *sensorData = (MFSensorData *)dataPoint.dataObject;
                            MFBikeSensorIdentifier sensorId = sensorData.sensor;
                            float value = sensorData.value;
                            NSDate *timestamp = sensorData.timestamp;
                            
                            NSString *dataPointLine = [NSString stringWithFormat:@"%d,%f,%@\n", sensorId, value, timestamp];
                            csv = [NSString stringWithFormat:@"%@%@", csv, dataPointLine];
                        }
                    }
                    
                    NSLog(@"%@", csv);
                }
                else {
                    NSLog(@"Error loading file: %@", error.localizedDescription);
                }
            }];
        }
        else {
            NSLog(@"Error loading ride: %@", error.localizedDescription);
        }
    }];
     */
}

@end
