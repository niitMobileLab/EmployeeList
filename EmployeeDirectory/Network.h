//
//  Network.h
//  EmployeeDirectory
//
//  Created by Naveen on 4/28/16.
//  Copyright © 2016 Christophe Coenraets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyProtocol.h"
#import "sqlite3.h"
#import <Parse/Parse.h>
#import "Utility.h"


@interface Network : NSObject
{
    id<MyProtocol> idDeleg;
    PFObject *obj;
    sqlite3 *sqlite3Database;

}

+ (id)sharedManager;
-(BOOL)AuthenticateUser:(NSString*)userName password:(NSString*)pwd onLine:(BOOL)online;
-(NSDictionary*)getEmployeesData;

@end
