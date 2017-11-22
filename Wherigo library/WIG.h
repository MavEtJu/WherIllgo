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
@class WIGZMediaResource;

#import "WIGZObject.h"
#import "WIGZCharacter.h"
#import "WIGZCartridge.h"
#import "WIGZCommand.h"
#import "WIGDistance.h"
#import "WIGZone.h"
#import "WIGZMedia.h"
#import "WIGZMediaResource.h"
#import "WIGZonePoint.h"

@interface WIG : NSObject

@property (nonatomic, retain) WIGZCartridge *cartridge;
@property (nonatomic, retain) WIGZCharacter *player;

- (void)run:(NSString *)filename;

/* Various ZObjects */
- (NSArray *)arrayZTasks;
- (NSDictionary *)dictionaryZTasks;
- (NSArray *)arrayZones;
- (NSDictionary *)dictionaryZones;
- (NSArray *)arrayYouSee;
- (NSDictionary *)dictionaryYouSee;
- (NSArray *)arrayZItemsInventory;
- (NSDictionary *)dictionaryZItemsInventory;
- (NSArray *)arrayZItemsZone;
- (NSDictionary *)dictionaryZItemsZone;

/* Interface to WIG-link */
- (void)messageBoxCallback;

@end

extern WIG *wig;
