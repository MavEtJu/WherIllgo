//
//  YouSeeViewController.m
//  ios
//
//  Created by Edwin Groothuis on 21/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "main.h"

@interface YouSeesViewController ()

@property (nonatomic, retain) NSArray<WIGZItem *> *items;
@property (nonatomic, retain) NSArray<WIGZCharacter *> *characters;
@property (nonatomic, retain) NSArray<WIGZone *> *zones;

@end

@implementation YouSeesViewController

enum {
    SECTION_ITEMS,
    SECTION_CHARACTERS,
    SECTION_ZONES,
    SECTION_MAX,
};

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:XIB_YOUSEES_TABLEVIEWCELL bundle:nil] forCellReuseIdentifier:XIB_YOUSEES_TABLEVIEWCELL];
    [self.tableView registerClass:[UIDefaultTableViewCell class] forCellReuseIdentifier:XIB_UIDEFAULTTABLEVIEWCELL];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)reloadData
{
    self.items = [wig arrayZItemsInZone:nil];
    self.characters = [wig arrayZCharactersInZone:nil];
    self.zones = [wig arrayZonesInZone:nil];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return SECTION_MAX;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case SECTION_ITEMS:
            return [self.items count];
        case SECTION_CHARACTERS:
            return [self.characters count];
        case SECTION_ZONES:
            return [self.zones count];
    }

    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case SECTION_ITEMS:
            return @"Items";
        case SECTION_CHARACTERS:
            return @"Characters";
        case SECTION_ZONES:
            return @"Zones";
    }

    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case SECTION_ITEMS: {
            YouSeesTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:XIB_YOUSEES_TABLEVIEWCELL forIndexPath:indexPath];

            WIGZItem *item = [self.items objectAtIndex:indexPath.row];
            cell.labelName.text = item.name;
            cell.labelDescription.text = item.description_;

            if (item.icon != nil) {
                WIGZMediaResource *resource = [item.icon.resources firstObject];
                cell.ivIcon.image = [UIImage imageWithContentsOfFile:resource.filename];
            } else
                cell.ivIcon.image = nil;

            cell.labelDebugActive.text = [NSString stringWithFormat:@"Zone: %@", item.container.name];
            cell.labelDebugVisible.text = [NSString stringWithFormat:@"Visible: %d", item.visible];

            return cell;
        }

        case SECTION_CHARACTERS: {
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:XIB_UIDEFAULTTABLEVIEWCELL forIndexPath:indexPath];

            WIGZCharacter *character = [self.characters objectAtIndex:indexPath.row];
            cell.textLabel.text = character.name;
//            cell.labelName.text = item.name;

//            if (item.icon != nil) {
//                WIGZMediaResource *resource = [item.icon.resources firstObject];
//                cell.ivIcon.image = [UIImage imageWithContentsOfFile:resource.filename];
//            } else
//                cell.ivIcon.image = nil;

//            cell.labelDebugActive.text = [NSString stringWithFormat:@"Zone: %@", item.container.name];
//            cell.labelDebugVisible.text = [NSString stringWithFormat:@"Visible: %d", item.visible];

            return cell;
        }

        case SECTION_ZONES: {
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:XIB_UIDEFAULTTABLEVIEWCELL forIndexPath:indexPath];

            WIGZone *zone = [self.zones objectAtIndex:indexPath.row];
            cell.textLabel.text = zone.name;
            //            cell.labelName.text = item.name;

            //            if (item.icon != nil) {
            //                WIGZMediaResource *resource = [item.icon.resources firstObject];
            //                cell.ivIcon.image = [UIImage imageWithContentsOfFile:resource.filename];
            //            } else
            //                cell.ivIcon.image = nil;

            //            cell.labelDebugActive.text = [NSString stringWithFormat:@"Zone: %@", item.container.name];
            //            cell.labelDebugVisible.text = [NSString stringWithFormat:@"Visible: %d", item.visible];

            return cell;
        }
    }

    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case SECTION_ITEMS: {
            WIGZItem *item = [self.items objectAtIndex:indexPath.row];

            ItemViewController *newController = [[ItemViewController alloc] init];
            newController.title = @"Item";
            newController.item = item;
            [self.navigationController pushViewController:newController animated:YES];

            [wig WIGOnClick:item.luaObject];
            break;
        }
        case SECTION_CHARACTERS: {
            WIGZCharacter *character = [self.characters objectAtIndex:indexPath.row];

            CharacterViewController *newController = [[CharacterViewController alloc] init];
            newController.title = @"Character";
            newController.character = character;
            [self.navigationController pushViewController:newController animated:YES];

            [wig WIGOnClick:character.luaObject];
            break;
        }
        case SECTION_ZONES: {
            WIGZone *zone = [self.zones objectAtIndex:indexPath.row];

            ZoneViewController *newController = [[ZoneViewController alloc] init];
            newController.title = @"Zone";
            newController.zone = zone;
            [self.navigationController pushViewController:newController animated:YES];

            [wig WIGOnClick:zone.luaObject];
            break;
        }
    }
}


@end
