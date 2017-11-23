//
//  WIG.h
//  luatest
//
//  Created by Edwin Groothuis on 20/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WIGZObject;
@class WIGZCharacter;
@class WIGZCartridge;
@class WIGDistance;
@class WIGZCommand;
@class WIGZone;
@class WIGZonePoint;
@class WIGZMedia;
@class WIGZItem;
@class WIGZMediaResource;
@class WIGZTask;

#import "WIGZObject.h"
#import "WIGZCharacter.h"
#import "WIGZCartridge.h"
#import "WIGZCommand.h"
#import "WIGDistance.h"
#import "WIGZone.h"
#import "WIGZMedia.h"
#import "WIGZItem.h"
#import "WIGZMediaResource.h"
#import "WIGZonePoint.h"
#import "WIGZTask.h"

@interface WIG : NSObject

@property (nonatomic, retain) WIGZCartridge *cartridge;
@property (nonatomic, retain) WIGZCharacter *player;

- (void)run:(NSString *)filename;
- (void)updateLocation;

/* Various ZObjects */
- (NSArray<WIGZTask *> *)arrayZTasks;
- (NSDictionary<NSString *, WIGZTask *> *)dictionaryZTasks;
- (NSArray<WIGZone *> *)arrayZones;
- (NSDictionary<NSString *, WIGZone *> *)dictionaryZones;
- (NSArray<WIGZItem *> *)arrayZItemsInInventory;
- (NSDictionary<NSString *, WIGZItem *> *)dictionaryZItemsInInventory;

- (NSArray<WIGZCharacter *> *)arrayCharactersInZone:(WIGZone *)zone;
- (NSDictionary<NSString *, WIGZCharacter *> *)dictionaryCharactersInZone:(WIGZone *)zone;
- (NSArray<WIGZone *> *)arrayZonesInZone:(WIGZone *)zone;
- (NSDictionary<NSString *, WIGZone *> *)dictionaryZonesInZone:(WIGZone *)zone;
- (NSArray<WIGZItem *> *)arrayZItemsInZone:(WIGZone *)zone;
- (NSDictionary<NSString *, WIGZItem *> *)dictionaryZItemsInZone:(WIGZone *)zone;

/* Interface to WIG-link */
- (void)messageBoxCallback;

- (void)onClick:(NSString *)name;

@end

extern WIG *wig;
