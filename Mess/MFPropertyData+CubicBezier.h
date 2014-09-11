//
//  EVPropertyData+EVCubicBezier.h
//  E-Bike Visualizer
//
//  Created by Jon on 5/7/14.
//  Copyright (c) 2014 One Headed Llama. All rights reserved.
//

#import "ModeoFramework/MFPropertyData.h"
#import "ModeoFramework/MFCubicBezier.h"

@interface MFPropertyData (CubicBezier)

+ (MFPropertyData *)propertyDataWithBezier:(MFCubicBezier *)bezier;

@end
