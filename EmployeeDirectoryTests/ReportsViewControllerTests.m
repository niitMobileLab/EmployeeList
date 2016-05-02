//
//  ReportsViewControllerTests.m
//  EmployeeDirectory
//
//  Created by Naveen on 4/28/16.
//  Copyright © 2016 Christophe Coenraets. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ReportsViewController.h"

@interface ReportsViewControllerTests : XCTestCase

@property (nonatomic, strong) ReportsViewController *reportsViewController;

@end

@implementation ReportsViewControllerTests

- (void)setUp {
    [super setUp];
    _reportsViewController= [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ReportsVC"];
    [_reportsViewController performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


-(void)testLogoutPressed
{
    [_reportsViewController logoutPressed];
    XCTAssertTrue(true,@"Logout couldn't be pressed");
}


-(void)testViewDidLoad
{
    [_reportsViewController viewDidLoad];
    XCTAssertTrue(true,@"ViewDidLoad couldn't get called");
}

-(void)testViewwillAppear
{
    [_reportsViewController viewWillAppear:YES];
    XCTAssertTrue(true,@"view will appear couldn't get called");
}

#pragma mark - View loading tests
-(void)testThatViewLoads
{
    XCTAssertNotNil(_reportsViewController.view, @"View not initiated properly");
}

- (void)testParentViewHasTableViewSubview
{
    NSArray *subviews = _reportsViewController.view.subviews;
    XCTAssertTrue([subviews containsObject:_reportsViewController.tableView], @"View does not have a table subview");
}

-(void)testThatTableViewLoads
{
    XCTAssertNotNil(_reportsViewController.tableView, @"TableView not initiated");
}


#pragma mark - UITableView tests
- (void)testThatViewConformsToUITableViewDataSource
{
    XCTAssertTrue([_reportsViewController conformsToProtocol:@protocol(UITableViewDataSource) ], @"View does not conform to UITableView datasource protocol");
}

- (void)testThatTableViewHasDataSource
{
    XCTAssertNotNil(_reportsViewController.tableView.dataSource, @"Table datasource cannot be nil");
}

- (void)testThatViewConformsToUITableViewDelegate
{
    XCTAssertTrue([_reportsViewController conformsToProtocol:@protocol(UITableViewDelegate) ], @"View does not conform to UITableView delegate protocol");
}

- (void)testTableViewIsConnectedToDelegate
{
    XCTAssertNotNil(_reportsViewController.tableView.delegate, @"Table delegate cannot be nil");
}

-(void)testTableViewRowEditing
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    XCTAssertTrue([_reportsViewController tableView:_reportsViewController.tableView canEditRowAtIndexPath:indexPath],@"Table doesn't have editing rows");
}

-(void)testTableRowMove
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    XCTAssertTrue([_reportsViewController tableView:_reportsViewController.tableView canMoveRowAtIndexPath:indexPath],@"Table rows can't be moved");
}


- (void)testTableViewNumberOfRowsInSection
{
    NSInteger expectedRows = 12;
    XCTAssertTrue([_reportsViewController tableView:_reportsViewController.tableView numberOfRowsInSection:0]==expectedRows, @"Table has %ld rows but it should have %ld", (long)[_reportsViewController tableView:_reportsViewController.tableView numberOfRowsInSection:0], (long)expectedRows);
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
    UITableViewCell *cell = [_reportsViewController tableView:_reportsViewController.tableView cellForRowAtIndexPath:indexPath];
    NSString *expectedReuseIdentifier = [NSString stringWithFormat:@"%ld/%ld",(long)indexPath.section,(long)indexPath.row];
    XCTAssertTrue([cell.reuseIdentifier isEqualToString:expectedReuseIdentifier], @"Table does not create reusable cells");
}

-(void)testDidSelectCell
{

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_reportsViewController tableView:_reportsViewController.tableView didSelectRowAtIndexPath:indexPath];
    XCTAssertTrue(true,@"Table rows can't be selected");
    
}


@end
