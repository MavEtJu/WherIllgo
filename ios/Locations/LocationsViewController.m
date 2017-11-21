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

@property (nonatomic, retain) NSArray<NSDictionary *> *locations;

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

    NSDictionary *location = [self.locations objectAtIndex:indexPath.row];
    cell.labelName.text = [location objectForKey:@"Name"];
    cell.labelDescription.text = [location objectForKey:@"Description"];

    NSDictionary *media = [location objectForKey:@"Media"];
    if ([media isKindOfClass:[NSDictionary class]] == YES) {
        NSArray *resources = [media objectForKey:@"Resources"];
        NSDictionary *resource = [resources firstObject];
        cell.ivMediaIcon.image = [UIImage imageWithContentsOfFile:[resource objectForKey:@"Filename"]];
    }

    cell.labelDebugActive.text = [NSString stringWithFormat:@"Active: %@", [location objectForKey:@"_active"]];
    cell.labelDebugVisible.text = [NSString stringWithFormat:@"Visible: %@", [location objectForKey:@"Visible"]];
    cell.labelDebugShowObjects.text = [NSString stringWithFormat:@"Show objects: %@", [location objectForKey:@"ShowObjects"]];
    cell.labelDebugState.text = [NSString stringWithFormat:@"State: %@", [location objectForKey:@"State"]];

    return cell;
}

@end
