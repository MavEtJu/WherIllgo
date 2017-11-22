//
//  WIGZObject.m
//  ios
//
//  Created by Edwin Groothuis on 22/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "WIGZObject.h"
#import "WIGZMedia.h"

@implementation WIGZObject

- (void)importFromDict:(NSDictionary *)dict
{
//    @property (nonatomic, retain) WIGZCartridge *cartridge;
//    @property (nonatomic, retain) WIGZObject *container;
//    @property (nonatomic, retain) NSDictionary<NSString *, WIGZCommand *> *commands;
//    @property (nonatomic, retain) NSArray<WIGZCommand *> *commandsArray;
//    @property (nonatomic, retain) WIGDistance *currentDistance;
//    @property (nonatomic, retain) NSString *_id;
//    @property (nonatomic, retain) NSArray<WIGZObject *> *inventory;
//    @property (nonatomic, retain) WIGZonePoint *objectLocation;
//    @property (nonatomic, retain) WIGZCharacter *player;

    self.description_ = [dict objectForKey:@"Description"];
    self.name = [dict objectForKey:@"Name"];
    self.gender = [dict objectForKey:@"Gender"];
    self.type = [dict objectForKey:@"Type"];
    self.visible = [[dict objectForKey:@"Visible"] boolValue];
    self.objIndex = [dict objectForKey:@"ObjIndex"];
    self.currentBearing = [dict objectForKey:@"CurrentBearing"];

    NSDictionary *mediaDict = [dict objectForKey:@"Media"];
    if ([mediaDict isKindOfClass:[NSDictionary class]] == YES) {
        WIGZMedia *media = [[WIGZMedia alloc] init];
        [media importFromDict:mediaDict];
        self.media = media;
    }

    mediaDict = [dict objectForKey:@"Icon"];
    if ([mediaDict isKindOfClass:[NSDictionary class]] == YES) {
        WIGZMedia *media = [[WIGZMedia alloc] init];
        [media importFromDict:mediaDict];
        self.icon = media;
    }

}

@end
