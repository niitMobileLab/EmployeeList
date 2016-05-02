//
//  MasterViewController.m
//  EmployeeDirectory
//
//  Created by Christophe Coenraets on 11/12/13.
//  Copyright (c) 2013 Christophe Coenraets. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Employee.h"
#import <Google/Analytics.h>
#import <Crashlytics/Crashlytics.h>
#import "Utility.h"

@interface MasterViewController () <UISearchDisplayDelegate, UISearchBarDelegate>
@property (strong, nonatomic) NSArray *employees;
@property (strong, nonatomic) NSArray *filteredEmployees;
@property (strong, nonatomic) NSFetchRequest *searchFetchRequest;
@end

@implementation MasterViewController



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [[Utility sharedManager] setScreenName:@"Employee List Screen"];
    
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    [self.navigationController setNavigationBarHidden:NO];
    
    // To Force the crash, Uncomment below line of code
    //[[Crashlytics sharedInstance] crash];
    
    // To Force the Exception, Uncomment below line of code
    //[[Crashlytics sharedInstance] throwException];
    
    // To Force the Array Out of Bound Exception, Uncomment below line of code
    //[[Utility sharedManager ] arrayOutOfBoundsException];
    
    
    self.navigationItem.hidesBackButton = YES;
    [self logUser];

}

-(void)logoutPressed
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) logUser {
    // TODO: Use the current user's information
    // You can call any combination of these three methods
    [CrashlyticsKit setUserName:@"Test User"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"Logout.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(logoutPressed)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 30, 30)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;

    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Employee" inManagedObjectContext:moc];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    
    NSError *error;
    self.employees = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView)
    {
        return [self.employees count];
    } else {
        return [self.filteredEmployees count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Employee *employee = nil;
    if (tableView == self.tableView)
    {
        employee = [self.employees objectAtIndex:indexPath.row];
    }
    else
    {
        employee = [self.filteredEmployees objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", employee.firstName, employee.lastName];
    cell.detailTextLabel.text = employee.title;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    Employee *employee = nil;
    if (self.searchDisplayController.isActive)
    {
        NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForCell:sender];
        employee = [self.filteredEmployees objectAtIndex:indexPath.row];
        
        [[Utility sharedManager] setActionName:@"Searched Selected EMP" label:employee.firstName];

    } else {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        employee = [self.employees objectAtIndex:indexPath.row];
        
        [[Utility sharedManager] setActionName:@"Selected EMP" label:employee.firstName];
    }

    DetailViewController *detailVC = [segue destinationViewController];
    detailVC.managedObjectContext = self.managedObjectContext;
    detailVC.employee = employee;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self searchForText:searchString];
    return YES;
}

- (bool)searchForText:(NSString *)searchText
{
    NSLog(@"Search for text %@", searchText);
    
    if (self.managedObjectContext)
    {
        NSString *predicateFormat = @"%K BEGINSWITH[cd] %@";
        NSString *searchAttribute = @"lastName";
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, searchAttribute, searchText];
        [self.searchFetchRequest setPredicate:predicate];
        
        NSError *error = nil;
        self.filteredEmployees = [self.managedObjectContext executeFetchRequest:self.searchFetchRequest error:&error];
        NSLog(@"search results: %lu", (unsigned long)[self.filteredEmployees count]);
    }
    if([self.filteredEmployees count]>0)
        return YES;
    else
        return NO;
}

- (NSFetchRequest *)searchFetchRequest
{
    if (_searchFetchRequest != nil)
    {
        return _searchFetchRequest;
    }
    
    _searchFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employee" inManagedObjectContext:self.managedObjectContext];
    [_searchFetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [_searchFetchRequest setSortDescriptors:sortDescriptors];
    
    return _searchFetchRequest;
}

@end
