//
//  SFTOAuth.m
//  OAuth2
//
//  Created by Tom Zaworowski on 2/20/15.
//  Copyright (c) 2015 P100 OG, Inc. All rights reserved.
//

#import "SFTOAuth.h"

#import "SFTUser.h"

#import "SFTTokenRefreshOperation.h"
#import "SFTTokenRequestOperation.h"
#import "SFTRequestOperation.h"

#import "SFTOperationQueueObserver.h"

#import "SFTAuthErrors.h"

static NSOperationQueue *_networkQueue;
static NSOperationQueue *_requestQueue;
static NSMutableArray *_blockQueue;
static SFTOperationQueueObserver *_observer;

static NSUInteger _opCount;

@implementation SFTOAuth

typedef void(^requestReturn)(void);
typedef void(^refreshReturn)(void(^requestReturn)());

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _networkQueue = [self networkQueue];
        _networkQueue.maxConcurrentOperationCount = 1;
        
        _requestQueue = [NSOperationQueue new];
        
        _blockQueue = [NSMutableArray new];
        
        _observer = [SFTOperationQueueObserver new];
        [_observer observeQueue:_networkQueue];
        [_observer setCallbackBlock:^(NSUInteger operationCount) {
            _opCount = operationCount;
            if (operationCount == 0) {
                // Fire off enqueued requests with updated tokens
                [_blockQueue enumerateObjectsUsingBlock:^(requestReturn block, NSUInteger idx, BOOL *stop) {
                    block();
                }];
            }
        }];
    });
}

#pragma mark - Requests

+ (void)performRequest:(NSURLRequest *)request
               forUser:(SFTUser *)user
              clientId:(NSString *)clientId
          clientSecret:(NSString *)clientSecret
  authenticationServer:(NSURL *)authServer
                      :(requestReturnBlock)completionBlock {
    
    __block BOOL didRefresh = NO;
    
    // This block refreshes the user token
    refreshReturn refreshBlock = ^void(requestReturn block) {
        SFTTokenRefreshOperation *refreshOperation = [[SFTTokenRefreshOperation alloc] initWithUser:user
                                                                                           clientId:clientId
                                                                                       clientSecret:clientSecret
                                                                               authenticationServer:authServer
                                                                                    completionBlock:^(NSError *error)
                                                      {
                                                          NSAssert(block, @"completionBlock must not be nil!");
                                                          
                                                          didRefresh = YES;
                                                          
                                                          if (!error) {
                                                              // Enqueue requests; fire them off when all token refresh calls finish
                                                              [_blockQueue addObject:block];
                                                          } else {
                                                              completionBlock(nil, error);
                                                          }
                                                      }];
        
        // Don't spam the auth server with multiple refresh requests
        BOOL shouldRefresh = (_opCount == 0);
        if (shouldRefresh) {
            [_networkQueue addOperation:refreshOperation];
        } else {
            // Run the request when in-progress refresh is done
            [_blockQueue addObject:block];
        }
    };
    
    // Setting up request blocks for recursive use
    requestReturn requestBlock;
    requestReturn __block __weak weakRequestBlock;
    
    // This block performs the request
    weakRequestBlock = requestBlock = ^void(void) {
        // Entering the second chamber of Wu-Tang retain cycles
        requestReturn __block recursiveRequestBlock = weakRequestBlock;
        
        if (user.hasValidToken) {
            NSURLRequest *signedRequest = [self signedRequest:request token:user.token];
            SFTRequestOperation *requestOperation = [[SFTRequestOperation alloc] initWithRequest:signedRequest
                                                                                 completionBlock:^(NSData *data, NSError *error)
                                                     {
                                                         [_blockQueue removeObject:weakRequestBlock];
                                                         
                                                         if (!error || error.code != SFTAuthErrorUnauthorizedCode || didRefresh) {
                                                             completionBlock(data, error);
                                                         } else {
                                                             refreshBlock(recursiveRequestBlock);
                                                         }
                                                     }];
            
            [_requestQueue addOperation:requestOperation];
        } else {
            didRefresh = NO;
            [_blockQueue removeObject:weakRequestBlock];
            refreshBlock(weakRequestBlock);
        }
    };
    
    // Start this Rube Goldberg machine
    if (user) {
        requestBlock();
    } else {
        completionBlock(nil, [NSError errorWithDomain:authErrorDomain
                                                 code:SFTAuthErrorMissingUserCode
                                             userInfo:userInfoForErrorCode(SFTAuthErrorMissingUserCode)]);
    }
}

+ (BOOL)cancelRequest:(NSURLRequest *)request {
    __block BOOL didCancel = NO;
    
    [_requestQueue.operations enumerateObjectsUsingBlock:^(SFTRequestOperation *op, NSUInteger idx, BOOL *stop) {
        if ([op.request.URL.absoluteString isEqualToString:request.URL.absoluteString]) {
            // op is same
            [op cancel];
            didCancel = YES;
        }
    }];
    
    return didCancel;
}

+ (NSURLRequest *)signedRequest:(NSURLRequest *)request token:(NSString *)token {
    NSMutableURLRequest *signedRequest = [request mutableCopy];
    NSString *signatureString = [NSString stringWithFormat:@"Bearer %@", token];
    [signedRequest setValue:signatureString forHTTPHeaderField:@"Authorization"];
    return signedRequest;
}

#pragma mark - Token magic

+ (void)requestAccessToken:(NSString *)user
                  password:(NSString *)password
                  clientId:(NSString *)clientId
              clientSecret:(NSString *)clientSecret
      authenticationServer:(NSURL *)authServer
                          :(tokenRequestReturnBlock)completionBlock {
    
    SFTTokenRequestOperation *tokenOperation = [[SFTTokenRequestOperation alloc] initWithUsername:user
                                                                                         password:password
                                                                                         clientId:clientId
                                                                                     clientSecret:clientSecret
                                                                              authorizationServer:authServer
                                                                                  completionBlock:^(NSString *token, NSString *refreshToken, NSDate *expiration, NSError *error)
                                                {
                                                    completionBlock(token, refreshToken, expiration, error);
                                                }];
    
    [_networkQueue addOperation:tokenOperation];
}

#pragma mark - Helpers

+ (NSOperationQueue *)networkQueue {
    NSOperationQueue *queue = [NSOperationQueue new];
    queue.name = @"com.shiftconnects.OAuth2.networkQueue";
    
    return queue;
}

@end
