//
//  WIGZMedia.m
//  ios
//
//  Created by Edwin Groothuis on 22/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "WIG.h"

@implementation WIGZMedia

- (void)importFromDict:(NSDictionary *)dict
{
    [super importFromDict:dict];

    self.altText = [dict objectForKey:@"AltText"];

    NSArray<NSDictionary *> *resourcesArray = [dict objectForKey:@"Resources"];
    if ([resourcesArray isKindOfClass:[NSArray class]] == YES) {
        NSMutableArray<WIGZMediaResource *> *resources = [NSMutableArray arrayWithCapacity:10];
        [resourcesArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull resourceDict, NSUInteger idx, BOOL * _Nonnull stop) {
            WIGZMediaResource *resource = [[WIGZMediaResource alloc] init];
            [resource importFromDict:resourceDict];
            [resources addObject:resource];
        }];
        self.resources = resources;
    }
}

@end
