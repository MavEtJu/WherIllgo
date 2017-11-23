//
//  WIGZone.m
//  ios
//
//  Created by Edwin Groothuis on 22/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "WIG.h"

@implementation WIGZone

- (void)importFromDict:(NSDictionary *)dict
{
    [super importFromDict:dict];

//    @property (nonatomic, retain) WIGZonePoint *closestPoint;
//    @property (nonatomic, retain) NSArray<WIGZonePoint *> *points;

    self.active = [[dict objectForKey:@"_active"] boolValue];
    self.inRangeName = [dict objectForKey:@"InRangeName"];
    self.outRangeName = [dict objectForKey:@"OutOfRangeName"];
    self.showObjects = [dict objectForKey:@"ShowObjects"];
    self.state = [dict objectForKey:@"State"];
    self.distance = [[dict objectForKey:@"DistanceRange"] objectForKey:@"value"];
    self.proximityRange = [[dict objectForKey:@"ProximityRange"] objectForKey:@"value"];
}

@end
