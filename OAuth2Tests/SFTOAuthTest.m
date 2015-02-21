//
//  SFTOAuthTest.m
//  OAuth2
//
//  Created by Tom Zaworowski on 2/20/15.
//  Copyright (c) 2015 P100 OG, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "XCTest+Wait.h"

#import "SFTTestURLProtocol.h"

#import "SFTOAuth.h"

#import "SFTUser.h"

@interface SFTOAuth ()

+ (NSURLRequest *)signedRequest:(NSURLRequest *)request token:(NSString *)token;

@end

@interface SFTOAuthTest : XCTestCase

@end

@implementation SFTOAuthTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    [NSURLProtocol registerClass:[SFTTestURLProtocol class]];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    [NSURLProtocol unregisterClass:[SFTTestURLProtocol class]];
    
    [super tearDown];
}

- (void)testPerformRequestSuccess {
    [SFTTestURLProtocol setResponseData:[NSData new]];
    [SFTTestURLProtocol setResponseCode:200];
    
    NSURL *testURL = [NSURL URLWithString:@"http://test.test"];
    NSURLRequest *testRequest = [NSURLRequest requestWithURL:testURL];
    
    SFTUser *testUser = [[SFTUser alloc] initWithUserName:@"test"
                                                    token:@"test"
                                             refreshToken:@"test"
                                          tokenExpiration:[NSDate distantFuture]];
    
    [SFTOAuth performRequest:testRequest
                     forUser:testUser
                    clientId:nil
                clientSecret:nil
        authenticationServer:testURL
                            :^(NSData *data, NSError *error)
     {
         XCTAssertNotNil(data, @"should not be nil");
         XCTAssertNil(error, @"should be nil");
     }];
    
    [self waitForCompletion:0.1];
}

- (void)testPerformRequestFailure {
    [SFTTestURLProtocol setResponseData:nil];
    [SFTTestURLProtocol setResponseCode:500];
    
    NSURL *testURL = [NSURL URLWithString:@"http://test.test"];
    NSURLRequest *testRequest = [NSURLRequest requestWithURL:testURL];
    
    [SFTOAuth performRequest:testRequest
                     forUser:nil
                    clientId:nil
                clientSecret:nil
        authenticationServer:testURL
                            :^(NSData *data, NSError *error)
     {
         XCTAssertNotNil(error, @"should not be nil");
         XCTAssertNil(data, @"should be nil");
     }];
    
    [self waitForCompletion:0.1];
}

- (void)testRequestSigning {
    SFTUser *testUser = [[SFTUser alloc] initWithUserName:@"test"
                                                    token:@"test"
                                             refreshToken:@"test"
                                          tokenExpiration:[NSDate distantFuture]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://test.test"]];
    NSURLRequest *testRequest = [SFTOAuth signedRequest:request token:testUser.token];
    
    NSString *authHeader = testRequest.allHTTPHeaderFields[@"Authorization"];
    NSString *tokenString = [[authHeader componentsSeparatedByString:@" "] lastObject];
    
    XCTAssertNotNil(authHeader, @"should not be nil");
    XCTAssert([tokenString isEqualToString:testUser.token], @"should be equal");
}

- (void)testAccessTokenRequestSuccess {
    NSDictionary *json = @{@"access_token": @"mock",
                           @"refresh_token": @"mock",
                           @"expires_in": @"0"};
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
    
    [SFTTestURLProtocol setResponseData:data];
    [SFTTestURLProtocol setResponseCode:200];
    
    NSURL *testURL = [NSURL URLWithString:@"http://test.test"];
    
    [SFTOAuth requestAccessToken:@"test"
                        password:@"test"
                        clientId:@"test"
                    clientSecret:@"test"
            authenticationServer:testURL
                                :^(NSString *token,
                                   NSString *refreshToken,
                                   NSDate *expirationDate,
                                   NSError *error)
     {
         XCTAssertNotNil(token, @"should not be nil");
         XCTAssertNotNil(refreshToken, @"should not be nil");
         XCTAssertNotNil(expirationDate, @"should not be nil");
         XCTAssertNil(error, @"should be nil");
     }];
    
    [self waitForCompletion:0.1];
}

- (void)testAccessTokenRequestFail {
    [SFTTestURLProtocol setResponseData:nil];
    [SFTTestURLProtocol setResponseCode:500];
    
    NSURL *testURL = [NSURL URLWithString:@"http://test.test"];
    
    [SFTOAuth requestAccessToken:@"test"
                        password:@"test"
                        clientId:@"test"
                    clientSecret:@"test"
            authenticationServer:testURL
                                :^(NSString *token,
                                   NSString *refreshToken,
                                   NSDate *expirationDate,
                                   NSError *error)
     {
         XCTAssertNotNil(error, @"should not be nil");
         XCTAssertNil(token, @"should be nil");
         XCTAssertNil(refreshToken, @"should be nil");
         XCTAssertNil(expirationDate, @"should be nil");
     }];
    
    [self waitForCompletion:0.1];
}

@end
