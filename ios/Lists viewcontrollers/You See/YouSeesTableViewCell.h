//
//  YouSeesTableViewCell.h
//  ios
//
//  Created by Edwin Groothuis on 23/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#define XIB_YOUSEES_TABLEVIEWCELL   @"YouSeesTableViewCell"

@interface YouSeesTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *labelName;
@property (nonatomic, retain) IBOutlet UILabel *labelDescription;

@property (nonatomic, retain) IBOutlet UILabel *labelDebugVisible;
@property (nonatomic, retain) IBOutlet UILabel *labelDebugActive;

@property (nonatomic, retain) IBOutlet UIImageView *ivIcon;

@end
