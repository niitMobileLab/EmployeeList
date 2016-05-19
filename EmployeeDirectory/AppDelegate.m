//
//  AppDelegate.m
//  EmployeeDirectory
//
//  Created by Christophe Coenraets on 11/12/13.
//  Copyright (c) 2013 Christophe Coenraets. All rights reserved.
//

#import "AppDelegate.h"
#import <Crashlytics/Crashlytics.h>
#import <Parse/Parse.h>
#import <Fabric/Fabric.h>
#import "Employee.h"
#import "Utility.h"
#import "Network.h"
#import <Google/Analytics.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
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
    
    [Fabric with:@[[Crashlytics class]]];

    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-76736239-1"];

    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
    gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release
    
    [[GAI sharedInstance]setDefaultTracker:tracker];
    // Override point for customization after application launch.
    
    
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"5xAlRD8Kncdk4WLRBpPTf36apxLTlwSAkl3oDMwl";
        configuration.clientKey = @"ST9BHPtnBtNgAv5vw2OChxgGQvNX728tLOnuIIPm";
        configuration.server = @"https://parseapi.back4app.com";
    }]];
    
    //Setup data
    
    NSDictionary *data = [[Network sharedManager] getEmployeesData];
    [self setUpData:data];

    return YES;
}

-(void)setUpData:(NSDictionary *)employeeData
{
    if(![self HasEmployeeData])
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
                NSLog(@"Save Error: %@", [error localizedDescription]);
            }
            
        }
    }
}






-(BOOL)HasEmployeeData
{
    NSManagedObjectContext *moc = [[Utility sharedManager]managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Employee" inManagedObjectContext:moc];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    
    NSError *error;
    NSArray *employees = [moc executeFetchRequest:fetchRequest error:&error];
    return [employees count] >0 ? YES: NO;
    
}


@end
