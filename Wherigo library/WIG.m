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

- (void)runFile:(NSString *)filename
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
    [youSeesViewController reloadData];
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

- (void)updateLocation
{
//    --   @param     position        ZonePoint object with player location
//    --   @param     t                       Time to update timers
//    --   @param accuracy    GPS position accuracy
    NSString *myScript = LUA_STRING(
//     11.006991863251    49.471393994725
//     11.008279323578    49.471352163343
//     11.00753903389    49.470766520251
// E 11.0076    N  49.471

        cart._update(Wherigo.ZonePoint(11.0076, 49.471, 10), 1, 5)
    );
    [self runScript:myScript];
}

/*
 * Interaction with objects
 */
- (NSDictionary<NSString *, WIGZTask *> *)dictionaryZTasks
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

        WIGZTask *task = [[WIGZTask alloc] init];
        [task importFromDict:dict];
        task.luaObject = key;

        [zs setObject:task forKey:key];
    }];

    return zs;
}

- (NSArray<WIGZTask *> *)arrayZTasks
{
    NSDictionary<NSString *, WIGZTask *> *tasks = [self dictionaryZTasks];
    NSMutableArray *zs = [NSMutableArray arrayWithCapacity:[tasks count]];
    for (NSInteger idx = 0; idx < [tasks count]; idx++) {
        [zs addObject:[NSNull null]];
    }

    [tasks enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, WIGZTask * _Nonnull task, BOOL * _Nonnull stop) {
        NSInteger idx = task.sortOrder - 1;
        [zs replaceObjectAtIndex:idx withObject:task];
    }];

    return zs;
}

- (NSDictionary<NSString *, WIGZone *> *)dictionaryZones
{
    NSMutableDictionary<NSString *, WIGZone *> *zs = [NSMutableDictionary dictionaryWithCapacity:10];

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
        zone.luaObject = key;

        [zs setObject:zone forKey:key];
    }];

    return zs;
}

- (NSArray<WIGZone *> *)arrayZones
{
    NSDictionary<NSString *, WIGZone *> *zones = [self dictionaryZones];
    return [zones allValues];
}

- (NSDictionary<NSString *, WIGZItem *> *)dictionaryZItems
{
    NSMutableDictionary<NSString *, WIGZItem *> *zs = [NSMutableDictionary dictionaryWithCapacity:10];

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

        WIGZItem *item = [[WIGZItem alloc] init];
        [item importFromDict:dict];
        item.luaObject = key;

        [zs setObject:item forKey:key];
    }];

    return zs;
}

- (NSArray<WIGZItem *> *)arrayZItems
{
    return [[self dictionaryZItems] allValues];
}

- (NSDictionary<NSString *, WIGZItem *> *)dictionaryZItemsInZone:(WIGZone *)zone
{
    NSMutableDictionary<NSString *, WIGZItem *> *zs = [NSMutableDictionary dictionaryWithCapacity:10];

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
        NSString *_id = [container objectForKey:@"Id"];
        if ([_id isEqualToString:zone._id] == NO)
            return;

        WIGZItem *item = [[WIGZItem alloc] init];
        [item importFromDict:dict];
        item.luaObject = key;

        [zs setObject:item forKey:key];
    }];

    return zs;
}

- (NSArray<WIGZItem *> *)arrayZItemsInZone:(WIGZone *)zone
{
    return [[self dictionaryZItemsInZone:zone] allValues];
}

- (WIGZItem *)zitemForId:(NSString *)_id
{
    WIGZItem *item = [[WIGZItem alloc] init];

    NSDictionary *g = [self.ctx globalVar:@"_G"];
    [g enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSDictionary * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]] == NO)
            return;
        NSString *__id = [obj objectForKey:@"Id"];
        if ([__id isKindOfClass:[NSString class]] == NO)
            return;
        if ([__id isEqualToString:_id] == NO)
            return;
        [item importFromDict:obj];
        item.luaObject = key;
    }];

    return item;
}

- (WIGZItem *)zitemByObjectId:(NSNumber *)objIndex
{
    NSArray<WIGZItem *> *items = [self arrayZItems];
    __block WIGZItem *item;
    [items enumerateObjectsUsingBlock:^(WIGZItem * _Nonnull i, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([i.objIndex isEqualToNumber:objIndex] == NO)
            return;
        item = i;
        *stop = YES;
    }];
    return item;
}

- (NSDictionary<NSString *, WIGZone *> *)dictionaryZonesInZone:(WIGZone *)zone
{
    NSMutableDictionary<NSString *, WIGZone *> *zs = [NSMutableDictionary dictionaryWithCapacity:10];

    NSDictionary *g = [self.ctx globalVar:@"_G"];
    [g enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]] == NO)
            return;
        NSDictionary *dict = obj;
        NSString *type = [dict objectForKey:@"_classname"];
        if ([type isEqualToString:@"Zone"] == NO)
            return;
        id container = [dict objectForKey:@"Container"];
        if ([container isKindOfClass:[NSNumber class]] == YES)
            return;
        NSString *containerType = [container objectForKey:@"_classname"];
        if ([containerType isEqualToString:@"Zone"] == NO)
            return;
        NSString *_id = [container objectForKey:@"Id"];
        if ([_id isEqualToString:zone._id] == NO)
            return;

        WIGZone *zone = [[WIGZone alloc] init];
        [zone importFromDict:dict];
        zone.luaObject = key;

        [zs setObject:zone forKey:key];
    }];

    return zs;
}

- (NSArray<WIGZone *> *)arrayZonesInZone:(WIGZone *)zone
{
    return [[self dictionaryZonesInZone:zone] allValues];
}

- (NSDictionary<NSString *, WIGZCharacter *> *)dictionaryZCharactersInZone:(WIGZone *)zone
{
    NSMutableDictionary<NSString *, WIGZCharacter *> *zs = [NSMutableDictionary dictionaryWithCapacity:10];

    NSDictionary *g = [self.ctx globalVar:@"_G"];
    [g enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]] == NO)
            return;
        NSDictionary *dict = obj;
        NSString *type = [dict objectForKey:@"_classname"];
        if ([type isEqualToString:@"ZCharacter"] == NO)
            return;
        id container = [dict objectForKey:@"Container"];
        if ([container isKindOfClass:[NSNumber class]] == YES)
            return;
        NSString *containerType = [container objectForKey:@"_classname"];
        if ([containerType isEqualToString:@"Zone"] == NO)
            return;
        NSString *_id = [container objectForKey:@"Id"];
        if ([_id isEqualToString:zone._id] == NO)
            return;

        WIGZCharacter *character = [[WIGZCharacter alloc] init];
        [character importFromDict:dict];
        character.luaObject = key;

        [zs setObject:character forKey:key];
    }];

    return zs;
}

- (NSArray<WIGZCharacter *> *)arrayZCharactersInZone:(WIGZone *)zone
{
    return [[self dictionaryZCharactersInZone:zone] allValues];
}

- (NSDictionary<NSString *, WIGZItem *> *)dictionaryZItemsInInventory
{
    NSMutableDictionary<NSString *, WIGZItem *> *zs = [NSMutableDictionary dictionaryWithCapacity:10];

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

        WIGZItem *item = [[WIGZItem alloc] init];
        [item importFromDict:dict];
        item.luaObject = key;

        [zs setObject:item forKey:key];
    }];

    return zs;
}

- (NSArray<WIGZItem *> *)arrayZItemsInInventory
{
    NSDictionary<NSString *, WIGZItem *> *zones = [self dictionaryZItemsInInventory];
    return [zones allValues];
}

- (WIGZCartridge *)cartridge
{
    NSDictionary *g = [self.ctx globalVar:@"_G"];

    WIGZCartridge *cartridge = [[WIGZCartridge alloc] init];
    [cartridge importFromDict:[g objectForKey:@"cart"]];
    cartridge.luaObject = @"cart";

    return cartridge;
}

- (NSArray<WIGZMedia *> *)arrayZMedias
{
    NSDictionary *g = [self.ctx globalVar:@"_G"];

    NSMutableArray *medias = [NSMutableArray arrayWithCapacity:10];
    [[[g objectForKey:@"cart"] objectForKey:@"AllZMedias"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[dict objectForKey:@"_classname"] isEqualToString:@"ZMedia"] == NO)
            return;
        WIGZMedia *media = [[WIGZMedia alloc] init];
        [media importFromDict:dict];
        [medias addObject:media];
    }];

    return medias;
}

- (WIGZMedia *)zmediaByObjIndex:(NSNumber *)objIndex
{
    NSArray *medias = [self arrayZMedias];
    __block WIGZMedia *media;
    [medias enumerateObjectsUsingBlock:^(WIGZMedia * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([m.objIndex isEqualToNumber:objIndex] == NO)
            return;
        media = m;
        *stop = YES;
    }];
    return media;
}

/*
 * Calls from WIG-link
 */

- (void)WIGOnClick:(NSString *)name
{
    NSString *myScript = [NSString stringWithFormat:@"\
        if %@.OnClick ~= nil then   \
        %@.OnClick()                \
        end                         \
    ", name, name];
    [self runScript:myScript];
}

- (void)WIGMessageBoxCallback:(NSString *)text;
{
    NSString *myScript = [NSString stringWithFormat:LUA_STRING(
        Wherigo._MessageBoxResponse("%@")
    ), text];
    [self runScript:myScript];
}

- (void)WIGGetInputResponse:(NSString *)text
{
    NSString *myScript = [NSString stringWithFormat:LUA_STRING(
        Wherigo._GetInputResponse("%@")
    ), text];
    [self runScript:myScript];
}

@end
