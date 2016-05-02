//
//  Utility.h
//  EmployeeDirectory
//
//  Created by Naveen on 4/21/16.
//  Copyright © 2016 Christophe Coenraets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyProtocol.h"
#import <Parse/Parse.h>
#import "sqlite3.h"

@interface Utility : NSObject
{
    id<MyProtocol> idDeleg;
    sqlite3 *sqlite3Database;
}

@property (nonatomic, strong)  UIView *vw;
@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (id)sharedManager;

-(void)showLoadingScreen;
-(void)removeLoadingScreen;
-(void)setDeleg:(id)deleg;

-(BOOL)copyDatabaseIntoDocumentsDirectory:(NSString *)dbFilename;
-(BOOL)openDatabase;
-(BOOL)checkUser:(NSString*)userName password:(NSString*)password;


// For Google Analytics
-(void)setScreenName:(NSString*)screenName;
-(void)setActionName:(NSString*)action label:(NSString*)lbl;


// For CoreData Objects
- (NSURL *)applicationDocumentsDirectory;


-(NSString*)arrayOutOfBoundsException;

@end
