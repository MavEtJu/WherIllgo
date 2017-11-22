//
//  WIGZCartridge.h
//  ios
//
//  Created by Edwin Groothuis on 22/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "WIG.h"

@interface WIGZCartridge : WIGZObject

/*
 Activity     String.
        The activity type this cartridge implements. Available options in Builder include "TourGuide", "Puzzle", "Fiction", and "Geocache". It is displayed to the user in the cartridge selection screen of the Player.
 AllZObjects     Table.
        Containing a reference to every ZObject (except variables). Includes zones, characters, items, tasks, timers, inputs, media, and the cartridge itself (always ObjIndex = 0). Use tostring(tableentryvalue) to determine what type of ZObject you have. For example, the result for a ZCharacter is "a ZCharacter instance".
 Author     String.
        Name of the individual responsible for development of the cartridge.
 BuilderVersion     String.
        Build version of the Builder application the cartridge was developed under.
 Company     String.
        Name of company responsible for development of the cartridge.
 Complete     Boolean.
        Read/write. Whether the cartridge has been completed.
 CountryId     String.
        Presumably indicates the country a cartridge is developed for. Builder initializes to "2" for a cartridge built in the United States.
 CreateDate     String.
        Date time stamp of when the cartridge was first created.
 Description     String.
        Natural language description of the cartridge.
 EmptyInventoryListText     String.
        Is displayed, if the inventory list has no entry.
 EmptyTasksListText     String.
        Is displayed, if the tasks list has no entry.
 EmptyYouSeeListText     String.
        Is displayed, if the you see list has no entry.
 EmptyZonesListText     String.
        Is displayed, if the zones list has no entry.
 LastPlayedDate     String.
        Presumably date time stamp of when the cartridge was last played. Set to minimum value by Builder (as cartridge has not been played while in Builder).
 MsgBoxCBFuncs     Table.
        Callback function pointers used by Builder to route events to appropriate objects.
 PublishDate     String.
        Date time stamp of when the cartridge was published to Wherigo.com. Set to minimum value by Builder.
 StartingLocation     ZonePoint.
        The location the user should be in to begin the Wherigo cartridge. For locationless or "Play Anywhere" cartridges, this value should be set to Wherigo.INVALID_ZONEPOINT. Builder does not support locationless cartridges as of the 3/27/2008 build.
 StartingLocationDescription     String.
        Natural language description of the starting location for the cartridge.
 StateId     String.
        Purpose unknown; Builder initializes to "1".
 TargetDevice     String.
        Device the cartridge was built for. Valid values include at least "PocketPC" or "Colorado". There could although be more different entries.
 TargetDeviceVersion     String.
        Purpose unknown; may serve to restrict cartridges to particular revisions of Player software in the future as features are added or modified. Builder initializes this to "0".
 UpdateDate     String.
        Date time stamp of when the cartridge was last updated by Builder.
 UseLogging     Boolean.
        Whether the Player should log actions to a log file.
 Version     String.
        The release version of the cartridge. Builder initially sets this to "1.0".
 ZVariables     Table.
        Association of user-defined variables created in Builder, linking variable name to initial values. All variables, which are in this table will be saved, if the game is saved. It is enough to make ZVariables[<variable name>] = true to save the variable with name <variable name>.
 */

@property (nonatomic, retain) NSString *activity;
@property (nonatomic, retain) NSArray<WIGZObject *> *allZObjects;
@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *builderVersion;
@property (nonatomic, retain) NSString *company;
@property (nonatomic        ) BOOL complete;
@property (nonatomic, retain) NSString *countryId;
@property (nonatomic, retain) NSString *createDate;
@property (nonatomic, retain) NSString *emptyInventoryListText;
@property (nonatomic, retain) NSString *emptyTasksListText;
@property (nonatomic, retain) NSString *emptyYouSeeListText;
@property (nonatomic, retain) NSString *emptyZonesListText;
@property (nonatomic, retain) NSString *lastPlayedDate;
@property (nonatomic, retain) NSArray<NSObject *> *msgBoxCBFuncs;
@property (nonatomic, retain) NSString *publishDate;
@property (nonatomic, retain) WIGZonePoint *startingLocation;
@property (nonatomic, retain) NSString *startingLocationDescription;
@property (nonatomic, retain) NSString *stateId;
@property (nonatomic, retain) NSString *targetDevice;
@property (nonatomic, retain) NSString *targetDeviceVersion;
@property (nonatomic, retain) NSString *updateDate;
@property (nonatomic        ) BOOL useLogging;
@property (nonatomic, retain) NSString *version;
@property (nonatomic, retain) NSDictionary<NSString *, NSObject *> *zvariables;

@end
