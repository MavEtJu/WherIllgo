//
//  WIG-link.c
//  luatest
//
//  Created by Edwin Groothuis on 20/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#include "WIG-link.h"
#include "WIG.h"

void WIGMessageBoxCallback(void)
{
    [wig messageBoxCallback];
}
