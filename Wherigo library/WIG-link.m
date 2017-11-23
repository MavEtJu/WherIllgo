//
//  WIG-link.c
//  luatest
//
//  Created by Edwin Groothuis on 20/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#include "WIG.h"

void WIGMessageBoxCallback(void)
{
    [wig messageBoxCallback];
}

void WIGUIMessageBox(const char *text_, const char *media_, const char *button1_, const char *button2_, const char *callback_)
{
    NSString *text = [NSString stringWithUTF8String:text_];
    NSString *media = [NSString stringWithUTF8String:media_];
    NSString *button1 = button1_[0] == 0 ? nil : [NSString stringWithUTF8String:button1_];
    NSString *button2 = button2_[0] == 0 ? nil : [NSString stringWithUTF8String:button2_];
    BOOL callback = strcmp(callback_, "0") == 0 ? 0 : 1;
    [WIGUI WIGUIMessageBox:text media:media button1:button1 button2:button2 callback:callback];
}
