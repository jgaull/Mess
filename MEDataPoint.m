//
//  MEDataPoint.m
//  Mess
//
//  Created by Jon on 9/10/14.
//  Copyright (c) 2014 Modeo. All rights reserved.
//

#import "MEDataPoint.h"

@implementation MEDataPoint

- (id)initWithSensorData:(MFSensorData *)sensorData {
    self = [super init];
    if (self) {
        _dataObject = sensorData;
        _type = kDataPointTypeSensor;
    }
    return self;
}

- (id)initWithLocationData:(CLLocation *)locationData {
    self = [super init];
    if (self) {
        _dataObject = locationData;
        _type = kDataPointTypeLocation;
    }
    return self;
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    
    if ([self.dataObject isKindOfClass:[MFSensorData class]]) {
        MFSensorData *sensorData = (MFSensorData *)self.dataObject;
        
        [dictionary setObject:[NSNumber numberWithFloat:sensorData.value] forKey:@"value"];
        [dictionary setObject:[NSNumber numberWithInteger:sensorData.sensor] forKey:@"sensorId"];
        [dictionary setObject:[NSString stringWithFormat:@"%@", sensorData.timestamp] forKey:@"timestamp"];
    }
    else if ([self.dataObject isKindOfClass:[CLLocation class]]) {
        CLLocation *locationData = (CLLocation *)self.dataObject;
        
        [dictionary setObject:[NSNumber numberWithLong:locationData.coordinate.latitude] forKey:@"latitude"];
        [dictionary setObject:[NSNumber numberWithLong:locationData.coordinate.longitude] forKey:@"longitude"];
        [dictionary setObject:[NSNumber numberWithLong:locationData.altitude] forKey:@"altitude"];
        [dictionary setObject:[NSNumber numberWithFloat:locationData.speed] forKey:@"speed"];
        [dictionary setObject:[NSNumber numberWithDouble:locationData.horizontalAccuracy] forKey:@"hAccuracy"];
        [dictionary setObject:[NSNumber numberWithDouble:locationData.verticalAccuracy] forKey:@"vAccuracy"];
        [dictionary setObject:[NSString stringWithFormat:@"%@", locationData.timestamp] forKey:@"timestamp"];
    }
    
    [dictionary setObject:[NSNumber numberWithInteger:self.type] forKey:@"type"];
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
