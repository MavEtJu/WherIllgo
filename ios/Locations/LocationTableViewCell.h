//
//  LocationTableViewCell.h
//  ios
//
//  Created by Edwin Groothuis on 21/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import <UIKit/UIKit.h>

#define XIB_LOCATIONTABLEVIEWCELL   @"LocationTableViewCell"

@interface LocationTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *labelName;
@property (nonatomic, retain) IBOutlet UILabel *labelDescription;
@property (nonatomic, retain) IBOutlet UILabel *labelDebugActive;
@property (nonatomic, retain) IBOutlet UILabel *labelDebugVisible;
@property (nonatomic, retain) IBOutlet UILabel *labelDebugState;
@property (nonatomic, retain) IBOutlet UILabel *labelDebugShowObjects;
@property (nonatomic, retain) IBOutlet UIImageView *ivMediaIcon;

@end
