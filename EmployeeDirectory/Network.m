//
//  Network.m
//  EmployeeDirectory
//
//  Created by Naveen on 4/28/16.
//  Copyright © 2016 Christophe Coenraets. All rights reserved.
//

#import "Network.h"

@implementation Network


// Singelton object to Access Network Object
+ (id)sharedManager {
    static Network *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    
    int num1 = 3;
    int num2 = 4;
    int num3 = 1;
    int num4 = 5;
    
    if(num1==3)
    {
        if(num2>num3)
        {
            if(num1>num3)
            {
                if(num3>num4)
                {
                    if(num4>num1)
                    {
                        num4 = num1;
                    }else {
                        num2 = num4;
                    }
                    
                }else {
                    num2= num3;
                }
            }else {
                num1 = num2;
            }
        }
        else
        {
            num2 = num3;
        }
        
    }
    
    int num44 = 3;
    int num5 = 4;
    int num6 = 1;
    
    
    if(num44==3)
    {
        if(num5>num6)
        {
            num44 = num5;
        }
        else
        {
            num5 = num6;
        }
    }
    

    
    return sharedMyManager;
}




// Get Employees Data like their First Name, Last Name , Phone number etc from the local file or Back4app cloud
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
