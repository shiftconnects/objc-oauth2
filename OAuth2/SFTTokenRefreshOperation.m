//
//  SFTTokenRefreshOperation.m
//  OAuth
//
//  Created by Tom Zaworowski on 9/2/14.
//  Copyright (c) 2014 Project 100, Inc. All rights reserved.
//

#import "SFTTokenRefreshOperation.h"

#import "SFTUser.h"

#import "Endpoints.h"
#import "SFTAuthErrors.h"

@interface SFTTokenRefreshOperation () {
    SFTUser *_user;
    NSString *_clientId;
    NSString *_clientSecret;
    NSURL *_url;
    refreshReturnBlock _block;
}

@end

@implementation SFTTokenRefreshOperation

- (instancetype)initWithUser:(SFTUser *)user
                    clientId:(NSString *)clientId
                clientSecret:(NSString *)clientSecret
        authenticationServer:(NSURL *)url
             completionBlock:(refreshReturnBlock)completionBlock {
    self = [super init];
    if (self) {
        _user = user;
        _clientId = clientId;
        _clientSecret = clientSecret;
        _url = url;
        _block = completionBlock;
    }
    
    return self;
}

- (void)main {
    NSString *requestArguments = [NSString stringWithFormat:@"%@", [NSString pathWithComponents:@[oauthEndPoint,
                                                                                                  tokenEndPoint]]];
    
    NSString *body = [NSString stringWithFormat:@"grant_type=refresh_token&refresh_token=%@&client_id=%@&client_secret=%@",
                      _user.refreshToken,
                      _clientId,
                      _clientSecret];
    
    NSURL *url = [NSURL URLWithString:requestArguments relativeToURL:_url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPShouldHandleCookies = NO;
    request.cachePolicy = NSURLCacheStorageNotAllowed;
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLResponse *response;
    NSError *connectionError;
    NSError *internalError;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&connectionError];
    if (!connectionError) {
        NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
        
        if (statusCode >= 200 && statusCode < 300) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                               options:NSJSONReadingAllowFragments
                                                                                 error:nil];
            
            NSTimeInterval expiration = [responseDictionary[@"expires_in"] doubleValue];
            NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:expiration];
            [_user updateToken:responseDictionary[@"access_token"]
                  refreshToken:responseDictionary[@"refresh_token"]
               tokenExpiration:expirationDate];
        } else if (statusCode == 400) {
            internalError = [NSError errorWithDomain:authErrorDomain
                                                code:400
                                            userInfo:nil];
        } else {
            internalError = [NSError errorWithDomain:authErrorDomain
                                                code:SFTAuthErrorGenericCode
                                            userInfo:userInfoForErrorCode(SFTAuthErrorGenericCode)];
        }
    } else {
        if ([connectionError.domain isEqualToString:NSURLErrorDomain]
            && (connectionError.code == NSURLErrorUserAuthenticationRequired
                || connectionError.code == NSURLErrorUserCancelledAuthentication))
        {
            internalError = [NSError errorWithDomain:authErrorDomain
                                                code:SFTAuthErrorUnauthorizedCode
                                            userInfo:userInfoForErrorCode(SFTAuthErrorUnauthorizedCode)];
        } else {
            internalError = [NSError errorWithDomain:authErrorDomain
                                                code:connectionError.code
                                            userInfo:userInfoForErrorCode(SFTAuthErrorGenericCode)];
        }
    }
    
    _block(internalError);
}

@end
