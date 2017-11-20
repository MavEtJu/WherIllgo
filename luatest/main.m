//
//  main.m
//  luatest
//
//  Created by Edwin Groothuis on 20/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LuaContext.h"

void runLua4(LuaContext *ctx, NSString *myScript)
{
    NSError *error = nil;
    [ctx parse:myScript error:&error];
    if (error != nil) {
        NSLog(@"Error parsing lua code: %@", error);
        return;
    }
}

void doLua4(void)
{
    LuaContext *ctx = [LuaContext new];
    NSError *error = nil;

    NSString *myScript = LUA_STRING(
        f = loadfile("testsuite.lua")
        cart = f()
        -- cart = dofile("testsuite.lua")
    );
    [ctx parse:myScript error:&error];
    if (error != nil) {
        NSLog(@"Error parsing lua code: %@", error);
        return;
    }
    id _G = ctx[@"_G"];
//    id cart = ctx[@"cart"];

    myScript = LUA_STRING(
        cart.Contains()
        cart.OnStart()
        Wherigo._MBCallback(1)
        print("AllZObjects", #cart.AllZObjects)
        print("AllZCharacters", #cart.AllZCharacters)
        print("AllZItems", #cart.AllZItems)
        print("AllZones", #cart.AllZones)
        print("AllZTimers", #cart.AllZTimers)
        print("AllZTasks", #cart.AllZTasks)
        print("AllZMedias", #cart.AllZMedias)
        print("AllZInputs", #cart.AllZInputs)
    );

    runLua4(ctx, myScript);

    myScript = LUA_STRING(
        objTaskOnclick:OnClick()
    );
    runLua4(ctx, myScript);
}

WIG *wig = nil;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");

        wig = [[WIG alloc] init:@"testsuite.lua"];

        doLua4();
    }
    return 0;
}
