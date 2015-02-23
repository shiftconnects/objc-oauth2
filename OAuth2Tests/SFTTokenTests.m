//
//  SFTUserTests.m
//  OAuth
//
//  Created by Tom Zaworowski on 5/23/14.
//  Copyright (c) 2014 Project 100, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SFTToken.h"

@interface SFTTokenTests : XCTestCase

@end

@implementation SFTTokenTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNilInit {
    SFTToken *testToken = [[SFTToken alloc] initWithAccessToken:nil
                                                   refreshToken:nil
                                                     expiration:nil];
    
    XCTAssertNotNil(testToken, @"Failed to create user object with nil objects");
    
    XCTAssertNil(testToken.accessToken, @"should be nil");
    XCTAssertNil(testToken.refreshToken, @"should be nil");
    XCTAssertNil(testToken.expiration, @"should be nil");
}

- (void)testEmptyInit {
    SFTToken *testToken = [[SFTToken alloc] initWithAccessToken:[NSString new]
                                                   refreshToken:[NSString new]
                                                     expiration:[NSDate new]];
    
    XCTAssertNotNil(testToken, @"Failed to create user object with empty objects");
    
    XCTAssertNotNil(testToken.accessToken, @"should exist");
    XCTAssertNotNil(testToken.expiration, @"should exist");
    XCTAssertNotNil(testToken.refreshToken, @"should exist");
}

- (void)testTokenValidty {
    NSDate *expiredDate = [NSDate distantPast];
    NSDate *freshDate = [NSDate distantFuture];
    
    SFTToken *testToken = [[SFTToken alloc] initWithAccessToken:@"test"
                                                   refreshToken:@"test"
                                                     expiration:expiredDate];
    
    XCTAssertFalse(testToken.isValid, @"should be expired");
    
    [testToken updateAccessToken:@"test"
                    refreshToken:@"test"
                 expiration:freshDate];
    
    XCTAssert(testToken.isValid, @"should be valid");
}

- (void)testTokenCopy {
    SFTToken *testToken = [[SFTToken alloc] initWithAccessToken:@"test"
                                                   refreshToken:@"test"
                                                     expiration:[NSDate date]];
    
    SFTToken *tokenCopy = [testToken copy];
    
    XCTAssertEqualObjects(testToken, tokenCopy);
}

//- (void)testSecureCodingSupport {
//    XCTAssert([SFTUser supportsSecureCoding], @"should support secure coding");
//}

- (void)testDescription {
    SFTToken *testToken = [[SFTToken alloc] initWithAccessToken:@"test"
                                                   refreshToken:@"test"
                                                     expiration:[NSDate date]];
    
    XCTAssertNotNil(testToken.description, @"should not be nil");
}

@end
