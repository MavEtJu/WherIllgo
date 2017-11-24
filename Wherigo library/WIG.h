//
//  WIG.h
//  luatest
//
//  Created by Edwin Groothuis on 20/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>

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

#import "WIGUI.h"

@interface WIG : NSObject

@property (nonatomic, retain) WIGZCartridge *cartridge;
@property (nonatomic, retain) WIGZCharacter *player;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

- (void)runFile:(NSString *)filename;
- (void)runScript:(NSString *)myscript;
- (void)updateLocation;

/* Various ZObjects */
- (NSArray<WIGZTask *> *)arrayZTasks;
- (NSDictionary<NSString *, WIGZTask *> *)dictionaryZTasks;

- (NSArray<WIGZone *> *)arrayZones;
- (NSDictionary<NSString *, WIGZone *> *)dictionaryZones;
- (NSArray<WIGZone *> *)arrayZonesInZone:(WIGZone *)zone;
- (NSDictionary<NSString *, WIGZone *> *)dictionaryZonesInZone:(WIGZone *)zone;

- (NSArray<WIGZItem *> *)arrayZItemsInInventory;
- (NSDictionary<NSString *, WIGZItem *> *)dictionaryZItemsInInventory;
- (NSArray<WIGZItem *> *)arrayZItemsInZone:(WIGZone *)zone;
- (NSDictionary<NSString *, WIGZItem *> *)dictionaryZItemsInZone:(WIGZone *)zone;
- (WIGZItem *)zitemForId:(NSString *)_id;

- (NSArray<WIGZCharacter *> *)arrayZCharactersInZone:(WIGZone *)zone;
- (NSDictionary<NSString *, WIGZCharacter *> *)dictionaryZCharactersInZone:(WIGZone *)zone;

- (NSArray<WIGZMedia *> *)arrayZMedias;
- (WIGZMedia *)mediaByObjId:(NSNumber *)objIndex;

/* Interface to WIG-link */
- (void)messageBoxCallback;

- (void)onClick:(NSString *)name;

@end

extern WIG *wig;
