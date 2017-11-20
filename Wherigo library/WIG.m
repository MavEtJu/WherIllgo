//
//  WIG.m
//  luatest
//
//  Created by Edwin Groothuis on 20/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "WIG.h"

#import "LuaContext.h"

@interface WIG ()

@property (nonatomic, retain) LuaContext *ctx;
@property (nonatomic, retain) NSDictionary *G_;
@property (nonatomic, retain) NSDictionary *cart;

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
    NSLog(@"G_");
    self.G_ = [self.ctx globalVar:@"_G"];
    NSLog(@"cart");
    self.cart = [self.ctx globalVar:@"cart"];
    NSLog(@"---");

    myScript = LUA_STRING(
        cart.OnStart()
    );
    [self runScript:myScript];

//    myScript = LUA_STRING(
//        objTaskOnclick:OnClick()
//    );
//    [self runScript:myScript];
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

- (void)messageBoxCallback
{
    NSString *myScript = LUA_STRING(
        -- for k,v in pairs(Wherigo) do
        --     print(k, v)
        -- end
        Wherigo._MessageBoxResponse(1)
    );
    [self runScript:myScript];
}

@end
