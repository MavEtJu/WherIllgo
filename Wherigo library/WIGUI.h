//
//  WIGUI.h
//  ios
//
//  Created by Edwin Groothuis on 22/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WIGUI : NSObject

+ (void)WIGUIMessageBox:(NSString *)text media:(NSString *)media button1:(NSString *)button1 button2:(NSString *)button2 callback:(BOOL)callback;

@end
