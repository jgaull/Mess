//
//  NSError+HandyUtils.m
//  ModeoFramework
//
//  Created by Jon on 10/26/14.
//  Copyright (c) 2014 Modeo Vehicles LLC. All rights reserved.
//

#import "NSError+HandyUtils.h"

@implementation NSError (HandyUtils)

+ (NSError *)errorWithDescription:(NSString *)description andCode:(NSInteger)code {
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    [userInfo setObject:description forKey:NSLocalizedDescriptionKey];
    
    return [NSError errorWithDomain:@"world" code:code userInfo:userInfo];
}

@end
