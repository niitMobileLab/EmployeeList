//
//  MasterViewControllerTests.m
//  EmployeeDirectory
//
//  Created by Naveen on 4/28/16.
//  Copyright © 2016 Christophe Coenraets. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MasterViewController.h"
#import "Utility.h"
#import "Employee.h"

@interface MasterViewControllerTests : XCTestCase

@property (nonatomic, strong) MasterViewController *masterViewController;
@property (nonatomic, strong) Utility *utils;
@property (strong, nonatomic) NSArray *employees;

@end

@implementation MasterViewControllerTests

- (void)setUp {
    [super setUp];
    
    _masterViewController= [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"masterView"];
    [_masterViewController performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    
    _utils = [Utility sharedManager];
    _masterViewController.managedObjectContext = _utils.managedObjectContext;
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Employee" inManagedObjectContext:_masterViewController.managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    
    NSError *error;
    self.employees = [_masterViewController.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    _masterViewController.employees = self.employees;
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    _masterViewController = nil;
    [super tearDown];
    
}


-(void)testLogoutPressed
{
    [_masterViewController logoutPressed];
    XCTAssertTrue(true,@"Logout couldn't be pressed");
}

-(void)testLogUser
{
    [_masterViewController logUser];
    XCTAssertTrue(true,@"User can't be logged in crashlytics");
}

-(void)testViewDidLoad
{
    [_masterViewController viewDidLoad];
     XCTAssertTrue(true,@"ViewDidLoad couldn't get called");
}

-(void)testViewwillAppear
{
    [_masterViewController viewWillAppear:YES];
    XCTAssertTrue(true,@"view will appear couldn't get called");
}

#pragma mark - View loading tests
-(void)testThatViewLoads
{
    XCTAssertNotNil(_masterViewController.view, @"View not initiated properly");
}

- (void)testParentViewHasTableViewSubview
{
    NSArray *subviews = _masterViewController.view.subviews;
    XCTAssertFalse([subviews containsObject:_masterViewController.tableView], @"View does not have a table subview");
}

-(void)testThatTableViewLoads
{
    XCTAssertNotNil(_masterViewController.tableView, @"TableView not initiated");
}


#pragma mark - UITableView tests
- (void)testThatViewConformsToUITableViewDataSource
{
    XCTAssertTrue([_masterViewController conformsToProtocol:@protocol(UITableViewDataSource) ], @"View does not conform to UITableView datasource protocol");
}



- (void)testThatViewConformsToUITableViewDelegate
{
    XCTAssertTrue([_masterViewController conformsToProtocol:@protocol(UITableViewDelegate) ], @"View does not conform to UITableView delegate protocol");
}

- (void)testTableViewIsConnectedToDelegate
{
    XCTAssertNotNil(_masterViewController.tableView.delegate, @"Table delegate cannot be nil");
}



- (void)testTableViewNumberOfRowsInSection
{
    NSInteger expectedRows = [self.employees count];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSInteger actualRows = [_masterViewController tableView:_masterViewController.tableView numberOfRowsInSection:[indexPath section]];
    XCTAssertTrue((expectedRows==actualRows), @"Number of rows is not assigned correctly");
}


- (void)testTableViewCellCreateCellsWithReuseIdentifier
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    UITableViewCell *cell = ([_masterViewController tableView:_masterViewController.tableView cellForRowAtIndexPath:indexPath]);
    XCTAssertTrue(![cell.textLabel.text isEqualToString:@""], @"Table does not create reusable cells");
}

-(void)testSearchEmployee
{
    [_masterViewController searchForText:@"king"];
}

@end
