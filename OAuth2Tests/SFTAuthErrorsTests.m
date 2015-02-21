//
//  SFTAuthErrorsTests.m
//  OAuth
//
//  Created by Tom Zaworowski on 5/23/14.
//  Copyright (c) 2014 Project 100, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SFTAuthErrors.h"

@interface SFTAuthErrorsTests : XCTestCase

@end

@implementation SFTAuthErrorsTests

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

- (void)testUserInfoConstruction
{
    NSDictionary *testUserInfo = nil;
    
    testUserInfo = userInfoForErrorCode(SFTAuthErrorGenericCode);
    XCTAssertNotNil(testUserInfo[NSLocalizedDescriptionKey], @"should not be nil");
    XCTAssertNotNil(testUserInfo[NSLocalizedFailureReasonErrorKey], @"should not be nil");
    
    testUserInfo = userInfoForErrorCode(SFTAuthErrorUnauthorizedCode);
    XCTAssertNotNil(testUserInfo[NSLocalizedDescriptionKey], @"should not be nil");
    XCTAssertNotNil(testUserInfo[NSLocalizedFailureReasonErrorKey], @"should not be nil");
}

@end
