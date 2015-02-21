//
//  XCTest+Wait.m
//  Shift
//
//  Created by Tom Zaworowski on 5/27/14.
//  Copyright (c) 2014 Project 100, Inc. All rights reserved.
//

#import "XCTest+Wait.h"

@implementation XCTest (Wait)

- (void)waitForCompletion:(NSTimeInterval)timeoutSecs {
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeoutSecs];
    
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:timeoutDate];
        if([timeoutDate timeIntervalSinceNow] < 0.0)
            break;
    } while (YES);
}

@end
