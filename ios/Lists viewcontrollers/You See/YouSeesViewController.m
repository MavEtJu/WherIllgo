//
//  YouSeeViewController.m
//  ios
//
//  Created by Edwin Groothuis on 21/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "YouSeesViewController.h"
#import "YouSeesTableViewCell.h"
#import "ItemViewController.h"

#import "WIG.h"

@interface YouSeesViewController ()

@property (nonatomic, retain) NSArray<WIGZItem *> *items;

@end

@implementation YouSeesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:XIB_YOUSEES_TABLEVIEWCELL bundle:nil] forCellReuseIdentifier:XIB_YOUSEES_TABLEVIEWCELL];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)reloadData
{
    self.items = [wig arrayZItemsInZone:nil];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    WIGZItem *item = [self.items objectAtIndex:indexPath.row];

    ItemViewController *newController = [[ItemViewController alloc] init];
    newController.title = @"Item";
    newController.item = item;
    [self.navigationController pushViewController:newController animated:YES];

    [wig onClick:item.luaObject];
}


@end
