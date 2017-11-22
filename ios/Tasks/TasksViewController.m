//
//  TasksViewController.m
//  ios
//
//  Created by Edwin Groothuis on 21/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "TasksViewController.h"
#import "TaskTableViewCell.h"
#import "WIG.h"

@interface TasksViewController ()

@property (nonatomic, retain) NSArray<WIGZTask *> *tasks;

@end

@implementation TasksViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:XIB_TASKTABLEVIEWCELL bundle:nil] forCellReuseIdentifier:XIB_TASKTABLEVIEWCELL];
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
    TaskTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:XIB_TASKTABLEVIEWCELL forIndexPath:indexPath];

    WIGZTask *task = [self.tasks objectAtIndex:indexPath.row];
    cell.labelName.text = task.name;
    cell.labelDescription.text = task.description_;
    cell.labelDebugActive.text = [NSString stringWithFormat:@"Active: %d", task.active];
    cell.labelDebugComplete.text = [NSString stringWithFormat:@"Complete: %d", task.complete];
    cell.labelDebugCompletedTime.text = [NSString stringWithFormat:@"CompletedTime: %@", task.completedTime];
    cell.labelDebugCorrectState.text = [NSString stringWithFormat:@"CorrectState: %@", task.correctState];

    if (task.media != nil) {
        WIGZMediaResource *resource = [task.media.resources firstObject];
        cell.ivMediaIcon.image = [UIImage imageWithContentsOfFile:resource.filename];
    }
    if (task.icon != nil) {
        WIGZMediaResource *resource = [task.icon.resources firstObject];
        cell.ivMediaIcon.image = [UIImage imageWithContentsOfFile:resource.filename];
    }

    return cell;
}

@end