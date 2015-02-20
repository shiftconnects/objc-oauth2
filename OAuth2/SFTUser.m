//
//  SFTUser.m
//  Shift
//
//  Created by Tom Zaworowski on 3/21/14.
//  Copyright (c) 2014 Project 100, Inc. All rights reserved.
//

#import "SFTUser.h"

#import "NSDate+Comparison.h"

@implementation SFTUser

- (id)initWithUserName:(NSString *)userName
                  token:(NSString *)token
             refreshToken:(NSString *)refreshToken
        tokenExpiration:(NSDate *)expiration {
    self = [self init];
    if (self) {
        _userName = userName;
        _token = token;
        _refreshToken = refreshToken;
        _tokenExpiration = expiration;
    }
    
    return self;
}

- (void)updateToken:(NSString *)token
       refreshToken:(NSString *)refreshToken
    tokenExpiration:(NSDate *)tokenExpiration {
    _token = token;
    _refreshToken = refreshToken;
    _tokenExpiration = tokenExpiration;
}

- (BOOL)hasValidToken {
    NSDate *now = [NSDate date];
    
    NSTimeInterval expirationDelta = [self.tokenExpiration timeIntervalSinceDate:now];
    if (expirationDelta > 5) {
        return YES;
    }
    return NO;
}

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [self init];
    if (self) {
        _userName = [decoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(userName))];
        _token = [decoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(token))];
        _refreshToken = [decoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(refreshToken))];
        _tokenExpiration = [decoder decodeObjectOfClass:[NSDate class] forKey:NSStringFromSelector(@selector(tokenExpiration))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.userName forKey:NSStringFromSelector(@selector(userName))];
    [encoder encodeObject:self.token forKey:NSStringFromSelector(@selector(token))];
    [encoder encodeObject:self.refreshToken forKey:NSStringFromSelector(@selector(refreshToken))];
    [encoder encodeObject:self.tokenExpiration forKey:NSStringFromSelector(@selector(tokenExpiration))];
}

#pragma mark -

- (NSString *)description {
    return self.userName;
}

- (BOOL)isEqual:(id)object {
    return ([object isKindOfClass:[SFTUser class]] &&
            [[object userName] isEqualToString:_userName]);
}

- (id)copyWithZone:(NSZone *)zone {
    SFTUser *user = [[self.class allocWithZone:zone] initWithUserName:self.userName
                                                                token:self.token
                                                         refreshToken:self.refreshToken
                                                      tokenExpiration:self.tokenExpiration];
    
    return user;
}

@end
