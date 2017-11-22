//
//  WIG.m
//  luatest
//
//  Created by Edwin Groothuis on 20/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "WIG.h"

#import "LuaContext.h"

#import "main.h"

WIG *wig = nil;

@interface WIG ()

@property (nonatomic, retain) LuaContext *ctx;

@end

@implementation WIG

- (instancetype)init
{
    self = [super init];

    self.ctx = [LuaContext new];

    return self;
}

- (void)run:(NSString *)filename
{

    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSString *dir = [[NSBundle mainBundle] resourcePath];
    if ([filemgr changeCurrentDirectoryPath:dir] == NO)
        NSLog(@"Cannot change current directory");
    NSLog(@"Chagned current directory to %@", dir);

    NSError *error = nil;
    NSString *myScript = [NSString stringWithFormat:LUA_STRING(
        f = loadfile("%@")
        cart = f()
        ), filename];
    [self.ctx parse:myScript error:&error];
    if (error != nil) {
        NSLog(@"Error parsing lua code: %@", error);
        return;
    }
    NSLog(@"Author: %@", self.cartridge.author);

    myScript = LUA_STRING(
        cart.OnStart()
    );
    [self runScript:myScript];

    [tasksViewController reloadData];
    [locationsViewController reloadData];
    [youSeeViewController reloadData];
    [inventoryViewController reloadData];
    [mapViewController reloadData];
}

- (void)runScript:(NSString *)myscript
{
    NSError *error = nil;
    [self.ctx parse:myscript error:&error];
    if (error != nil) {
        NSLog(@"Error parsing lua code: %@", error);
        return;
    }
}

/*
 * Interaction with objects
 */
- (NSDictionary *)dictionaryZTasks
{
    NSMutableDictionary *zs = [NSMutableDictionary dictionaryWithCapacity:10];

    NSDictionary *g = [self.ctx globalVar:@"_G"];
    [g enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]] == NO)
            return;
        NSDictionary *dict = obj;
        NSString *type = [dict objectForKey:@"_classname"];
        if ([type isEqualToString:@"ZTask"] == NO)
            return;
        [zs setObject:dict forKey:key];
    }];

    return zs;
}

- (NSArray *)arrayZTasks
{
    NSDictionary *tasks = [self dictionaryZTasks];
    NSMutableArray *zs = [NSMutableArray arrayWithCapacity:[tasks count]];
    for (NSInteger idx = 0; idx < [tasks count]; idx++) {
        [zs addObject:[NSNull null]];
    }

    [tasks enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSDictionary * _Nonnull task, BOOL * _Nonnull stop) {
        NSInteger idx = [[task objectForKey:@"SortOrder"] integerValue] - 1;
        [zs replaceObjectAtIndex:idx withObject:task];
    }];

    return zs;
}

- (NSDictionary *)dictionaryZones
{
    NSMutableDictionary *zs = [NSMutableDictionary dictionaryWithCapacity:10];

    NSDictionary *g = [self.ctx globalVar:@"_G"];
    [g enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]] == NO)
            return;
        NSDictionary *dict = obj;
        NSString *type = [dict objectForKey:@"_classname"];
        if ([type isEqualToString:@"Zone"] == NO)
            return;
        WIGZone *zone = [[WIGZone alloc] init];
        [zone importFromDict:dict];
        [zs setObject:zone forKey:key];
    }];

    return zs;
}

- (NSArray *)arrayZones
{
    NSDictionary *zones = [self dictionaryZones];
    return [zones allValues];
}

- (NSDictionary *)dictionaryZItemsZone
{
    NSMutableDictionary *zs = [NSMutableDictionary dictionaryWithCapacity:10];

    NSDictionary *g = [self.ctx globalVar:@"_G"];
    [g enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]] == NO)
            return;
        NSDictionary *dict = obj;
        NSString *type = [dict objectForKey:@"_classname"];
        if ([type isEqualToString:@"ZItem"] == NO)
            return;
        id container = [dict objectForKey:@"Container"];
        if ([container isKindOfClass:[NSNumber class]] == YES)
            return;
        NSString *containerType = [container objectForKey:@"_classname"];
        if ([containerType isEqualToString:@"Zone"] == NO)
            return;
        [zs setObject:dict forKey:key];
    }];

    return zs;
}

- (NSArray *)arrayZItemsZone
{
    NSDictionary *zones = [self dictionaryZItemsZone];
    return [zones allValues];
}

- (NSDictionary *)dictionaryZItemsInventory
{
    NSMutableDictionary *zs = [NSMutableDictionary dictionaryWithCapacity:10];

    NSDictionary *g = [self.ctx globalVar:@"_G"];
    [g enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]] == NO)
            return;
        NSDictionary *dict = obj;
        NSString *type = [dict objectForKey:@"_classname"];
        if ([type isEqualToString:@"ZItem"] == NO)
            return;
        id container = [dict objectForKey:@"Container"];
        if ([container isKindOfClass:[NSNumber class]] == YES)
            return;
        NSString *containerType = [container objectForKey:@"_classname"];
        if ([containerType isEqualToString:@"ZCharacter"] == NO)
            return;
        [zs setObject:dict forKey:key];
    }];

    return zs;
}

- (NSArray *)arrayZItemsInventory
{
    NSDictionary *zones = [self dictionaryZItemsInventory];
    return [zones allValues];
}

- (WIGZCartridge *)cartridge
{
    NSDictionary *g = [self.ctx globalVar:@"_G"];
    WIGZCartridge *cartridge = [[WIGZCartridge alloc] init];
    [cartridge importFromDict:[g objectForKey:@"cart"]];
    return cartridge;
}

/*
 * Calls from WIG-link
 */
- (void)messageBoxCallback
{
    NSString *myScript = LUA_STRING(
        Wherigo._MessageBoxResponse(1)
    );
    [self runScript:myScript];
}

@end
