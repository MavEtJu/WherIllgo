//
//  WIGZMediaResources.m
//  ios
//
//  Created by Edwin Groothuis on 22/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "WIGZMediaResource.h"

@implementation WIGZMediaResource

- (void)importFromDict:(NSDictionary *)dict
{
    self.filename = [dict objectForKey:@"Filename"];
    self.type = [dict objectForKey:@"Type"];

    NSArray *ds = [dict objectForKey:@"Directives"];
    if ([ds isKindOfClass:[NSArray class]] == YES)
        self.directives = ds;
}

@end
