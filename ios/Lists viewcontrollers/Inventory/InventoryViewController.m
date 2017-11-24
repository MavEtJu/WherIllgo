//
//  InventoryViewController.m
//  ios
//
//  Created by Edwin Groothuis on 21/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "main.h"

@interface InventoryViewController ()

@property (nonatomic, retain) NSArray<WIGZItem *> *items;

@end

@implementation InventoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"A"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)reloadData
{
    self.items = [wig arrayZItemsInInventory];
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
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"A" forIndexPath:indexPath];

    WIGZItem *item = [self.items objectAtIndex:indexPath.row];
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = item.description_;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    WIGZItem *item = [self.items objectAtIndex:indexPath.row];

    ItemViewController *newController = [[ItemViewController alloc] init];
    newController.title = @"Item";
    newController.item = item;
    [self.navigationController pushViewController:newController animated:YES];

    [wig WIGOnClick:item.luaObject];
}

@end
