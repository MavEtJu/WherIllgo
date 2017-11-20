//
//  main.m
//  luatest
//
//  Created by Edwin Groothuis on 20/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LuaContext.h"

static NSString *const myScript =
LUA_STRING(
           globalVar = { 0.0, 1.0 }

           function myFunction(parameter)
           return parameter >= globalVar[1] and parameter <= globalVar[2]
           end
           );

void doLua1(void)
{
    LuaContext *ctx = [LuaContext new];
    NSError *error = nil;
    if( ! [ctx parse:myScript error:&error] ) {
        NSLog(@"Error parsing lua script: %@", error);
        return;
    }

    NSLog(@"globalVar is: %@", ctx[@"globalVar"]); // should print "globalVar is: [ 0.0, 1.0 ]"

    id result = [ctx call:"myFunction" with:@[ @0.5 ] error:&error];
    if( error ) {
        NSLog(@"Error calling myFunction: %@", error);
        return;
    }
    NSLog(@"myFunction returned: %@", result); // should print "myFunction returned: '1'"

    ctx[@"globalVar"] = @[ @0.2, @0.4 ];
    id foo = ctx[@"_G"];

    result = [ctx call:"myFunction" with:@[ @0.5 ] error:&error];
    if( error ) {
        NSLog(@"Error calling myFunction: %@", error);
        return;
    }
    NSLog(@"myFunction returned: %@", result); // should print "myFunction returned: '0'"
}

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

void doLua3(void)
{
    LuaContext *ctx = [LuaContext new];
    NSError *error = nil;
    NSString *myScript = LUA_STRING(
        cart = dofile("testsuite.lua")
    );
    [ctx parse:myScript error:&error];
    if (error != nil) {
        NSLog(@"Error parsing lua code: %@", error);
        return;
    }
//    id ii = ctx[@"_G"];

    id result = [ctx call:"objWherigoTestsuiteEN:OnStart" with:@[ @0.5 ] error:&error];
    if( error ) {
        NSLog(@"Error calling OnStart: %@", error);
        return;
    }
    NSLog(@"myFunction returned: %@", result); // should print "myFunction returned: '1'"
}

void doLua0(void)
{
    LuaContext *ctx = [LuaContext new];
    NSError *error = nil;
    NSURL *url = [NSURL fileURLWithPath:@"ohm.luac"];
    if( ! [ctx parseURL:url error:&error] ) {
        NSLog(@"Error parsing lua script: %@", error);
        return;
    }
}

void doLua2(void)
{
    LuaContext *ctx = [LuaContext new];
    NSError *error = nil;
    NSURL *url = [NSURL fileURLWithPath:@"testsuite.lua"];
    if( ! [ctx parseURL:url error:&error] ) {
        NSLog(@"Error parsing lua script: %@", error);
        return;
    }

    NSLog(@"foo");
    id foo = ctx[@"_G"];
    NSLog(@"bar");

    id result = [ctx call:"objWherigoTestsuiteEN:OnStart()" with:@[ @0.5 ] error:&error];
    if( error ) {
        NSLog(@"Error calling OnStart: %@", error);
        return;
    }
    NSLog(@"myFunction returned: %@", result); // should print "myFunction returned: '1'"

    ctx[@"globalVar"] = @[ @0.2, @0.4 ];

    result = [ctx call:"myFunction" with:@[ @0.5 ] error:&error];
    if( error ) {
        NSLog(@"Error calling myFunction: %@", error);
        return;
    }
    NSLog(@"myFunction returned: %@", result); // should print "myFunction returned: '0'"
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        doLua4();
    }
    return 0;
}
