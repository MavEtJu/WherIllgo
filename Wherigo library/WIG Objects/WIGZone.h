//
//  WIGZone.h
//  ios
//
//  Created by Edwin Groothuis on 22/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "WIG.h"

@interface WIGZone : WIGZObject

/*
Active     Boolean.
        When true, the engine processes events for this zone and zone visibility is controlled by the
        Visible property. When false, the engine does not fire events for this zone and the zone is
        not visible.
ClosestPoint     ZonePoint.
        Point with the shortest distance to player.
DistanceRange     Distance.
        The width of the distance band around the zone, which is used to trigger the OnDistant event.
        A value of -1 is magic, in that it causes the OnDistant event to fire on cartridge startup.
InRangeName     String.
        Name of zone if it is in range.
OutOfRangeName     String.
        Name of zone if it is out of range.
Points     Table of ZonePoint.
        Holds points for the boundary of the zone.
ProximityRange     Distance.
        The width of the proximity band around the zone, which is used to trigger the OnProximity
        event.
ShowObjects     String.
        Could be "OnEnter", "OnProximity", "Never" or "Always".
State     String.
        Indicates the player's relationship to this zone. As the player moves toward and into the
        zone, takes on the values "NotInRange", "Distant", "Proximity", "Inside". As the player
        moves out of and away from the zone, takes on the same values in reverse order. It is not
        clear how "NotInRange" and "Distant" behave when the distance setting is -1. Not updated
        for inactive zones, but should take on the correct value as soon as the zone is activated.
Visible     Boolean.
        When true and the zone is active, the zone is visible in the location list. When false, or
        when the zone is inactive, the zone does not appear in the location list. As of 03/19/2008,
        there are still compatibility issues with regard to the interaction of Visible and
        DistanceRange. Colorado and PPC have different behaviors with regard to showing the zone.
        Colorado shows the zone only when Active, Visible and the player is within distance range
        of the zone. PPC shows the zone when Active and Visible, regardless of player proximity.
 */

@property (nonatomic        ) BOOL active;
@property (nonatomic, retain) WIGZonePoint *closestPoint;
@property (nonatomic, retain) WIGDistance *distance;
@property (nonatomic, retain) NSString *inRangeName;
@property (nonatomic, retain) NSString *outRangeName;
@property (nonatomic, retain) NSArray<WIGZonePoint *> *points;
@property (nonatomic, retain) WIGDistance *proximityRange;
@property (nonatomic, retain) NSString *showObjects;
@property (nonatomic, retain) NSString *state;

@end
