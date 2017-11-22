//
//  WIGZone.m
//  ios
//
//  Created by Edwin Groothuis on 22/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "WIGZone.h"

@implementation WIGZone

- (void)importFromDict:(NSDictionary *)dict
{
    [super importFromDict:dict];

//    @property (nonatomic, retain) WIGZonePoint *closestPoint;
//    @property (nonatomic, retain) WIGDistance *distance;
//    @property (nonatomic, retain) NSArray<WIGZonePoint *> *points;
//    @property (nonatomic, retain) WIGDistance *proximityRange;

    self.active = [[dict objectForKey:@"_active"] boolValue];
    self.inRangeName = [dict objectForKey:@"InRangeName"];
    self.outRangeName = [dict objectForKey:@"OutRangeName"];
    self.showObjects = [dict objectForKey:@"ShowObjects"];
    self.state = [dict objectForKey:@"State"];
}

@end
