//
//  WIGZObject.h
//  ios
//
//  Created by Edwin Groothuis on 22/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

@class WIGZCharacter;
@class WIGZCartridge;
@class WIGDistance;
@class WIGZCommand;
@class WIGZone;
@class WIGZonePoint;
@class WIGZMedia;

@interface WIGZObject : NSObject

/*
From http://wiki.wherigofoundation.com/index.php?title=ZObject

Cartridge
        ZCartridge object represents cartridge.
Container
        ZObject item (generally ZCharacter, ZItem or Zone) in which Inventory this ZObject is.
        When ZObject is not in a container, Container property returns boolean value false.
Commands (*)
        A table of user defined ZCommands on item. They are indexed by their name (string value).
        Usage: ZItem.Commands["UseItem"].Enabled = false;
CommandsArray (*)
        A table of user defined ZCommands on item. They are indexed by numbers (starting 1).
        Usage: ZItem.CommandsArray[1].Enabled = false;
CurrentBearing (Number)
        Bearing of the oject relative to the Player. Player's bearing will always be 0
CurrentDistance (Distance)
        Distance of the object relative to the Player. Player's distance will always be 0
Description (String)
        Description of item.
Gender (String)
        Gender of object. Only for ZCharacter.
Icon (ZMedia)
        Icon to display for this cartridge.
Id (String)
        Guid identificator of object. Only used by builder.
Inventory (Table)
        A table of ZObjects nested into this ZObject.
Media (ZMedia)
        Media to display for this Object.
Name (String)
        Name of this object to display.
ObjectLocation (ZonePoint)
        Returns location of object (usefull for ZItems and ZCharacters). Returns boolean value
        false, if the location is not set.
        Attention: Zone.ObjectLocation returns always false! Use Zone.OriginalPoint (only for
        builder) property or Zone.Points collection.
ObjIndex (Number)
        Index of ZObject in ZCartridge.AllZObjects table.
Player
        object is not contained in AllZObjects collection. Player.ObjIndex returns always -21555.
Type (String)
        Type of object. Only for ZCharacter.
Visible (Boolean)
        Applies for ZItem, ZCharacter, Zone. Determines if ZObject is visible.

 */

@property (nonatomic, retain) WIGZCartridge *cartridge;
@property (nonatomic, retain) WIGZObject *container;
@property (nonatomic, retain) NSDictionary<NSString *, WIGZCommand *> *commands;
@property (nonatomic, retain) NSArray<WIGZCommand *> *commandsArray;
@property (nonatomic, retain) NSNumber *currentBearing;
@property (nonatomic, retain) WIGDistance *currentDistance;
@property (nonatomic, retain) NSString *description_;
@property (nonatomic, retain) WIGZMedia *icon;
@property (nonatomic, retain) NSString *_id;
@property (nonatomic, retain) NSArray<WIGZObject *> *inventory;
@property (nonatomic, retain) WIGZMedia *media;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) WIGZonePoint *objectLocation;
@property (nonatomic, retain) NSNumber *objIndex;
@property (nonatomic, retain) WIGZCharacter *player;
@property (nonatomic        ) BOOL visible;

@property (nonatomic, retain) NSString *luaObject;

- (void)importFromDict:(NSDictionary *)dict;

@end
