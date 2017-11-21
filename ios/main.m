//
//  main.m
//  ios
//
//  Created by Edwin Groothuis on 21/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#import "main.h"

YouSeeViewController *youSeeViewController;
LocationsViewController *locationsViewController;
MapViewController *mapViewController;
InventoryViewController *inventoryViewController;
TasksViewController *tasksViewController;


int main(int argc, char * argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
