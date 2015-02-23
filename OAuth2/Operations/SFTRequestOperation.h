//
//  SFTRequestOperation.h
//  OAuth
//
//  Created by Tom Zaworowski on 9/2/14.
//  Copyright (c) 2014 Project 100, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SFTToken;

typedef void (^requestReturnBlock)(NSData *data, NSError *error);

@interface SFTRequestOperation : NSOperation

@property (strong, readonly) NSURLRequest *request;

- (instancetype)initWithRequest:(NSURLRequest *)request
                completionBlock:(requestReturnBlock)block;

@end
