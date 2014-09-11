//
//  EVPropertyData+EVCubicBezier.m
//  E-Bike Visualizer
//
//  Created by Jon on 5/7/14.
//  Copyright (c) 2014 One Headed Llama. All rights reserved.
//

#import "MFPropertyData+CubicBezier.h"

@implementation MFPropertyData (CubicBezier)

+ (MFPropertyData *)propertyDataWithBezier:(MFCubicBezier *)bezier {
    NSInteger dataSize = 12;
    Byte bytes[dataSize];
    
    //Bottom left (not currently being used)
    bytes[0] = 0; //x
    bytes[1] = 0; //y
    
    //Top right
    bytes[2] = bezier.maxX; //x
    bytes[3] = bezier.maxY; //y
    
    //Point 0
    bytes[4] = [bezier pointAtIndex:0].x * 255; //x
    bytes[5] = [bezier pointAtIndex:0].y * 255; //y
    
    //Point 1
    bytes[6] = [bezier pointAtIndex:1].x * 255; //x
    bytes[7] = [bezier pointAtIndex:1].y * 255; //y
    
    //Point 2
    bytes[8] = [bezier pointAtIndex:2].x * 255; //x
    bytes[9] = [bezier pointAtIndex:2].y * 255; //y
    
    //Point 3
    bytes[10] = [bezier pointAtIndex:3].x * 255; //x
    bytes[11] = [bezier pointAtIndex:3].y * 255; //y
    
    NSData *data = [NSData dataWithBytes:bytes length:dataSize];
    return [MFPropertyData propertyDataWithData:data];
}

@end
