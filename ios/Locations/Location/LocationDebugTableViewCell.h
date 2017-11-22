//
//  LocationDebugTableViewCell.h
//  ios
//
//  Created by Edwin Groothuis on 22/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import <UIKit/UIKit.h>

#define XIB_LOCATION_DEBUG_TABLEVIEWCELL   @"LocationDebugTableViewCell"

@interface LocationDebugTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *labelDebugActive;
@property (nonatomic, retain) IBOutlet UILabel *labelDebugVisible;
@property (nonatomic, retain) IBOutlet UILabel *labelDebugState;
@property (nonatomic, retain) IBOutlet UILabel *labelDebugShowObjects;

@end
