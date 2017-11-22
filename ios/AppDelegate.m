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
    locationsViewController.title = @"LLL";
    UINavigationController *locationsNav = [[UINavigationController alloc] initWithRootViewController:locationsViewController];
//    locationsNav.navigationBarHidden = YES;

    inventoryViewController = [[InventoryViewController alloc] init];
    inventoryViewController.title = @"Inventory";
    UINavigationController *inventoryNav = [[UINavigationController alloc] initWithRootViewController:inventoryViewController];

    youSeeViewController = [[YouSeeViewController alloc] init];
    youSeeViewController.title = @"You See";
    UINavigationController *youSeeNav = [[UINavigationController alloc] initWithRootViewController:youSeeViewController];

    tasksViewController = [[TasksViewController alloc] init];
    tasksViewController.title = @"Tasks";
    UINavigationController *tasksNav = [[UINavigationController alloc] initWithRootViewController:tasksViewController];

    mapViewController = [[MapViewController alloc] init];
    mapViewController.title = @"Maps";
    UINavigationController *mapNav = [[UINavigationController alloc] initWithRootViewController:mapViewController];


    NSArray *controllers = @[
//        locationsViewController,
        locationsNav,
        inventoryNav,
        youSeeNav,
        tasksNav,
        mapNav
    ];
    [tbc setViewControllers:controllers animated:YES];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = tbc;
    [self.window makeKeyAndVisible];

    [wig run:@"testsuite.lua"];

    return YES;
}

@end
