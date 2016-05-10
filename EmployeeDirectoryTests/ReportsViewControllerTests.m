//
//  ReportsViewControllerTests.m
//  EmployeeDirectory
//
//  Created by Naveen on 4/28/16.
//  Copyright © 2016 Christophe Coenraets. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ReportsViewController.h"
#import "Utility.h"
#import "Employee.h"


@interface ReportsViewControllerTests : XCTestCase

@property (nonatomic, strong) ReportsViewController *reportsViewController;
@property (nonatomic, strong) NSArray *reports;
@property (nonatomic, strong) Utility *utils;
@end

@implementation ReportsViewControllerTests

- (void)setUp {
    [super setUp];
    _reportsViewController= [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ReportsVC"];
    [_reportsViewController performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    
    _utils = [Utility sharedManager];
    _reportsViewController.managedObjectContext = _utils.managedObjectContext;
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Employee" inManagedObjectContext:_reportsViewController.managedObjectContext];
    
    // Find the direct reports
    NSFetchRequest *reportsRequest = [[NSFetchRequest alloc] init];
    [reportsRequest setEntity:entityDescription];
    
    NSPredicate *reportsPredicate = [NSPredicate predicateWithFormat:@"managerId == %@", [NSNumber numberWithInt:1]];
    [reportsRequest setPredicate:reportsPredicate];
    
    NSError *error;
    self.reports = [_reportsViewController.managedObjectContext executeFetchRequest:reportsRequest error:&error];
    _reportsViewController.reports = self.reports;
    
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

-(void)testThatTableViewLoads
{
    XCTAssertNotNil(_reportsViewController.tableView, @"TableView not initiated");
}


#pragma mark - UITableView tests
- (void)testThatViewConformsToUITableViewDataSource
{
    XCTAssertTrue([_reportsViewController conformsToProtocol:@protocol(UITableViewDataSource) ], @"View does not conform to UITableView datasource protocol");
}



- (void)testThatViewConformsToUITableViewDelegate
{
    XCTAssertTrue([_reportsViewController conformsToProtocol:@protocol(UITableViewDelegate) ], @"View does not conform to UITableView delegate protocol");
}



- (void)testTableViewNumberOfRowsInSection
{
    NSInteger expectedRows = [self.reports count];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSInteger actualRows = [_reportsViewController tableView:_reportsViewController.tableView numberOfRowsInSection:[indexPath section]];
    XCTAssertTrue((expectedRows==actualRows), @"Number of rows is not assigned correctly");
    
}


- (void)testTableViewCellCreateCellsWithReuseIdentifier
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    UITableViewCell *cell = ([_reportsViewController tableView:_reportsViewController.tableView cellForRowAtIndexPath:indexPath]);
    XCTAssertTrue(![cell.textLabel.text isEqualToString:@""], @"Table does not create reusable cells");
}

-(void)testDidSelectCell
{

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_reportsViewController tableView:_reportsViewController.tableView didSelectRowAtIndexPath:indexPath];
    XCTAssertTrue(true,@"Table rows can't be selected");
    
}


@end
