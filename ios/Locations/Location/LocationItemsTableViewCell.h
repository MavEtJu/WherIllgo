//
//  LocationItemsTableViewCell.h
//  ios
//
//  Created by Edwin Groothuis on 22/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import <UIKit/UIKit.h>

#define XIB_LOCATION_ITEMS_TABLEVIEWCELL   @"LocationItemsTableViewCell"

@interface LocationItemsTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *labelItems;

@end
