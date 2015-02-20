//
//  NSDate+Comparison.m
//  OAuth
//
//  Created by Tom Zaworowski on 8/28/14.
//  Copyright (c) 2014 Project 100, Inc. All rights reserved.
//

#import "NSDate+Comparison.h"

@implementation NSDate (Comparison)

- (BOOL)isEarlierThan:(NSDate *)date {
    return [[self earlierDate:date] isEqual:self];
}

- (BOOL)isLaterThan:(NSDate *)date {
    return [[self earlierDate:date] isEqual:date];
}

@end
