//
//  ContactFriendMakingTests.m
//  ContactFriendMakingTests
//
//  Created by CPU11899 on 7/22/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "../ContactFriendMaking/Business/ContactBusiness.h"

@interface ContactFriendMakingTests : XCTestCase
@property ContactBussiness* testInstance;
@end

@implementation ContactFriendMakingTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testSearching {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSArray* searchText = @[@"A",@"B",@"C"];
    NSArray* searchResult = @[@3,@1,@4];
    
}

- (void)testSelectContact {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
}

- (void)testDeselectContact {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
}

- (void)testSelectWhileSearch {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
}

- (void)testDeselectWhileSearch {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
