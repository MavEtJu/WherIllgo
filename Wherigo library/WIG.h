//
//  WIG.h
//  luatest
//
//  Created by Edwin Groothuis on 20/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WIG : NSObject

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
