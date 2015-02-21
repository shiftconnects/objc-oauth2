//
//  XCTest+Wait.h
//  Shift
//
//  Created by Tom Zaworowski on 5/27/14.
//  Copyright (c) 2014 Project 100, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface XCTest (Wait)

- (void)waitForCompletion:(NSTimeInterval)timeoutSecs;

@end
