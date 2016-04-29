//
//  Network.m
//  EmployeeDirectory
//
//  Created by Naveen on 4/28/16.
//  Copyright © 2016 Christophe Coenraets. All rights reserved.
//

#import "Network.h"

@implementation Network


+ (id)sharedManager {
    static Network *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


// For Local Validation
-(BOOL)validateOffline:(NSString*)userName password:(NSString*)password
{
    [[Utility sharedManager] copyDatabaseIntoDocumentsDirectory:@"UserDetails.db"];
    [[Utility sharedManager] openDatabase];
    return [[Utility sharedManager] checkUser:userName password:password];

}

-(BOOL)validateOnline:(NSString*)userName password:(NSString*)pwd
{
    __block BOOL loginSuccess = NO;;
    // Network Data
    //Validate the UserName and Password field
    if(([userName length] > 0) && ([pwd length] > 0))
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Username =%@", userName];
        __block BOOL waitingForBlock = YES;

        PFQuery *query = [PFQuery queryWithClassName:@"Users" predicate:predicate];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (!error) {
                // The find succeeded.
                NSString *s = nil;
                if([objects count] >=1)
                {
                    PFObject *pwdobj=[objects objectAtIndex:0];
                    s =(NSString*)[pwdobj objectForKey:@"Password"];
                }
                if([s isEqualToString:pwd])
                {
                    waitingForBlock = NO;

                    obj=[objects objectAtIndex:0];
                    loginSuccess = YES;
                    [idDeleg showNextScreen];
                }
                else{
                    waitingForBlock = NO;

                    loginSuccess = NO;
                    [idDeleg showAlrt:@"Enter Valid Credential"];
                }
                
            } else {
                waitingForBlock = NO;
                // Log details of the failure
                loginSuccess = NO;
                [idDeleg showAlrt:@"Enter Valid Credential"];
                
            }
        }];
        
        while(waitingForBlock) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                     beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        }
    }
    else
    {
        loginSuccess = NO;
        [idDeleg showAlrt:nil];
    }
    
    return loginSuccess;
}


-(BOOL)AuthenticateUser:(NSString*)userName password:(NSString*)pwd onLine:(BOOL)online
{
    BOOL authenticated;
    // Local Data
    if(online)
    {
        authenticated = [self validateOnline:userName password:pwd];
    }
    else
    {
        authenticated = [self validateOffline:userName password:pwd];
    }
    
    return authenticated;
}

-(NSDictionary*)getEmployeesData
{
    NSDictionary *jsonObject;
    
    // When online obj is filled with Parse Object details of Employees
    
    if(obj)
    {
        PFFile *file1 = [obj objectForKey:@"EmployeesJson"];
        
        [file1 saveInBackground];
        
        NSData *data = [file1 getData];
        jsonObject =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
    }
    // When offline then data is retrieved from Local JSON File
    else
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Employees" ofType:@"json"];
        NSData *data = [[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
        jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];

    }
    return jsonObject;
}

@end
