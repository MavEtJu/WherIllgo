//
//  WIGZTask.m
//  ios
//
//  Created by Edwin Groothuis on 22/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "WIG.h"

@implementation WIGZTask

- (void)importFromDict:(NSDictionary *)dict
{
    [super importFromDict:dict];

    self.active = [[dict objectForKey:@"_active"] boolValue];
    self.complete = [[dict objectForKey:@"_complete"] boolValue];
    self.completedTime = [dict objectForKey:@"CompletedTime"];
    self.correctState = [dict objectForKey:@"_correct"];
    self.sortOrder = [[dict objectForKey:@"SortOrder"] integerValue];;
}

@end
