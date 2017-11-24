//
//  WIGZCommand.m
//  ios
//
//  Created by Edwin Groothuis on 22/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "WIG.h"

@implementation WIGZCommand

- (void)importFromDict:(NSDictionary *)dict
{
    [super importFromDict:dict];

//@property (nonatomic, retain) NSArray<ZObject *> *worksWithList;

    if ([self._id isEqualToString:@"7e1cf8a2-d4e1-45ca-9792-d0d4502548c5"] == YES)
        NSLog(@"foo");

    self.text = [dict objectForKey:@"Text"];
    self.cmdwith = [[dict objectForKey:@"CmdWidth"] boolValue];;
    self.custom = [[dict objectForKey:@"Custom"] boolValue];;
    self.enabled = [[dict objectForKey:@"_enabled"] boolValue];;
    self.emptyTargetListText = [dict objectForKey:@"EmptyTargetListText"];
    self.makeReciprocal = [[dict objectForKey:@"MakeReciprocal"] boolValue];;
    self.worksWithAll = [[dict objectForKey:@"WorksWithAll"] boolValue];;
}

@end
