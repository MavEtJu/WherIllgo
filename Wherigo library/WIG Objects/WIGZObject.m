//
//  WIGZObject.m
//  ios
//
//  Created by Edwin Groothuis on 22/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "WIG.h"

@implementation WIGZObject

- (void)importFromDict:(NSDictionary *)dict
{
//    @property (nonatomic, retain) WIGZCartridge *cartridge;
//    @property (nonatomic, retain) WIGZObject *container;
//    @property (nonatomic, retain) NSDictionary<NSString *, WIGZCommand *> *commands;
//    @property (nonatomic, retain) NSArray<WIGZCommand *> *commandsArray;
//    @property (nonatomic, retain) WIGDistance *currentDistance;
//    @property (nonatomic, retain) NSArray<WIGZObject *> *inventory;
//    @property (nonatomic, retain) WIGZonePoint *objectLocation;
//    @property (nonatomic, retain) WIGZCharacter *player;

    self.description_ = [dict objectForKey:@"Description"];
    self.name = [dict objectForKey:@"Name"];
    self.visible = [[dict objectForKey:@"Visible"] boolValue];
    self.objIndex = [dict objectForKey:@"ObjIndex"];
    self.currentBearing = [dict objectForKey:@"CurrentBearing"];
    self._id = [dict objectForKey:@"Id"];

    NSDictionary *containerDict = [dict objectForKey:@"Container"];
    if ([containerDict isKindOfClass:[NSDictionary class]] == YES) {
        if ([[containerDict objectForKey:@"_classname"] isEqualToString:@"Zone"] == YES) {
            WIGZone *zone = [[WIGZone alloc] init];
            [zone importFromDict:[dict objectForKey:@"Container"]];
            self.container = zone;
        }
        if ([[containerDict objectForKey:@"_classname"] isEqualToString:@"Item"] == YES) {
            WIGZItem *item = [[WIGZItem alloc] init];
            [item importFromDict:[dict objectForKey:@"Container"]];
            self.container = item;
        }
        if ([[containerDict objectForKey:@"_classname"] isEqualToString:@"Character"] == YES) {
            WIGZCharacter *ch = [[WIGZCharacter alloc] init];
            [ch importFromDict:[dict objectForKey:@"Container"]];
            self.container = ch;
        }
    }

    NSDictionary *commandsDict = [dict objectForKey:@"Commands"];
    if ([commandsDict isKindOfClass:[NSDictionary class]] == YES) {
        NSMutableDictionary<NSString *, WIGZCommand *> *commands = [NSMutableDictionary dictionaryWithCapacity:10];

        [commandsDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSDictionary  * _Nonnull obj, BOOL * _Nonnull stop) {
            WIGZCommand *command = [[WIGZCommand alloc] init];
            [command importFromDict:obj];

            [commands setValue:command forKey:key];
        }];

        self.commands = commands;
        self.commandsArray = [self.commands allValues];
    }

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
