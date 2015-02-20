//
//  SFTAuthErrors.m
//  Authentication Demo
//
//  Created by Tom Zaworowski on 3/31/14.
//  Copyright (c) 2014 Project 100, Inc. All rights reserved.
//

#include "SFTAuthErrors.h"

NSString *const authErrorDomain = @"com.goproject100.objc-auth.authentication";

NSDictionary * userInfoForErrorCode(SFTAuthErrorCode errorCode) {
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    
    switch (errorCode) {
        case SFTAuthErrorGenericCode:
            userInfo[NSLocalizedDescriptionKey] = @"Server error";
            userInfo[NSLocalizedFailureReasonErrorKey] = @"API endpoint is unreachable or the endpoint specified in the request is invalid. Passing through preceding error code";
            break;
            
        case SFTAuthErrorUnauthorizedCode:
            userInfo[NSLocalizedDescriptionKey] = @"Could not authorize user";
            userInfo[NSLocalizedRecoverySuggestionErrorKey] = @"Check user and app credentials";
            userInfo[NSLocalizedFailureReasonErrorKey] = @"User or app credentials are invalid or token and refresh_token are invalid";
            break;
            
        case SFTAuthErrorMissingUserCode:
            userInfo[NSLocalizedDescriptionKey] = @"Missing user credentials";
            userInfo[NSLocalizedRecoverySuggestionErrorKey] = @"Check internal application state";
            userInfo[NSLocalizedFailureReasonErrorKey] = @"User credentials are missing";
            break;
            
        default:
            break;
    }
    
    return userInfo;
}