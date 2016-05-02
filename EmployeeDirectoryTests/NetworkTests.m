//
//  NetworkTests.m
//  EmployeeDirectory
//
//  Created by Naveen on 4/29/16.
//  Copyright © 2016 Christophe Coenraets. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Network.h"

@interface NetworkTests : XCTestCase

@property (nonatomic, strong) Network * networkUtils;
@end

@implementation NetworkTests

- (void)setUp {
    [super setUp];
    _networkUtils = [Network sharedManager];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testUserAuthentication
{
    [_networkUtils validateOnline:@"admin" password:@"niit@12345"];
}

@end
