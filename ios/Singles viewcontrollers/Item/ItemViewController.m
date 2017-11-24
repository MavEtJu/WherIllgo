//
//  YouSeeViewController.m
//  ios
//
//  Created by Edwin Groothuis on 23/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "main.h"

@interface ItemViewController ()

@end

@implementation ItemViewController

enum {
    SECTION_HEADER = 0,
    SECTION_COMMANDS,
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

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:XIB_UITABLEVIEWCELL];
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
        case SECTION_COMMANDS:
            return [self.item.commands count];
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
        case SECTION_COMMANDS:
            return @"Commands";
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
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XIB_UITABLEVIEWCELL forIndexPath:indexPath];

                    cell.textLabel.text = self.item.name;

                    c = cell;
                    break;
                }
                case HEADER_DESCRIPTION: {
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XIB_UITABLEVIEWCELL forIndexPath:indexPath];

                    cell.textLabel.text = self.item.description_;
                    cell.textLabel.font = [UIFont systemFontOfSize:12];
                    cell.textLabel.numberOfLines = 0;

                    c = cell;
                    break;
                }
                case HEADER_MEDIA: {
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XIB_UITABLEVIEWCELL forIndexPath:indexPath];

                    cell.textLabel.text = self.item.media.altText;

                    c = cell;
                    break;
                }
            }
            break;
        }
        case SECTION_COMMANDS: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XIB_UITABLEVIEWCELL forIndexPath:indexPath];
            WIGZCommand *command = [self.item.commandsArray objectAtIndex:indexPath.row];

            cell.textLabel.text = command.text;
            if (command.enabled == NO) {
                cell.textLabel.textColor = [UIColor lightTextColor];
                cell.userInteractionEnabled = NO;
            } else {
                cell.textLabel.textColor = [UIColor darkTextColor];
                cell.userInteractionEnabled = YES;
            }

            c = cell;
            break;
        }

        case SECTION_DEBUG: {
            switch (indexPath.row) {
                case 0: {
                    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:XIB_UITABLEVIEWCELL forIndexPath:indexPath];

                    cell.textLabel.font = [UIFont systemFontOfSize:12];
                    cell.textLabel.numberOfLines = 0;

                    NSMutableString *s = [NSMutableString stringWithString:@""];
                    [s appendFormat:@"Visible: %d\n", self.item.visible];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != SECTION_COMMANDS)
        return;

    WIGZCommand *command = [self.item.commandsArray objectAtIndex:indexPath.row];
    __block NSString *commandName;

    [self.item.commands enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, WIGZCommand * _Nonnull cmd, BOOL * _Nonnull stop) {
        if ([cmd._id isEqualToString:command._id] == YES) {
            commandName = key;
            *stop = YES;
        }
    }];

    if (command.enabled == NO)
        return;

    [wig runScript:[NSString stringWithFormat:@"%@.On%@()", self.item.luaObject, commandName]];

    self.item = [wig zitemForId:self.item._id];
    [self.tableView reloadData];
}

@end
