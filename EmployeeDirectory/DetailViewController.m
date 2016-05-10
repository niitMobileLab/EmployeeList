//
//  DetailViewController.m
//  EmployeeDirectory
//
//  Created by Christophe Coenraets on 11/12/13.
//  Copyright (c) 2013 Christophe Coenraets. All rights reserved.
//

#import "DetailViewController.h"
#import "Employee.h"
#import "ReportsViewController.h"
#import <Google/Analytics.h>
#import "Utility.h"

@interface DetailViewController ()

@property (strong, nonatomic) Employee *manager;
@property (strong, nonatomic) NSArray *reports;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)configureView
{
    // Update the user interface for the detail item.
    
    self.actionList.dataSource = self;
    self.actionList.delegate = self;
    
    if (self.employee) {
        
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Employee" inManagedObjectContext:self.managedObjectContext];
        
        // Find the direct reports
        NSFetchRequest *reportsRequest = [[NSFetchRequest alloc] init];
        [reportsRequest setEntity:entityDescription];
        
        NSPredicate *reportsPredicate = [NSPredicate predicateWithFormat:@"managerId == %@", self.employee.id];
        [reportsRequest setPredicate:reportsPredicate];
        
        NSError *error;
        self.reports = [self.managedObjectContext executeFetchRequest:reportsRequest error:&error];
        
        // Find the manager
        if ([self.employee.managerId intValue] > 0) {
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:entityDescription];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self == %@", self.employee.managerId];
            [request setPredicate:predicate];
            
            NSError *error;
            NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
            if (array != nil) {
                self.manager = [array objectAtIndex:0];
            }
        }
        
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.employee.firstName, self.employee.lastName];
        self.titleLabel.text = self.employee.title;
        [self.employeePic setImage:[UIImage imageNamed:self.employee.picture]];
        [self setUpActionsData];
    }
}

-(void)setUpActionsData
{    
    
    self.actions = [[NSMutableArray alloc] init];
    
    NSDictionary *callOffice = [NSDictionary dictionaryWithObjectsAndKeys:@"Call Office", @"label", self.employee.officePhone, @"data", @"call", @"command", nil];
    [self.actions addObject:callOffice];
    
    NSDictionary *callCell = [NSDictionary dictionaryWithObjectsAndKeys:@"Call Cell", @"label", self.employee.cellPhone, @"data", @"call", @"command", nil];
    [self.actions addObject:callCell];
    
    NSDictionary *email = [NSDictionary dictionaryWithObjectsAndKeys:@"Email", @"label", self.employee.email, @"data", @"email", @"command", nil];
    [self.actions addObject:email];
    
    
    if ([self.employee.managerId intValue] > 0) {
        NSDictionary *mgr = [NSDictionary dictionaryWithObjectsAndKeys:@"View Manager", @"label", [NSString stringWithFormat:@"%@ %@", self.manager.firstName, self.manager.lastName], @"data", @"mgr", @"command", nil];
        [self.actions addObject:mgr];
    }
    
    if ([self.reports count] > 0) {
        NSDictionary *reportsAction = [NSDictionary dictionaryWithObjectsAndKeys:@"View Reports", @"label", [NSString stringWithFormat:@"%lu", (unsigned long)[self.reports count]], @"data", @"reports", @"command", nil];
        [self.actions addObject:reportsAction];
    }
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

    
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

-(void)logoutPressed
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.actions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    NSString *action = [self.actions objectAtIndex:[indexPath row]];
    cell.textLabel.text = [action valueForKey:@"label"];
    cell.detailTextLabel.text = [action valueForKey:@"data"];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *action = [self.actions objectAtIndex:[indexPath row]];
    
    NSString *command = [action valueForKey:@"command"];
    NSString *data = [action valueForKey:@"data"];

    if ([command isEqualToString:@"call"]) {
        [[Utility sharedManager] setActionName:command label:data];

        NSString *phoneStr = [[NSString alloc] initWithFormat:@"tel:%@",data];
        NSURL *phoneURL = [[NSURL alloc] initWithString:phoneStr];
        [[UIApplication sharedApplication] openURL:phoneURL];
    } else if ([command isEqualToString:@"email"]) {
        [[Utility sharedManager] setActionName:command label:data];

        NSString *mailString = [NSString stringWithFormat:@"mailto:?to=%@",
                                [data stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailString]];
    } else if ([command isEqualToString:@"mgr"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        DetailViewController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"EmployeeVC"];
        detailVC.managedObjectContext = self.managedObjectContext;
        detailVC.employee = self.manager;
        [self.navigationController pushViewController:detailVC animated:YES];
    } else if ([command isEqualToString:@"reports"]) {
        [[Utility sharedManager] setActionName:command label:self.nameLabel.text];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        ReportsViewController *reportsVC = [storyboard instantiateViewControllerWithIdentifier:@"ReportsVC"];
        reportsVC.managedObjectContext = self.managedObjectContext;
        reportsVC.reports = self.reports;
        [self.navigationController pushViewController:reportsVC animated:YES];
    }
}

@end
