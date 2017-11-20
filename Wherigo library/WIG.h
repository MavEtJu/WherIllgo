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

- (void)messageBoxCallback;

@end

extern WIG *wig;
