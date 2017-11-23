//
//  WIGZCartridge.m
//  ios
//
//  Created by Edwin Groothuis on 22/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "WIG.h"

@implementation WIGZCartridge

- (void)importFromDict:(NSDictionary *)dict
{
    [super importFromDict:dict];

//@property (nonatomic, retain) NSArray<WIGZObject *> *allZObjects;
//@property (nonatomic, retain) NSArray<NSObject *> *msgBoxCBFuncs;
//@property (nonatomic, retain) WIGZonePoint *startingLocation;
//@property (nonatomic, retain) NSDictionary<NSString *, NSObject *> *zvariables;

    self.activity = [dict objectForKey:@"Activity"];
    self.author = [dict objectForKey:@"Author"];
    self.builderVersion = [dict objectForKey:@"BuilderVersion"];
    self.company = [dict objectForKey:@"Company"];
    self.complete = [[dict objectForKey:@"Complete"] boolValue];
    self.countryId = [dict objectForKey:@"CountryId"];
    self.createDate = [dict objectForKey:@"CreateDate"];
    self.emptyInventoryListText = [dict objectForKey:@"EmptyInventoryListText"];
    self.emptyTasksListText = [dict objectForKey:@"EmptyTasksListText"];
    self.emptyYouSeeListText = [dict objectForKey:@"EmptyYouSeeListText"];
    self.emptyZonesListText = [dict objectForKey:@"EmptyZonesListText"];
    self.lastPlayedDate = [dict objectForKey:@"LastPlayDate"];
    self.publishDate = [dict objectForKey:@"PublishDate"];
    self.startingLocationDescription = [dict objectForKey:@"StartingLocationDescription"];
    self.stateId = [dict objectForKey:@"StateId"];
    self.targetDevice = [dict objectForKey:@"TargetDevice"];
    self.targetDeviceVersion = [dict objectForKey:@"TargetDeviceVersion"];
    self.updateDate = [dict objectForKey:@"UpdateDate"];
    self.useLogging = [[dict objectForKey:@"UseLogging"] boolValue];
    self.version = [dict objectForKey:@"Version"];
}

@end
