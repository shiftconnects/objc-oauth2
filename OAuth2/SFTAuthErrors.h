//
//  SFTAuthErrors.h
//  Shift
//
//  Created by Tom Zaworowski on 3/28/14.
//  Copyright (c) 2014 Project 100, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const authErrorDomain;

#pragma mark Error code defines


/** Defines authentication failure codes.
 
 Returns predefined error code on authentication failure. In case of a generic
 error, the code could be 420 or a code from a previous error (usually an
 NSURLConnection error).
 */

typedef NS_ENUM(NSInteger, SFTAuthErrorCode) {
/** Generic authorization error code.
 */
    SFTAuthErrorGenericCode = 420,
/** Unauthorized authorization error code.
 */
    SFTAuthErrorUnauthorizedCode = 401,
/** Missing user error code.
 */
    SFTAuthErrorMissingUserCode = 1
};

#pragma mark - Helpers

/**-----------------------------------------------------------------------------
 * @name Constructing userInfo dictionary
 *  ----------------------------------------------------------------------------
 */

/** Returns userInfo dictionary for an SFTAuthErrorCode
 
 Returns a userInfo dictionary used to build an NSError response.
 */
NSDictionary * userInfoForErrorCode(SFTAuthErrorCode errorCode);