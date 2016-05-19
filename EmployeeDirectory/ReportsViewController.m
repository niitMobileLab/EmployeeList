//
//  ReportsViewController.m
//  EmployeeDirectory
//
//  Created by Christophe Coenraets on 11/17/13.
//  Copyright (c) 2013 Christophe Coenraets. All rights reserved.
//

#import "ReportsViewController.h"
#import "Employee.h"
#import "DetailViewController.h"

@interface ReportsViewController ()

@end

@implementation ReportsViewController


- (void)viewDidLoad
{
   

    
    [super viewDidLoad];

    int a = 10;
    do
    {
        NSLog(@"value of a: %d\n", a);
        a = a + 1;
    }while( a < 20 );
    
    char grade = 'B';
    
    switch(grade)
    {
        case 'A' :
            NSLog(@"Excellent!\n" );
            break;
        case 'B' :
        case 'C' :
            NSLog(@"Well done\n" );
            break;
        case 'D' :
            NSLog(@"You passed\n" );
            break;
        case 'F' :
            NSLog(@"Better try again\n" );
            break;
        default :
            NSLog(@"Invalid grade\n" );
    }
    NSLog(@"Your grade is  %c\n", grade );
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"Reports";
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"Logout.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(logoutPressed)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 30, 30)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
    
    
    
    /* do loop execution */
    
}

-(void)logoutPressed
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.reports count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    Employee *employee = [self.reports objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", employee.firstName, employee.lastName];
    cell.detailTextLabel.text = employee.title;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Employee *employee = [self.reports objectAtIndex:indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    DetailViewController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"EmployeeVC"];
    detailVC.managedObjectContext = self.managedObjectContext;
    detailVC.employee = employee;
    [self.navigationController pushViewController:detailVC animated:YES];
}



@end
