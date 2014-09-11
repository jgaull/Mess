//
//  MFSensorData+ToDictionary.m
//  Mess
//
//  Created by Jon on 9/10/14.
//  Copyright (c) 2014 Modeo. All rights reserved.
//

#import "MFSensorData+ToDictionary.h"

@implementation MFSensorData (ToDictionary)

- (NSDictionary *)toDictionary {
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:self.timestamp forKey:@"timestamp"];
    [dictionary setObject:[NSNumber numberWithFloat:self.value] forKey:@"value"];
    [dictionary setObject:[NSNumber numberWithInteger:self.sensor] forKey:@"sensorId"];
    return dictionary;
}

@end
