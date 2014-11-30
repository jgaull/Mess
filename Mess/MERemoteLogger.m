//
//  MERemoteLogger.m
//  Mess
//
//  Created by Jon on 9/21/14.
//  Copyright (c) 2014 Modeo. All rights reserved.
//

#import <Parse/Parse.h>

#import "MERemoteLogger.h"

@implementation MERemoteLogger

+ (MERemoteLogger *)sharedInstance {
    static MERemoteLogger *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [MERemoteLogger new];
    });
    
    return sharedInstance;
}

- (void)log:(NSString *)message {
    PFObject *log = [[PFObject alloc] initWithClassName:@"LogMessage"];
    [log setObject:message forKey:@"message"];
    [log saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"saved log");
        }
        else {
            NSLog(@"error saving log");
        }
    }];
}

@end
