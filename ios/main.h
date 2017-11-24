//
//  main.h
//  luatest
//
//  Created by Edwin Groothuis on 21/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#ifndef main_h
#define main_h

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>

#import "WIG.h"

#import "MapViewController.h"
#import "InventoryViewController.h"

#import "LocationsViewController.h"
#import "LocationsTableViewCell.h"

#import "ZoneViewController.h"
#import "ZoneHeaderTableViewCell.h"
#import "ZoneDebugTableViewCell.h"
#import "ZoneItemsTableViewCell.h"

#import "YouSeesViewController.h"
#import "YouSeesTableViewCell.h"

#import "TasksViewController.h"
#import "TasksTableViewCell.h"
#import "TaskViewController.h"

#import "ItemViewController.h"
#import "ItemHeaderTableViewCell.h"

#import "AppDelegate.h"

#define XIB_UITABLEVIEWCELL @"UITableViewCell"

extern YouSeesViewController *youSeesViewController;
extern LocationsViewController *locationsViewController;
extern MapViewController *mapViewController;
extern InventoryViewController *inventoryViewController;
extern TasksViewController *tasksViewController;

#endif /* main_h */
