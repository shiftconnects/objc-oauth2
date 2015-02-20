//
//  SFTOperationQueueObserver.h
//  OAuth
//
//  Created by Tom Zaworowski on 9/5/14.
//  Copyright (c) 2014 Project 100, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^callbackBlock)(NSUInteger operationCount);

@interface SFTOperationQueueObserver : NSObject

- (void)observeQueue:(NSOperationQueue *)queue;
- (void)setCallbackBlock:(callbackBlock)callbackBlock;

@end
