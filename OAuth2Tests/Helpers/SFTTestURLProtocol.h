//
//  SFTTestURLProtocol.h
//  Shift
//
//  Created by Tom Zaworowski on 5/27/14.
//  Copyright (c) 2014 Project 100, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFTTestURLProtocol : NSURLProtocol

+ (void)setResponseData:(NSData *)data;
+ (void)setResponseCode:(NSInteger)code;

@end
