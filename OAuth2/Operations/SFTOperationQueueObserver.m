//
//  SFTOperationQueueObserver.m
//  OAuth
//
//  Created by Tom Zaworowski on 9/5/14.
//  Copyright (c) 2014 Project 100, Inc. All rights reserved.
//

#import "SFTOperationQueueObserver.h"

@interface SFTOperationQueueObserver () {
    NSOperationQueue *_operationQueue;
    callbackBlock _callbackBlock;
}

@end

@implementation SFTOperationQueueObserver

- (void)dealloc {
    [_operationQueue removeObserver:self forKeyPath:@"operationCount" context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([object isEqual:_operationQueue] && [keyPath isEqualToString:@"operationCount"]) {
        if (_callbackBlock) {
            _callbackBlock(_operationQueue.operationCount);
        }
    }
}

- (void)observeQueue:(NSOperationQueue *)queue {
    _operationQueue = queue;
    
    [_operationQueue addObserver:self forKeyPath:@"operationCount" options:0 context:NULL];
}

- (void)setCallbackBlock:(callbackBlock)callbackBlock {
    _callbackBlock = callbackBlock;
}

@end
