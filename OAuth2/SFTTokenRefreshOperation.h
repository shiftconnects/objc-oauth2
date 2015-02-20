//
//  SFTTokenRefreshOperation.h
//  OAuth
//
//  Created by Tom Zaworowski on 9/2/14.
//  Copyright (c) 2014 Project 100, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SFTUser;

typedef void (^refreshReturnBlock)(NSError *error);

@interface SFTTokenRefreshOperation : NSOperation

- (instancetype)initWithUser:(SFTUser *)user
                    clientId:(NSString *)clientId
                clientSecret:(NSString *)clientSecret
        authenticationServer:(NSURL *)url
             completionBlock:(refreshReturnBlock)completionBlock;

@end
