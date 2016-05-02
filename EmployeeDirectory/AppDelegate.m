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

#import <Google/Analytics.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
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
    
    return YES;
}

@end
