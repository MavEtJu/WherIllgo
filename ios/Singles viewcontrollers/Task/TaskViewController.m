//
//  TaskViewController.m
//  ios
//
//  Created by Edwin Groothuis on 23/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "main.h"

@interface TaskViewController ()

@end

@implementation TaskViewController

enum {
    SECTION_HEADER = 0,
    SECTION_DEBUG,
    SECTION_MAX,

    HEADER_NAME = 0,
    HEADER_MEDIA,
    HEADER_DESCRIPTION,
    HEADER_MAX,
};

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerClass:[UIDefaultTableViewCell class] forCellReuseIdentifier:XIB_UIDEFAULTTABLEVIEWCELL];
    [self.tableView registerClass:[UISmallTableViewCell class] forCellReuseIdentifier:XIB_UISMALLTABLEVIEWCELL];
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
            return HEADER_MAX;
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
        case SECTION_DEBUG:
            return @"Debug";
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *c = nil;

    switch (indexPath.section) {
        case SECTION_HEADER: {
            switch (indexPath.row) {
                case HEADER_NAME: {
                    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:XIB_UIDEFAULTTABLEVIEWCELL forIndexPath:indexPath];

                    cell.textLabel.text = self.task.name;

                    c = cell;
                    break;
                }
                case HEADER_MEDIA: {
                    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:XIB_UIDEFAULTTABLEVIEWCELL forIndexPath:indexPath];

                    cell.textLabel.text = self.task.media.altText;

                    c = cell;
                    break;
                }
                case HEADER_DESCRIPTION: {
                    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:XIB_UISMALLTABLEVIEWCELL forIndexPath:indexPath];

                    cell.textLabel.text = self.task.description_;

                    c = cell;
                    break;
                }
            }
            break;
        }

        case SECTION_DEBUG: {
            switch (indexPath.row) {
                case 0: {
                    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:XIB_UISMALLTABLEVIEWCELL forIndexPath:indexPath];

                    NSMutableString *s = [NSMutableString stringWithString:@""];
                    [s appendFormat:@"Active: %d\n", self.task.active];
                    [s appendFormat:@"Visible: %d\n", self.task.visible];
                    [s appendFormat:@"CorrectState: %@\n", self.task.correctState];
                    [s appendFormat:@"Complete: %d\n", self.task.complete];
                    [s appendFormat:@"CompletedTime: %@\n", self.task.completedTime];
                    cell.textLabel.text = s;

                    c = cell;
                    break;
                }
            }
            break;
        }
    }
    
    return c;
}

@end
