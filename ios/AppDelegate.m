//
//  AppDelegate.m
//  ios
//
//  Created by Edwin Groothuis on 21/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "AppDelegate.h"

#import "LocationsViewController.h"
#import "InventoryViewController.h"
#import "YouSeeViewController.h"
#import "TasksViewController.h"
#import "MapViewController.h"

#import "WIG.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UITabBarController *tbc = [[UITabBarController alloc] init];

    UIViewController *locs = [[LocationsViewController alloc] init];
    locs.title = @"Locations";
    UIViewController *inv = [[InventoryViewController alloc] init];
    inv.title = @"Inventory";
    UIViewController *yousee = [[YouSeeViewController alloc] init];
    yousee.title = @"You See";
    UIViewController *tasks = [[TasksViewController alloc] init];
    tasks.title = @"Tasks";
    UIViewController *map = [[MapViewController alloc] init];
    map.title = @"Maps";

    NSArray *controllers = @[locs, yousee, inv, tasks, map];

    [tbc setViewControllers:controllers animated:YES];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = tbc;
    [self.window makeKeyAndVisible];

    wig = [[WIG alloc] init];
    [wig run:@"testsuite.lua"];

    return YES;
}

@end
