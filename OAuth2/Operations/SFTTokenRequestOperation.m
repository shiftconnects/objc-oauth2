//
//  SFTTokenRequestOperation.m
//  OAuth
//
//  Created by Tom Zaworowski on 9/3/14.
//  Copyright (c) 2014 Project 100, Inc. All rights reserved.
//

#import "SFTTokenRequestOperation.h"

#import "Endpoints.h"
#import "SFTAuthErrors.h"

@interface SFTTokenRequestOperation () {
    NSString *_username;
    NSString *_password;
    NSString *_clientId;
    NSString *_clientSecret;
    NSURL *_url;
    
    accessTokenRequestReturnBlock _block;
}

@end

@implementation SFTTokenRequestOperation

- (instancetype)initWithUsername:(NSString *)username
                        password:(NSString *)password
                        clientId:(NSString *)clientId
                    clientSecret:(NSString *)clientSecret
             authorizationServer:(NSURL *)url
                 completionBlock:(accessTokenRequestReturnBlock)completionBlock{
    self = [super init];
    if (self) {
        _username = username;
        _password = password;
        _clientId = clientId;
        _clientSecret = clientSecret;
        _url = url;
        _block = completionBlock;
    }
    
    return self;
    
}

- (void)main {
    NSMutableCharacterSet *allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:@"?&=+/'"];
    
    NSString *requestArguments = [NSString stringWithFormat:@"%@", [NSString pathWithComponents:@[oauthEndPoint,
                                                                                                  tokenEndPoint]]];
    NSString *body = [NSString stringWithFormat:@"grant_type=password&username=%@&password=%@&client_id=%@&client_secret=%@",
                      [_username stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet],
                      [_password stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet],
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
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&connectionError];
    if (!connectionError) {
        NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
        
        if (statusCode >= 200 && statusCode < 300) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                               options:NSJSONReadingAllowFragments
                                                                                 error:nil];
            
            NSString *token = responseDictionary[@"access_token"];
            NSString *refreshToken = responseDictionary[@"refresh_token"];
            NSTimeInterval expiration = [responseDictionary[@"expires_in"] doubleValue];
            NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:expiration];
            
            _block(token, refreshToken, expirationDate, connectionError);
        } else if (statusCode == 400) {
            NSError *error = [NSError errorWithDomain:authErrorDomain
                                                 code:400
                                             userInfo:nil];
            
            _block(nil, nil, nil, error);
        } else {
            NSError *error = [NSError errorWithDomain:authErrorDomain
                                         code:statusCode
                                            userInfo:userInfoForErrorCode(SFTAuthErrorGenericCode)];
            _block(nil, nil, nil, error);
        }
    } else {
        if ([connectionError.domain isEqualToString:NSURLErrorDomain]
            && (connectionError.code == NSURLErrorUserAuthenticationRequired
                || connectionError.code == NSURLErrorUserCancelledAuthentication))
        {
            NSError *error = [NSError errorWithDomain:authErrorDomain
                                         code:SFTAuthErrorUnauthorizedCode
                                     userInfo:userInfoForErrorCode(SFTAuthErrorUnauthorizedCode)];
            _block(nil, nil, nil, error);
        } else {
            NSError *error = [NSError errorWithDomain:authErrorDomain
                                         code:connectionError.code
                                     userInfo:userInfoForErrorCode(SFTAuthErrorGenericCode)];
            _block(nil, nil, nil, error);
        }
    }
}

@end
