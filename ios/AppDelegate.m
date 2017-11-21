//
//  AppDelegate.m
//  ios
//
//  Created by Edwin Groothuis on 21/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "AppDelegate.h"

#import "main.h"

#import "WIG.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    wig = [[WIG alloc] init];

    UITabBarController *tbc = [[UITabBarController alloc] init];

    locationsViewController = [[LocationsViewController alloc] init];
    locationsViewController.title = @"Locations";
    inventoryViewController = [[InventoryViewController alloc] init];
    inventoryViewController.title = @"Inventory";
    youSeeViewController = [[YouSeeViewController alloc] init];
    youSeeViewController.title = @"You See";
    tasksViewController = [[TasksViewController alloc] init];
    tasksViewController.title = @"Tasks";
    mapViewController = [[MapViewController alloc] init];
    mapViewController.title = @"Maps";

    NSArray *controllers = @[
        locationsViewController,
        tasksViewController,
        youSeeViewController,
        inventoryViewController,
        mapViewController
    ];

    [tbc setViewControllers:controllers animated:YES];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = tbc;
    [self.window makeKeyAndVisible];

    [wig run:@"testsuite.lua"];

    return YES;
}

@end
