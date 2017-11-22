//
//  TaskTableViewCell.h
//  ios
//
//  Created by Edwin Groothuis on 22/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import <UIKit/UIKit.h>

#define XIB_TASKTABLEVIEWCELL   @"TaskTableViewCell"

@interface TaskTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *labelName;
@property (nonatomic, retain) IBOutlet UILabel *labelDescription;
@property (nonatomic, retain) IBOutlet UILabel *labelDebugActive;
@property (nonatomic, retain) IBOutlet UILabel *labelDebugComplete;
@property (nonatomic, retain) IBOutlet UILabel *labelDebugCompletedTime;
@property (nonatomic, retain) IBOutlet UILabel *labelDebugCorrectState;

@property (nonatomic, retain) IBOutlet UIImageView *ivMediaIcon;

@end
