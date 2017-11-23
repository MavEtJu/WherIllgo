//
//  main.h
//  luatest
//
//  Created by Edwin Groothuis on 21/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#ifndef main_h
#define main_h

#import "WIG.h"

#import "LocationsViewController.h"
#import "TasksViewController.h"
#import "MapViewController.h"
#import "InventoryViewController.h"
#import "YouSeesViewController.h"

#import "ZoneViewController.h"
#import "ZoneHeaderTableViewCell.h"
#import "ZoneDebugTableViewCell.h"
#import "ZoneItemsTableViewCell.h"

#import "ItemViewController.h"
#import "ItemHeaderTableViewCell.h"

#define XIB_UITABLEVIEWCELL @"UITableViewCell"

extern YouSeesViewController *youSeesViewController;
extern LocationsViewController *locationsViewController;
extern MapViewController *mapViewController;
extern InventoryViewController *inventoryViewController;
extern TasksViewController *tasksViewController;

#endif /* main_h */
