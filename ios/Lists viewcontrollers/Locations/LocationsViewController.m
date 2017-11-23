//
//  LocationsViewController.m
//  ios
//
//  Created by Edwin Groothuis on 21/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "main.h"

@interface LocationsViewController ()

@property (nonatomic, retain) NSArray<WIGZone *> *locations;

@end

@implementation LocationsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Locations";

    [self.tableView registerNib:[UINib nibWithNibName:XIB_LOCATIONSTABLEVIEWCELL bundle:nil] forCellReuseIdentifier:XIB_LOCATIONSTABLEVIEWCELL];
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
    LocationsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:XIB_LOCATIONSTABLEVIEWCELL forIndexPath:indexPath];

    WIGZone *location = [self.locations objectAtIndex:indexPath.row];
    cell.labelName.text = location.name;
    cell.labelDescription.text = location.description_;

    if (location.icon != nil) {
        WIGZMediaResource *resource = [location.icon.resources firstObject];
        cell.ivMediaIcon.image = [UIImage imageWithContentsOfFile:resource.filename];
    } else
        cell.ivMediaIcon.image = nil;

    NSMutableString *s = [NSMutableString stringWithString:@"Debug:\n"];
    [s appendFormat:@"Active: %d\n", location.active];
    [s appendFormat:@"Visible: %d\n", location.visible];
    cell.labelDebug.text = s;

    NSArray<WIGZItem *> *items = [wig arrayZItemsInZone:location];
    cell.labelItems.text = [NSString stringWithFormat:@"Items: %ld", (long)[items count]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    WIGZone *location = [self.locations objectAtIndex:indexPath.row];

    ZoneViewController *newController = [[ZoneViewController alloc] init];
    newController.title = @"Location";
    newController.zone = location;
    [self.navigationController pushViewController:newController animated:YES];

    [wig onClick:location.luaObject];
}

@end
