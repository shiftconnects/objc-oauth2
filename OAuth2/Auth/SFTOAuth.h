//
//  SFTOAuth.h
//  OAuth2
//
//  Created by Tom Zaworowski on 2/20/15.
//  Copyright (c) 2015 P100 OG, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SFTToken;

typedef void (^requestReturnBlock)(NSData *data, NSError *error);
typedef void (^tokenRequestReturnBlock)(SFTToken *token,
                                        NSError *error);

@interface SFTOAuth : NSObject

/**-----------------------------------------------------------------------------
 * @name Performing signed requests
 *  ----------------------------------------------------------------------------
 */

/** Performs a signed request on behalf of the user.
 
 Returns NSData object returned by the service.
 
 If unsuccessful, it returns an NSError object.
 
 @param request NSURLRequest to be signed.
 @param token SFTToken object seeded with token information.
 @param clientId Your app's client ID.
 @param clientSecret Your app's client secret.
 @param authServer Authentication server URL.
 */
+ (void)performRequest:(NSURLRequest *)request
             withToken:(SFTToken *)token
              clientId:(NSString *)clientId
          clientSecret:(NSString *)clientSecret
  authenticationServer:(NSURL *)authServer
                      :(requestReturnBlock)completionBlock;

+ (BOOL)cancelRequest:(NSURLRequest *)request;


/**-----------------------------------------------------------------------------
 * @name Exchanging user credentials for access token
 *  ----------------------------------------------------------------------------
 */

/** Exchanges user credentials for access token.
 
 Returns SFTToken.
 
 If unsuccessful it returns an NSError object.
 
 @param user User's username.
 @param password User's password.
 @param clientId Your app's client ID.
 @param clientSecret Your app's client secret.
 @param authServer Authentication server URL.
 */
+ (void)requestAccessToken:(NSString *)user
                  password:(NSString *)password
                  clientId:(NSString *)clientId
              clientSecret:(NSString *)clientSecret
      authenticationServer:(NSURL *)authServer
                          :(tokenRequestReturnBlock)completionBlock;

@end
