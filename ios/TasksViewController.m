//
//  TasksViewController.m
//  ios
//
//  Created by Edwin Groothuis on 21/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "TasksViewController.h"
#import "WIG.h"

@interface TasksViewController ()

@property (nonatomic, retain) NSArray<NSDictionary *> *tasks;

@end

@implementation TasksViewController

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
    self.tasks = [wig arrayZTasks];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"A" forIndexPath:indexPath];

    NSDictionary *task = [self.tasks objectAtIndex:indexPath.row];
    cell.textLabel.text = [task objectForKey:@"Name"];
    cell.detailTextLabel.text = [task objectForKey:@"Description"];

    return cell;
}

@end
