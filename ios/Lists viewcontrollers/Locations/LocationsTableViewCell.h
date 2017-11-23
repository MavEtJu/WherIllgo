//
//  LocationTableViewCell.h
//  ios
//
//  Created by Edwin Groothuis on 21/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import <UIKit/UIKit.h>

#define XIB_LOCATIONSTABLEVIEWCELL   @"LocationsTableViewCell"

@interface LocationsTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *labelName;
@property (nonatomic, retain) IBOutlet UILabel *labelDescription;
@property (nonatomic, retain) IBOutlet UILabel *labelItems;
@property (nonatomic, retain) IBOutlet UILabel *labelDebug;

@property (nonatomic, retain) IBOutlet UIImageView *ivMediaIcon;

@end
