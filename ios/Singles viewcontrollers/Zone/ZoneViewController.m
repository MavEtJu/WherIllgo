//
//  LocationViewControllerTableViewController.m
//  ios
//
//  Created by Edwin Groothuis on 22/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "ZoneViewController.h"

#import "ZoneDebugTableViewCell.h"
#import "ZoneItemsTableViewCell.h"
#import "ZoneHeaderTableViewCell.h"

#import "main.h"

@interface ZoneViewController ()

@property (nonatomic, retain) NSArray<WIGZItem *> *items;
@property (nonatomic, retain) NSArray<WIGZone *> *zones;
@property (nonatomic, retain) NSArray<WIGZCharacter *> *characters;

@end

@implementation ZoneViewController

enum {
    SECTION_HEADER = 0,
    SECTION_ITEMS,
    SECTION_CHARACTERS,
    SECTION_ZONES,
    SECTION_DEBUG,
    SECTION_MAX,

    SECTION_HEADER_NAME = 0,
    SECTION_HEADER_IMAGE,
    SECTION_HEADER_DESCRIPTION,
    SECTION_HEADER_MAX,
};

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:XIB_UITABLEVIEWCELL];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.items = [wig arrayZItemsInZone:self.zone];
    self.zones = [wig arrayZonesInZone:self.zone];
    self.characters = [wig arrayCharactersInZone:self.zone];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return SECTION_MAX;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case SECTION_HEADER:
            return SECTION_HEADER_MAX;
        case SECTION_ITEMS:
            return [self.items count];
        case SECTION_ZONES:
            return [self.zones count];
        case SECTION_CHARACTERS:
            return [self.characters count];
        case SECTION_DEBUG:
            return 1;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case SECTION_HEADER:
            return @"Header";
        case SECTION_ITEMS:
            return @"Items";
        case SECTION_ZONES:
            return @"Zones";
        case SECTION_CHARACTERS:
            return @"Characters";
        case SECTION_DEBUG:
            return @"Debug";
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *c = nil;

    switch (indexPath.section) {
        case SECTION_HEADER: {
            switch (indexPath.row) {
                case SECTION_HEADER_NAME: {
                    c = [self.tableView dequeueReusableCellWithIdentifier:XIB_UITABLEVIEWCELL];
                    c.textLabel.text = self.zone.name;
                    break;
                }
                case SECTION_HEADER_IMAGE: {
                    c = [self.tableView dequeueReusableCellWithIdentifier:XIB_UITABLEVIEWCELL];

//                    if (self.zone.media != nil) {
//                        WIGZMediaResource *resource = [self.zone.media.resources firstObject];
//                        cell.ivMedia.image = [UIImage imageWithContentsOfFile:resource.filename];
//                    } else
//                        cell.ivMedia.image = nil;
                    c.textLabel.text = self.zone.media.altText;
                    break;
                }
                case SECTION_HEADER_DESCRIPTION: {
                    c = [self.tableView dequeueReusableCellWithIdentifier:XIB_UITABLEVIEWCELL];
                    c.textLabel.text = self.zone.description_;
                    c.textLabel.font = [UIFont systemFontOfSize:12];
                    c.textLabel.numberOfLines = 0;
                    break;
                }
            }
            break;
        }

        case SECTION_ITEMS: {
            WIGZItem *item = [self.items objectAtIndex:indexPath.row];
            c = [self.tableView dequeueReusableCellWithIdentifier:XIB_UITABLEVIEWCELL];
            c.textLabel.text = item.name;
            break;
        }

        case SECTION_ZONES: {
            WIGZone *zone = [self.zones objectAtIndex:indexPath.row];
            c = [self.tableView dequeueReusableCellWithIdentifier:XIB_UITABLEVIEWCELL];
            c.textLabel.text = zone.name;
            break;
        }

        case SECTION_CHARACTERS: {
            WIGZCharacter *character = [self.characters objectAtIndex:indexPath.row];
            c = [self.tableView dequeueReusableCellWithIdentifier:XIB_UITABLEVIEWCELL];
            c.textLabel.text = character.name;
            break;
        }

        case SECTION_DEBUG: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XIB_UITABLEVIEWCELL forIndexPath:indexPath];

            cell.textLabel.text = @"Debug";
            cell.detailTextLabel.numberOfLines = 0;

            NSMutableString *s = [NSMutableString stringWithString:@""];
            [s appendFormat:@"Active: %d\n", self.zone.active];
            [s appendFormat:@"Visible: %d\n", self.zone.visible];
            [s appendFormat:@"State: %@\n", self.zone.state];
            [s appendFormat:@"ShowObjects: %@\n", self.zone.showObjects];
            cell.detailTextLabel.text = s;
            c = cell;
            break;
        }
    }

    return c;
}

@end
