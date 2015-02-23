//
//  SFTTokenRequestOperation.h
//  OAuth
//
//  Created by Tom Zaworowski on 9/3/14.
//  Copyright (c) 2014 Project 100, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^accessTokenRequestReturnBlock)(NSString *token, NSString *refreshToken, NSDate *expiration, NSError *error);

@interface SFTTokenRequestOperation : NSOperation

- (instancetype)initWithUsername:(NSString *)username
                        password:(NSString *)password
                        clientId:(NSString *)clientId
                    clientSecret:(NSString *)clientSecret
             authorizationServer:(NSURL *)url
                 completionBlock:(accessTokenRequestReturnBlock)completionBlock;

@end
