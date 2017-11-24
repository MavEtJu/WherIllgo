//
//  AppDelegate.m
//  ios
//
//  Created by Edwin Groothuis on 21/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "main.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    wig = [[WIG alloc] init];

    tbc = [[UITabBarController alloc] init];

    locationsViewController = [[LocationsViewController alloc] init];
    locationsViewController.title = @"LLL";
    UINavigationController *locationsNav = [[UINavigationController alloc] initWithRootViewController:locationsViewController];
//    locationsNav.navigationBarHidden = YES;

    inventoryViewController = [[InventoryViewController alloc] init];
    inventoryViewController.title = @"Inventory";
    UINavigationController *inventoryNav = [[UINavigationController alloc] initWithRootViewController:inventoryViewController];

    youSeesViewController = [[YouSeesViewController alloc] init];
    youSeesViewController.title = @"You See";
    UINavigationController *youSeeNav = [[UINavigationController alloc] initWithRootViewController:youSeesViewController];

    tasksViewController = [[TasksViewController alloc] init];
    tasksViewController.title = @"Tasks";
    UINavigationController *tasksNav = [[UINavigationController alloc] initWithRootViewController:tasksViewController];

    mapViewController = [[MapViewController alloc] init];
    mapViewController.title = @"Maps";
    UINavigationController *mapNav = [[UINavigationController alloc] initWithRootViewController:mapViewController];


    NSMutableArray *controllers = [NSMutableArray arrayWithCapacity:TABBAR_MAX];
    for (NSInteger i = 0; i < TABBAR_MAX; i++) {
        switch (i) {
            case TABBAR_INVENTORY:
                [controllers addObject:inventoryNav];
                break;
            case TABBAR_LOCATIONS:
                [controllers addObject:locationsNav];
                break;
            case TABBAR_TASKS:
                [controllers addObject:tasksNav];
                break;
            case TABBAR_YOUSEE:
                [controllers addObject:youSeeNav];
                break;
            case TABBAR_MAP:
                [controllers addObject:mapNav];
                break;
        }
    }
    [tbc setViewControllers:controllers animated:YES];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = tbc;
    [self.window makeKeyAndVisible];

    [wig runFile:@"testsuite.lua"];

    [wig updateLocation];

    return YES;
}

@end
