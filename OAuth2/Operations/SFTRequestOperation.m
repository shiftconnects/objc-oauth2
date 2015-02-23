//
//  SFTRequestOperation.m
//  OAuth
//
//  Created by Tom Zaworowski on 9/2/14.
//  Copyright (c) 2014 Project 100, Inc. All rights reserved.
//

#import "SFTRequestOperation.h"

#import "SFTAuthErrors.h"

@interface SFTRequestOperation () {
    requestReturnBlock _block;
}

@end

@implementation SFTRequestOperation

- (instancetype)initWithRequest:(NSURLRequest *)request completionBlock:(requestReturnBlock)block {
    self = [super init];
    if (self) {
        _request = request;
        _block = block;
    }
    
    return self;
}

- (void)main {
    NSURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:_request
                                         returningResponse:&response
                                                     error:&error];
    NSInteger responseCode = ((NSHTTPURLResponse *)response).statusCode;
    
    if (!error) {
        if (responseCode >= 200 && responseCode <= 299) {
            if (!self.isCancelled) {
                _block(data, nil);
            }
        } else {
            error = [NSError errorWithDomain:authErrorDomain
                                        code:responseCode
                                    userInfo:userInfoForErrorCode(SFTAuthErrorGenericCode)];
            if (!self.isCancelled) {
                _block(nil, error);
            }
        }
        
    } else {
        if ([error.domain isEqualToString:NSURLErrorDomain]  &&
            (error.code == NSURLErrorUserAuthenticationRequired ||
             error.code == NSURLErrorUserCancelledAuthentication))
        {
            error = [NSError errorWithDomain:authErrorDomain
                                        code:SFTAuthErrorUnauthorizedCode
                                    userInfo:userInfoForErrorCode(SFTAuthErrorUnauthorizedCode)];
        } else if (!(responseCode >= 200 && responseCode < 300)) {
            error = [NSError errorWithDomain:authErrorDomain
                                        code:responseCode
                                    userInfo:userInfoForErrorCode(SFTAuthErrorGenericCode)];
        }
        
        if (!self.isCancelled) {
            _block(nil, error);
        }
    }
}

- (void)cancel {
    [super cancel];
    
}

@end
