//
//  SFTUser.h
//  Shift
//
//  Created by Tom Zaworowski on 3/21/14.
//  Copyright (c) 2014 Project 100, Inc. All rights reserved.
//

/** SFTUser object encapsulates user metadata.
 
 This object stores user metadata as well as access credentials including
 tokens, PIN and activitiy state.
 */

#import <Foundation/Foundation.h>

@interface SFTUser : NSObject <NSCoding, NSCopying>

@property (strong, readonly) NSString *userName;
@property (strong, readonly) NSString *token;
@property (strong, readonly) NSString *refreshToken;
@property (strong, readonly) NSDate *tokenExpiration;

/**-----------------------------------------------------------------------------
 * @name Initializing user object
 *  ----------------------------------------------------------------------------
 */

/** Initializes user object with supplied data
 
 Returns SFTUser object initizalized with provided data.
 
 @param userName User's username.
 @param token Access token.
 @param refreshToken Refresh token.
 @param tokenExpiration Token expiration date.
 */
- (id)initWithUserName:(NSString *)userName
                  token:(NSString *)token
             refreshToken:(NSString *)refreshToken
        tokenExpiration:(NSDate *)tokenExpiration;

/**-----------------------------------------------------------------------------
 * @name Updating user object
 *  ----------------------------------------------------------------------------
 */

/** Updates user object with new token information
 
 Updates SFTUser object new token information.
 
 Use this method to update token information after refreshing access token.
 
 @param token Access token.
 @param refreshToken Refresh token.
 @param tokenExpiration Token expiration date.
 */
- (void)updateToken:(NSString *)token
       refreshToken:(NSString *)refreshToken
    tokenExpiration:(NSDate *)tokenExpiration;

/**-----------------------------------------------------------------------------
 * @name Inspecting user object
 *  ----------------------------------------------------------------------------
 */

/** Checks user object for token validity
 
 Checks SFTUser object for access token validy.
 
This method checks access token expiration date against current date to
 determine its validty.
 */
- (BOOL)hasValidToken;

@end
