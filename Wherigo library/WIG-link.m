//
//  WIG-link.c
//  luatest
//
//  Created by Edwin Groothuis on 20/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#include "WIG.h"

void WIGUIMessageBox(const char *text_, const char *media_, const char *button1_, const char *button2_, const char *callback_)
{
    NSString *text = [NSString stringWithUTF8String:text_];
    NSNumber *media = [NSNumber numberWithInteger:[[NSString stringWithUTF8String:media_] integerValue]];
    NSString *button1 = button1_[0] == 0 ? nil : [NSString stringWithUTF8String:button1_];
    NSString *button2 = button2_[0] == 0 ? nil : [NSString stringWithUTF8String:button2_];
    BOOL callback = strcmp(callback_, "0") == 0 ? 0 : 1;
    [WIGUI WIGUIMessageBox:text media:media button1:button1 button2:button2 callback:callback];
}

void WIGUIShowScreen(const char *screen_, const char *item_)
{
    NSString *screen = [NSString stringWithUTF8String:screen_];
    NSNumber *item = [NSNumber numberWithInteger:[[NSString stringWithUTF8String:item_] integerValue]];

    [WIGUI WIGUIShowScreen:screen item:item];
}

void WIGUIPlayAudio(const char *media_)
{
    NSNumber *media = [NSNumber numberWithInteger:[[NSString stringWithUTF8String:media_] integerValue]];

    [WIGUI WIGUIPlayAudio:media];
}

void WIGUIStopSound(void)
{
    [WIGUI WIGUIStopSound];

}

void WIGUIGetInput(const char *inputType_, const char *text_, const char *o_, const char *media_)
{
    NSString *inputType = [NSString stringWithUTF8String:inputType_];
    NSString *text = [NSString stringWithUTF8String:text_];
    NSString *o = [NSString stringWithUTF8String:o_];
    NSString *media = [NSString stringWithUTF8String:media_];
    [WIGUI WIGUIGetInput:inputType text:text options:o media:media];
    printf("Foo\n");
}
