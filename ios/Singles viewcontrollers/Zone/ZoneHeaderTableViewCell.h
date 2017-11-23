//
//  LocationHeaderTableViewCell.h
//  ios
//
//  Created by Edwin Groothuis on 22/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#define XIB_ZONE_HEADER_TABLEVIEWCELL   @"ZoneHeaderTableViewCell"

@interface ZoneHeaderTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *labelName;
@property (nonatomic, retain) IBOutlet UILabel *labelDescription;
@property (nonatomic, retain) IBOutlet UIImageView *ivMedia;

@end
