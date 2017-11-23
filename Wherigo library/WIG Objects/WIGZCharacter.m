//
//  WIGZCharacter.m
//  ios
//
//  Created by Edwin Groothuis on 22/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "WIGZCharacter.h"

@implementation WIGZCharacter

- (void)importFromDict:(NSDictionary *)dict
{
    [super importFromDict:dict];

    self.gender = [dict objectForKey:@"Gender"];
    self.type = [dict objectForKey:@"Type"];
}

@end
