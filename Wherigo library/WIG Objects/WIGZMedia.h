//
//  WIGZMedia.h
//  ios
//
//  Created by Edwin Groothuis on 22/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "WIG.h"

@interface WIGZMedia : WIGZObject

/*
AltText     String.
        Natural language text to be displayed if the media file is not available.
Description     String.
        Natural language description of the media.
Id     String.
        Unique hex identifier assigned by Builder.
Name     String.
        Natural language name of the media.
Resources     Table.
        Describes the media file itself; contains three sub-properties: Type, a string describing the type
        of media (such as "jpg"); Filename, a string specifying the filename the media should reference;
        and Directives, an array which may contain attributes such as "NoResize".
 */

@property (nonatomic, retain) NSString *altText;
@property (nonatomic, retain) NSArray<WIGZMediaResource *> *resources;

@end
