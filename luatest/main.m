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

void doLua(void)
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

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        doLua();
    }
    return 0;
}
