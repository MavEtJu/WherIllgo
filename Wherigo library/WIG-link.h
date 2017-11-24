//
//  WIG-link.h
//  luatest
//
//  Created by Edwin Groothuis on 20/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#ifndef WIG_link_h
#define WIG_link_h

#include <stdio.h>

void WIGUIMessageBox(const char *text, const char *media, const char *button1, const char *button2, const char *callback);
void WIGMessageBoxCallback(void);
void WIGUIShowScreen(const char *screen, const char *item);
void WIGUIPlayAudio(const char *media);
void WIGUIStopSound(void);

#endif /* WIG_link_h */
