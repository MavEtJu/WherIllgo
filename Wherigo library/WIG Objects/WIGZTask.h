//
//  WIGZTask.h
//  ios
//
//  Created by Edwin Groothuis on 22/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "WIGZObject.h"

@interface WIGZTask : WIGZObject

/*

 Active     Boolean.
        If the task is active or not.
 Complete     Boolean.
        If the task is complete or not.
 CompletedTime     Time.
        The time, when this task is marked as completed.
 CorrectState     String.
        State of the task. At the beginning, the state is "None". There are also the following states: "Correct", "NotCorrect".
 SortOrder     Number.
        Order to sort the tasks in lists. At the beginning, this number is 0. The task with the lowest number in SortOrder is at the top of the list.
 */

@property (nonatomic        ) BOOL active;
@property (nonatomic        ) BOOL complete;
@property (nonatomic, retain) NSNumber *completedTime;
@property (nonatomic, retain) NSString *correctState;
@property (nonatomic        ) NSInteger sortOrder;

@end
