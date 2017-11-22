//
//  LocationsViewController.m
//  ios
//
//  Created by Edwin Groothuis on 21/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "LocationsViewController.h"

#import "WIG.h"
#import "LocationTableViewCell.h"

@interface LocationsViewController ()

@property (nonatomic, retain) NSArray<WIGZone *> *locations;

@end

@implementation LocationsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"A"];
    [self.tableView registerNib:[UINib nibWithNibName:XIB_LOCATIONTABLEVIEWCELL bundle:nil] forCellReuseIdentifier:XIB_LOCATIONTABLEVIEWCELL];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)reloadData
{
    self.locations = [wig arrayZones];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.locations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:XIB_LOCATIONTABLEVIEWCELL forIndexPath:indexPath];

    WIGZone *location = [self.locations objectAtIndex:indexPath.row];
    cell.labelName.text = location.name;
    cell.labelDescription.text = location.description_;

    if (location.media != nil) {
        WIGZMediaResource *resource = [location.media.resources firstObject];
        cell.ivMediaIcon.image = [UIImage imageWithContentsOfFile:resource.filename];
    }

    cell.labelDebugActive.text = [NSString stringWithFormat:@"Active: %d", location.active];
    cell.labelDebugVisible.text = [NSString stringWithFormat:@"Visible: %d", location.visible];
    cell.labelDebugShowObjects.text = [NSString stringWithFormat:@"Show Objects: %@", location.showObjects];
    cell.labelDebugState.text = [NSString stringWithFormat:@"State: %@", location.state];

    return cell;
}

@end
