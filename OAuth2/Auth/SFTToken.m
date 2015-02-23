//
//  SFTUser.m
//  Shift
//
//  Created by Tom Zaworowski on 3/21/14.
//  Copyright (c) 2014 Project 100, Inc. All rights reserved.
//

#import "SFTToken.h"

#import "NSDate+Comparison.h"

@implementation SFTToken

- (id)initWithAccessToken:(NSString *)accessToken
             refreshToken:(NSString *)refreshToken
               expiration:(NSDate *)expiration {
    self = [self init];
    if (self) {
        _accessToken = accessToken;
        _refreshToken = refreshToken;
        _expiration = expiration;
    }
    
    return self;
}

- (void)updateAccessToken:(NSString *)accessToken
             refreshToken:(NSString *)refreshToken
               expiration:(NSDate *)expiration {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _expiration = expiration;
}

- (BOOL)isValid {
    NSDate *now = [NSDate date];
    
    NSTimeInterval expirationDelta = [self.expiration timeIntervalSinceDate:now];
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
        _accessToken = [decoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(accessToken))];
        _refreshToken = [decoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(refreshToken))];
        _expiration = [decoder decodeObjectOfClass:[NSDate class] forKey:NSStringFromSelector(@selector(expiration))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.accessToken forKey:NSStringFromSelector(@selector(accessToken))];
    [encoder encodeObject:self.refreshToken forKey:NSStringFromSelector(@selector(refreshToken))];
    [encoder encodeObject:self.expiration forKey:NSStringFromSelector(@selector(expiration))];
}

#pragma mark -

- (NSString *)description {
    return self.accessToken;
}

- (BOOL)isEqual:(id)object {
    return ([object isKindOfClass:[SFTToken class]] &&
            [[object accessToken] isEqualToString:_accessToken]);
}

- (id)copyWithZone:(NSZone *)zone {
    SFTToken *user = [[self.class allocWithZone:zone] initWithAccessToken:self.accessToken
                                                             refreshToken:self.refreshToken
                                                               expiration:self.expiration];
    
    return user;
}

@end
