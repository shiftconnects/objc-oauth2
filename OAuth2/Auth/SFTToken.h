//
//  SFTToken.h
//  Shift
//
//  Created by Tom Zaworowski on 3/21/14.
//  Copyright (c) 2014 Project 100, Inc. All rights reserved.
//

/** SFTToken object encapsulates token metadata.
 
 This object stores token metadata.
 */

#import <Foundation/Foundation.h>

@interface SFTToken : NSObject <NSCoding, NSCopying>

@property (strong, readonly) NSString *accessToken;
@property (strong, readonly) NSString *refreshToken;
@property (strong, readonly) NSDate *expiration;

/**-----------------------------------------------------------------------------
 * @name Initializing token object
 *  ----------------------------------------------------------------------------
 */

/** Initializes token object with supplied data
 
 Returns SFTToken object initizalized with provided data.
 
 @param accessToken Access token.
 @param refreshToken Refresh token.
 @param expiration Token expiration date.
 */
- (id)initWithAccessToken:(NSString *)accessToken
             refreshToken:(NSString *)refreshToken
               expiration:(NSDate *)expiration;

/**-----------------------------------------------------------------------------
 * @name Updating token object
 *  ----------------------------------------------------------------------------
 */

/** Updates token object with new token information
 
 Updates SFTToken object new token information.
 
 Use this method to update token information after refreshing access token.
 
 @param accessToken Access token.
 @param refreshToken Refresh token.
 @param expiration Token expiration date.
 */
- (void)updateAccessToken:(NSString *)accessToken
             refreshToken:(NSString *)refreshToken
               expiration:(NSDate *)expiration;

/**-----------------------------------------------------------------------------
 * @name Inspecting token object
 *  ----------------------------------------------------------------------------
 */

/** Checks token object for access token validity
 
 Checks SFTToken object for access token validy.
 
 This method checks access token expiration date against current date to
 determine its validty.
 */
- (BOOL)isValid;

@end
