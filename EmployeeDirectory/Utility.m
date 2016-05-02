//
//  Utility.m
//  EmployeeDirectory
//
//  Created by Naveen on 4/21/16.
//  Copyright © 2016 Christophe Coenraets. All rights reserved.
//

#import "Utility.h"
#import <Google/Analytics.h>

@implementation Utility
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (id)sharedManager {
    static Utility *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(BOOL)copyDatabaseIntoDocumentsDirectory:(NSString *)dbFilename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.documentsDirectory = [paths objectAtIndex:0];
    
    // Keep the database filename.
    self.databaseFilename = dbFilename;

    // Check if the database file exists in the documents directory.
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    BOOL copied = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        // The database file does not exist in the documents directory, so copy it from the main bundle now.
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
        NSError *error;
        copied = [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        
        // Check if any error occurred during copying and display it.
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
    return copied;
}


-(BOOL)openDatabase
{
    BOOL opened = NO;
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    if (sqlite3_open([destinationPath UTF8String], &sqlite3Database) == SQLITE_OK)
    {
        opened = YES;
    }
    else
    {
        opened = NO;
        sqlite3_close(sqlite3Database);
    }
    return opened;
}

-(BOOL)checkUser:(NSString*)userName password:(NSString*)password
{
    BOOL loginSuccess= NO;
    
    NSString *query = [NSString stringWithFormat:@"select * from Users WHERE UserName=\"%@\" AND Password=\"%@\"", userName, password];
    sqlite3_stmt *compiledStatement;
    int prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, [query UTF8String], -1, &compiledStatement, NULL);
    
    if(prepareStatementResult == SQLITE_OK)
    {
        while (sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            loginSuccess = YES;
        }
    }
    else
    {
        loginSuccess = NO;
        NSLog(@"Username, Password is Not valid");
        
    }
    return loginSuccess;
}


-(void)setDeleg:(id)deleg
{
    idDeleg = deleg;
}

-(void)showLoadingScreen
{
    self.vw = [[UIView alloc] initWithFrame:CGRectMake([Utility screenSize].size.width/2-50, [Utility screenSize].size.height/2-100, 100, 100)];
    self.vw.backgroundColor = [UIColor lightGrayColor];
    self.vw.layer.cornerRadius = 16.0f;
    self.vw.layer.borderWidth = 5.0f;
    self.vw.layer.borderColor = [UIColor blackColor].CGColor;
    
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicator setFrame:CGRectMake(self.vw.frame.size.width/2-18.5 , self.vw.frame.size.height/2-18.5, indicator.frame.size.width , indicator.frame.size.height)];
    [indicator startAnimating];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.vw.frame.size.width/2-30 , self.vw.frame.size.height/2+20, 100 , 20)];
    [lbl setTextColor:[UIColor blackColor]];
    [lbl setText:@"Loading..."];
    
    [self.vw addSubview:indicator];
    [self.vw addSubview:lbl];
    
    UINavigationController *nvc = (UINavigationController*)[[UIApplication sharedApplication] keyWindow].rootViewController;
    [nvc.topViewController.view addSubview:self.vw];
}

+(CGRect)screenSize
{
    return [[UIScreen mainScreen]bounds];
}


-(void)removeLoadingScreen
{
    [self.vw removeFromSuperview];
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"EmployeeDirectory" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"EmployeeDirectory.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void)setScreenName:(NSString*)screenName
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:screenName];
}

-(void)setActionName:(NSString*)action label:(NSString*)lbl
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:action
                                                           label:lbl
                                                           value:nil] build]];
}



@end
