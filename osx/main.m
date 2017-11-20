//
//  main.m
//  luatest
//
//  Created by Edwin Groothuis on 20/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WIG.h"

WIG *wig = nil;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");

        wig = [[WIG alloc] init];
        [wig run:@"testsuite.lua"];
    }
    return 0;
}
