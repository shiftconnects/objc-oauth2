//
//  SFTTestURLProtocol.m
//  Shift
//
//  Created by Tom Zaworowski on 5/27/14.
//  Copyright (c) 2014 Project 100, Inc. All rights reserved.
//

#import "SFTTestURLProtocol.h"

static NSData *responseData = nil;
static NSInteger responseCode = 200;

@implementation SFTTestURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    NSSet *validSchemes = [NSSet setWithArray:@[@"http",
                                         @"https"]];
    return [validSchemes containsObject:request.URL.scheme];
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
	return request;
}

- (void)startLoading {
    id <NSURLProtocolClient> client = self.client;
    NSURLRequest *request = self.request;
    
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:request.URL
                                                              statusCode:responseCode
                                                             HTTPVersion:@"HTTP/1.1"
                                                            headerFields:nil];
    
    [client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    if (responseData) {
        [client URLProtocol:self didLoadData:responseData];
        [client URLProtocolDidFinishLoading:self];
    } else {
        NSError *error = [NSError errorWithDomain:@"com.shiftconnects.OAuth2.Test"
                                             code:101
                                         userInfo:nil];
        [client URLProtocol:self didFailWithError:error];
    }
}

- (void)stopLoading {
    // We send all the data at once, so there is nothing to do here.
}

+ (void)setResponseData:(NSData *)data {
    responseData = data;
}

+ (void)setResponseCode:(NSInteger)code {
    responseCode = code;
}

@end
