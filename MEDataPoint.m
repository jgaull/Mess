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
    }
    return self;
}

- (id)initWithLocationData:(CLLocation *)locationData {
    self = [super init];
    if (self) {
        _dataObject = locationData;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        MEDataPointType type = [[dictionary objectForKey:@"type"] intValue];
        
        if (type == kDataPointTypeSensor) {
            
            float value = [[dictionary objectForKey:@"value"] floatValue];
            MFBikeSensorIdentifier sensorId = [[dictionary objectForKey:@"sensorId"] intValue];
            
            NSString *timestampString = [dictionary objectForKey:@"timestamp"];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZZ"];
            NSDate *timestamp = [dateFormat dateFromString:timestampString];
            
            MFSensorData *sensorData = [[MFSensorData alloc] initWithValue:value timestamp:timestamp sensor:sensorId];
            
            _dataObject = sensorData;
        }
        else {
            double latitude = [[dictionary objectForKey:@"latitude"] doubleValue];
            double longitude = [[dictionary objectForKey:@"longitude"] doubleValue];
            double altitude = [[dictionary objectForKey:@"altitude"] doubleValue];
            double speed = [[dictionary objectForKey:@"speed"] doubleValue];
            double hAccuracy = [[dictionary objectForKey:@"haccuracy"] doubleValue];
            double vAccuracy = [[dictionary objectForKey:@"vAccuracy"] doubleValue];
            
            NSString *timestampString = [dictionary objectForKey:@"timestamp"];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZZ"];
            NSDate *timestamp = [dateFormat dateFromString:timestampString];
            
            CLLocation *location = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude) altitude:altitude horizontalAccuracy:hAccuracy verticalAccuracy:vAccuracy course:0 speed:speed timestamp:timestamp];
            
            _dataObject = location;
        }
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
        
        [dictionary setObject:[NSNumber numberWithDouble:locationData.coordinate.latitude] forKey:@"latitude"];
        [dictionary setObject:[NSNumber numberWithDouble:locationData.coordinate.longitude] forKey:@"longitude"];
        [dictionary setObject:[NSNumber numberWithDouble:locationData.altitude] forKey:@"altitude"];
        [dictionary setObject:[NSNumber numberWithFloat:locationData.speed] forKey:@"speed"];
        [dictionary setObject:[NSNumber numberWithDouble:locationData.horizontalAccuracy] forKey:@"hAccuracy"];
        [dictionary setObject:[NSNumber numberWithDouble:locationData.verticalAccuracy] forKey:@"vAccuracy"];
        [dictionary setObject:[NSString stringWithFormat:@"%@", locationData.timestamp] forKey:@"timestamp"];
    }
    
    [dictionary setObject:[NSNumber numberWithInteger:self.type] forKey:@"type"];
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (MEDataPointType)type {
    if ([self.dataObject isKindOfClass:[CLLocation class]]) {
        return kDataPointTypeLocation;
    }
    else {
        return kDataPointTypeSensor;
    }
}

@end
