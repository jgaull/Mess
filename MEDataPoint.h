//
//  MEDataPoint.h
//  Mess
//
//  Created by Jon on 9/10/14.
//  Copyright (c) 2014 Modeo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ModeoFramework/ModeoFramework.h>

typedef enum {
    kDataPointTypeSensor,
    kDataPointTypeLocation
} MEDataPointType;

@interface MEDataPoint : NSObject

@property (nonatomic, readonly) MEDataPointType type;
@property (nonatomic, readonly) NSObject *dataObject;

- (id)initWithSensorData:(MFSensorData *)sensorData;
- (NSDictionary *)toDictionary;

@end
