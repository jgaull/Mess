//
//  MEDataPoint.m
//  Mess
//
//  Created by Jon on 9/10/14.
//  Copyright (c) 2014 Modeo. All rights reserved.
//

#import "MEDataPoint.h"
#import "MFSensorData+ToDictionary.h"

@implementation MEDataPoint

- (id)initWithSensorData:(MFSensorData *)sensorData {
    self = [super init];
    if (self) {
        _dataObject = sensorData;
        _type = kDataPointTypeSensor;
    }
    return self;
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    
    if ([self.dataObject isKindOfClass:[MFSensorData class]]) {
        MFSensorData *sensorData = (MFSensorData *)self.dataObject;
        NSDictionary *dataObjectDictionary = [sensorData toDictionary];
        [dictionary setObject:dataObjectDictionary forKey:@"dataObject"];
        [dictionary setObject:[NSNumber numberWithInteger:self.type] forKey:@"dataObjectType"];
        [dictionary setObject:sensorData.timestamp forKey:@"timestamp"];
    }
    
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
