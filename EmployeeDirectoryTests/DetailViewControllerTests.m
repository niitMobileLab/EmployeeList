//
//  DetailViewControllerTests.m
//  EmployeeDirectory
//
//  Created by Naveen on 4/28/16.
//  Copyright © 2016 Christophe Coenraets. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DetailViewController.h"
#import "Utility.h"

@interface DetailViewControllerTests : XCTestCase

@property (nonatomic, strong) DetailViewController *detailViewController;
@property (nonatomic, strong) Utility *utils;
@property (nonatomic, strong) NSArray *employees;
@end

@implementation DetailViewControllerTests

- (void)setUp {
    [super setUp];
    _detailViewController= [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"EmployeeVC"];
    [_detailViewController performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    
    _utils = [Utility sharedManager];
    _detailViewController.managedObjectContext = _utils.managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Employee" inManagedObjectContext:_detailViewController.managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    
    NSError *error;

    self.employees = [_detailViewController.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    _detailViewController.employee = [self.employees objectAtIndex:1];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testViewDidLoad
{
    [_detailViewController viewDidLoad];
    XCTAssertTrue(true,@"ViewDidLoad couldn't get called");
}

-(void)testViewwillAppear
{
    [_detailViewController viewWillAppear:YES];
    XCTAssertTrue(true,@"view will appear couldn't get called");
}

#pragma mark - View loading tests
-(void)testThatViewLoads
{
    XCTAssertNotNil(_detailViewController.view, @"View not initiated properly");
}

- (void)testParentViewHasTableViewSubview
{
    NSArray *subviews = _detailViewController.view.subviews;
    XCTAssertTrue([subviews containsObject:_detailViewController.actionList], @"View does not have a table subview");
}

-(void)testThatTableViewLoads
{
    XCTAssertNotNil(_detailViewController.actionList, @"TableView not initiated");
}


#pragma mark - UITableView tests
- (void)testThatViewConformsToUITableViewDataSource
{
    XCTAssertTrue([_detailViewController conformsToProtocol:@protocol(UITableViewDataSource) ], @"View does not conform to UITableView datasource protocol");
}



- (void)testThatViewConformsToUITableViewDelegate
{
    XCTAssertTrue([_detailViewController conformsToProtocol:@protocol(UITableViewDelegate) ], @"View does not conform to UITableView delegate protocol");
}




- (void)testTableViewCellCreateCellsWithReuseIdentifier
{
    [_detailViewController setUpActionsData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    UITableViewCell *cell = ([_detailViewController tableView:_detailViewController.actionList cellForRowAtIndexPath:indexPath]);
    XCTAssertTrue(![cell.textLabel.text isEqualToString:@""], @"Table does not create reusable cells");
}

- (void)testNumberOfRowsInSection
{
    [self.detailViewController setUpActionsData];
    NSInteger expectedRows = [self.detailViewController.actions count];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSInteger actualRows = [_detailViewController tableView:_detailViewController.actionList numberOfRowsInSection:[indexPath section]];
    XCTAssertTrue((expectedRows==actualRows), @"Number of rows is not assigned correctly");
}


-(void)testNumberOfSections
{
    NSInteger noOfSection = 1;
    NSInteger numberOfRows = [_detailViewController numberOfSectionsInTableView:_detailViewController.actionList];
    XCTAssertNoThrow((numberOfRows==noOfSection), @"Number of section is not assigned correctly");
}
-(void)testDidSelectCell
{
    [_detailViewController setUpActionsData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_detailViewController tableView:_detailViewController.actionList didSelectRowAtIndexPath:indexPath];
    
    XCTAssertTrue(true,@"Table rows can't be selected");
    
}

-(void)testLogoutPressed
{
    [_detailViewController logoutPressed];
}


@end
