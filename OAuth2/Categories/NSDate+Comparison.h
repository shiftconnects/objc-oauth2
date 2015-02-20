//
//  NSDate+Comparison.h
//  OAuth
//
//  Created by Tom Zaworowski on 8/28/14.
//  Copyright (c) 2014 Project 100, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Comparison)

- (BOOL)isEarlierThan:(NSDate *)date;
- (BOOL)isLaterThan:(NSDate *)date;

@end
