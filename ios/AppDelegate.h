//
//  AppDelegate.h
//  ios
//
//  Created by Edwin Groothuis on 21/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

@interface AppDelegate : UIResponder <UIApplicationDelegate>

enum {
    TABBAR_INVENTORY,
    TABBAR_YOUSEE,
    TABBAR_LOCATIONS,
    TABBAR_TASKS,
    TABBAR_MAP,
    TABBAR_MAX,

    TABBAR_MAIN = TABBAR_MAP,
};

@property (strong, nonatomic) UIWindow *window;

@end

