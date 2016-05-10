//
//  LoginViewControllerTests.m
//  EmployeeDirectory
//
//  Created by Naveen on 4/28/16.
//  Copyright © 2016 Christophe Coenraets. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LoginViewController.h"
#import "Utility.h"
#import "Network.h"

@interface LoginViewControllerTests : XCTestCase

@property (nonatomic, strong) LoginViewController *loginViewController;

@end

@implementation LoginViewControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _loginViewController= [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"loginVC"];
    [_loginViewController performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testUserAuthenticationSuccess
{
    XCTAssertNoThrow( [_loginViewController validateCredentials:@"admin" password:@"niit@12345"]);
}

-(void)testUserAuthenticationFailed
{
    XCTAssertNoThrow([_loginViewController validateCredentials:@"admin" password:@"niit@123"]);
}

-(void)testEmptyUserAuthentication
{
    XCTAssertNoThrow([[Utility sharedManager] checkUser:@"" password:@""]);
}

-(void)testValidateOnlineUser
{
    XCTAssertNoThrow([[Network sharedManager] validateOnline:@"" password:@""]);
}


-(void)testSignIn
{
    XCTAssertNoThrow([_loginViewController signInPressed:nil]);
}

-(void)testAlertMsg
{
    XCTAssertNoThrow([_loginViewController showAlert:@"Kindly enter Valid Credentials"]);
}

-(void)testViewWillDisappear
{
    XCTAssertNoThrow([_loginViewController viewWillDisappear:YES]);
}
@end
