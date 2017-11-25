//
//  UISmallTableViewCell.m
//  ios
//
//  Created by Edwin Groothuis on 25/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "UISmallTableViewCell.h"

@implementation UISmallTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code

    self.textLabel.numberOfLines = 0;
    self.textLabel.font = [UIFont systemFontOfSize:12];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    self.textLabel.numberOfLines = 0;
    self.textLabel.font = [UIFont systemFontOfSize:12];

    return self;
}

@end
