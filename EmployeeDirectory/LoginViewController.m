//
//  LoginViewController.m
//  ProductCatalogue
//
//  Created by Naveen on 4/19/16.
//  Copyright © 2016 NIIT. All rights reserved.
//

#import "LoginViewController.h"
#import "MasterViewController.h"
#import "Employee.h"
#import <Parse/Parse.h>
#import "Utility.h"
#import "Network.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    userNameField.text = @"";
    pwdField.text = @"";
    
    [userNameField becomeFirstResponder];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [[Utility sharedManager] setDeleg:self];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[Utility sharedManager] removeLoadingScreen];

}

-(void)showAlrt:(NSString*)msg
{
    [self showAlert:msg];
}

-(IBAction)signInPressed:(id)sender
{

    [userNameField resignFirstResponder];
    [pwdField resignFirstResponder];
    
    [[Utility sharedManager] showLoadingScreen];
    
    [self validateCredentials:userNameField.text password:pwdField.text];
    
}

-(void)validateCredentials:(NSString*)userName password:(NSString*)pwd
{
    if([userName length] > 0 && [pwd length] > 0)
    {
        if([[Network sharedManager] AuthenticateUser:userName password:pwd onLine:NO])
        {
            NSDictionary *data = [[Network sharedManager] getEmployeesData];
            [self setUpData:data];
            [self showNextScreen];
        }
        else
        {
            [self showAlert:@"Kindly enter Valid Credentials"];
        }
    }
    else
    {
        [self showAlert:nil];
    }

}

-(void)showAlert:(NSString*)msg
{
    [[Utility sharedManager] removeLoadingScreen];

    NSString *message = msg ? msg : @"Enter User Credentials";
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@""
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
    userNameField.text = @"";
    pwdField.text = @"";
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [userNameField resignFirstResponder];
    [pwdField resignFirstResponder];
}


-(void)showNextScreen
{
    [[Utility sharedManager] removeLoadingScreen];

    [self performSegueWithIdentifier:@"Employees" sender:self];
}

#pragma mark - Navigation

-(void)setUpData:(NSDictionary *)employeeData
{
    NSDictionary * employeeDict = [employeeData objectForKey:@"employees"];

    for (NSDictionary *emp in employeeDict )
    {
        Employee *employee = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:[[Utility sharedManager]managedObjectContext]];
        
        employee.id = [NSNumber numberWithInt:[[emp valueForKey:@"id"] intValue]];
        employee.firstName = emp[@"firstName"];
        employee.lastName = emp[@"lastName"];
        employee.title = emp[@"title"];
        employee.managerId = [NSNumber numberWithInt:[[emp valueForKey:@"managerId"] intValue]];
        employee.officePhone = emp[@"officePhone"];
        employee.cellPhone = emp[@"cellPhone"];
        employee.email = emp[@"email"];
        employee.picture = emp[@"picture"];
        NSError *error;
        if (![[[Utility sharedManager]managedObjectContext] save:&error]) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    
    }
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    MasterViewController *controller = (MasterViewController *)segue.destinationViewController;
    controller.managedObjectContext = [[Utility sharedManager]managedObjectContext];
    
}


@end
