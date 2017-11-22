//
//  LocationHeaderTableViewCell.h
//  ios
//
//  Created by Edwin Groothuis on 22/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import <UIKit/UIKit.h>

#define XIB_LOCATION_HEADER_TABLEVIEWCELL   @"LocationHeaderTableViewCell"

@interface LocationHeaderTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *labelName;
@property (nonatomic, retain) IBOutlet UILabel *labelDescription;
@property (nonatomic, retain) IBOutlet UIImageView *ivMedia;

@end
