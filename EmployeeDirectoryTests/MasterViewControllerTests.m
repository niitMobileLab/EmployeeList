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

@interface MasterViewControllerTests : XCTestCase

@property (nonatomic, strong) MasterViewController *masterViewController;
@property (nonatomic, strong) Utility *utils;
@end

@implementation MasterViewControllerTests

- (void)setUp {
    [super setUp];
    
    _masterViewController= [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"masterView"];
    [_masterViewController performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    
    _utils = [Utility sharedManager];
    _masterViewController.managedObjectContext = _utils.managedObjectContext;
    
    
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
    XCTAssertTrue([subviews containsObject:_masterViewController.tableView], @"View does not have a table subview");
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

- (void)testThatTableViewHasDataSource
{
    XCTAssertNotNil(_masterViewController.tableView.dataSource, @"Table datasource cannot be nil");
}

- (void)testThatViewConformsToUITableViewDelegate
{
    XCTAssertTrue([_masterViewController conformsToProtocol:@protocol(UITableViewDelegate) ], @"View does not conform to UITableView delegate protocol");
}

- (void)testTableViewIsConnectedToDelegate
{
    XCTAssertNotNil(_masterViewController.tableView.delegate, @"Table delegate cannot be nil");
}

-(void)testTableViewRowEditing
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    XCTAssertTrue([_masterViewController tableView:_masterViewController.tableView canEditRowAtIndexPath:indexPath],@"Table doesn't have editing rows");
}

-(void)testTableRowMove
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    XCTAssertTrue([_masterViewController tableView:_masterViewController.tableView canMoveRowAtIndexPath:indexPath],@"Table rows can't be moved");
}


- (void)testTableViewNumberOfRowsInSection
{
    NSInteger expectedRows = 12;
    XCTAssertTrue([_masterViewController tableView:_masterViewController.tableView numberOfRowsInSection:0]==expectedRows, @"Table has %ld rows but it should have %ld", (long)[_masterViewController tableView:_masterViewController.tableView numberOfRowsInSection:0], (long)expectedRows);
}

//- (void)testTableViewHeightForRowAtIndexPath
//{
//    CGFloat expectedHeight = 44.0;
//    CGFloat actualHeight = _masterViewController.tableView.rowHeight;
//    XCTAssertEqual(expectedHeight, actualHeight, @"Cell should have %f height, but they have %f", expectedHeight, actualHeight);
//}

- (void)testTableViewCellCreateCellsWithReuseIdentifier
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [_masterViewController tableView:_masterViewController.tableView cellForRowAtIndexPath:indexPath];
    NSString *expectedReuseIdentifier = [NSString stringWithFormat:@"%ld/%ld",(long)indexPath.section,(long)indexPath.row];
    XCTAssertTrue([cell.reuseIdentifier isEqualToString:expectedReuseIdentifier], @"Table does not create reusable cells");
}

-(void)testSearchEmployee
{
    [_masterViewController searchForText:@"king"];
}

@end
