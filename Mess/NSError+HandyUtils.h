//
//  NSError+HandyUtils.h
//  ModeoFramework
//
//  Created by Jon on 10/26/14.
//  Copyright (c) 2014 Modeo Vehicles LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (HandyUtils)

+ (NSError *)errorWithDescription:(NSString *)description andCode:(NSInteger)code;

@end
