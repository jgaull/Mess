//
//  MERemoteLogger.h
//  Mess
//
//  Created by Jon on 9/21/14.
//  Copyright (c) 2014 Modeo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MERemoteLogger : NSObject

+ (MERemoteLogger *)sharedInstance;

- (void)log:(NSString *)message;

@end
