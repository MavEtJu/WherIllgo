//
//  LocationViewControllerTableViewController.m
//  ios
//
//  Created by Edwin Groothuis on 22/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "LocationViewController.h"

#import "LocationDebugTableViewCell.h"
#import "LocationItemsTableViewCell.h"
#import "LocationHeaderTableViewCell.h"

#import "WIG.h"

@interface LocationViewController ()

@end

@implementation LocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:XIB_LOCATION_HEADER_TABLEVIEWCELL bundle:nil] forCellReuseIdentifier:XIB_LOCATION_HEADER_TABLEVIEWCELL];
    [self.tableView registerNib:[UINib nibWithNibName:XIB_LOCATION_DEBUG_TABLEVIEWCELL bundle:nil] forCellReuseIdentifier:XIB_LOCATION_DEBUG_TABLEVIEWCELL];
    [self.tableView registerNib:[UINib nibWithNibName:XIB_LOCATION_ITEMS_TABLEVIEWCELL bundle:nil] forCellReuseIdentifier:XIB_LOCATION_ITEMS_TABLEVIEWCELL];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *c = nil;

    switch (indexPath.row) {
        case 0: {
            LocationHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XIB_LOCATION_HEADER_TABLEVIEWCELL forIndexPath:indexPath];

            cell.labelName.text = self.location.name;
            cell.labelDescription.text = self.location.description_;

            if (self.location.media != nil) {
                WIGZMediaResource *resource = [self.location.media.resources firstObject];
                cell.ivMedia.image = [UIImage imageWithContentsOfFile:resource.filename];
            } else
                cell.ivMedia.image = nil;

            c = cell;
            break;
        }
        case 1: {
            LocationItemsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XIB_LOCATION_ITEMS_TABLEVIEWCELL forIndexPath:indexPath];

            c = cell;
            break;
        }
        case 2: {
            LocationDebugTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XIB_LOCATION_DEBUG_TABLEVIEWCELL forIndexPath:indexPath];

            c = cell;
            break;
        }
    }

    return c;
}

@end
