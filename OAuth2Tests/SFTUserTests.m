//
//  SFTUserTests.m
//  OAuth
//
//  Created by Tom Zaworowski on 5/23/14.
//  Copyright (c) 2014 Project 100, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SFTUser.h"

@interface SFTUserTests : XCTestCase

@end

@implementation SFTUserTests

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
    SFTUser *testUser = [[SFTUser alloc] initWithUserName:nil
                                                    token:nil
                                             refreshToken:nil
                                          tokenExpiration:nil];
    
    XCTAssertNotNil(testUser, @"Failed to create user object with nil objects");
    
    XCTAssertNil(testUser.userName, @"should be nil");
    XCTAssertNil(testUser.token, @"should be nil");
    XCTAssertNil(testUser.refreshToken, @"should be nil");
    XCTAssertNil(testUser.tokenExpiration, @"should be nil");
}

- (void)testEmptyInit {
    SFTUser *testUser = [[SFTUser alloc] initWithUserName:[NSString new]
                                                    token:[NSString new]
                                             refreshToken:[NSString new]
                                          tokenExpiration:[NSDate new]];
    
    XCTAssertNotNil(testUser, @"Failed to create user object with empty objects");
    
    XCTAssertNotNil(testUser.userName, @"should exist");
    XCTAssertNotNil(testUser.token, @"should exist");
    XCTAssertNotNil(testUser.tokenExpiration, @"should exist");
    XCTAssertNotNil(testUser.refreshToken, @"should exist");
}

- (void)testTokenValidty {
    NSDate *expiredDate = [NSDate distantPast];
    NSDate *freshDate = [NSDate distantFuture];
    
    SFTUser *testUser = [[SFTUser alloc] initWithUserName:@"test"
                                                    token:@"test"
                                             refreshToken:@"test"
                                          tokenExpiration:expiredDate];
    
    XCTAssertFalse(testUser.hasValidToken, @"should be expired");
    
    [testUser updateToken:@"test"
             refreshToken:@"test"
          tokenExpiration:freshDate];
    
    XCTAssert(testUser.hasValidToken, @"should be valid");
}

//- (void)testSecureCodingSupport {
//    XCTAssert([SFTUser supportsSecureCoding], @"should support secure coding");
//}

- (void)testDescription {
    SFTUser *testUser = [[SFTUser alloc] initWithUserName:@"test"
                                                    token:@"test"
                                             refreshToken:@"test"
                                          tokenExpiration:[NSDate date]];
    
    XCTAssertNotNil(testUser.description, @"should not be nil");
}

@end
