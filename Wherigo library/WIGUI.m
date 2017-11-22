//
//  WIGUI.m
//  ios
//
//  Created by Edwin Groothuis on 22/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WIG.h"
#import "WIGUI.h"

@implementation WIGUI

+ (UIViewController *)topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;

    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }

    return topController;
}

+ (void)WIGUIMessageBox:(NSString *)text media:(NSString *)media button1:(NSString *)button1 button2:(NSString *)button2 callback:(BOOL)callback
{
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Message!"
                                message:text
                                preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *close = [UIAlertAction
                            actionWithTitle:@"Close"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction *action) {
                                [alert dismissViewControllerAnimated:YES completion:nil];
                                if (callback == YES)
                                    [wig messageBoxCallback];
                            }];

    UIAlertAction *b1 = nil;
    UIAlertAction *b2 = nil;

    if (button1 != nil)
        b1 = [UIAlertAction
              actionWithTitle:button1
              style:UIAlertActionStyleDefault
              handler:^(UIAlertAction *action) {
                  [alert dismissViewControllerAnimated:YES completion:nil];
                  if (callback == YES)
                      [wig messageBoxCallback];
              }];
    if (button2 != nil)
        b2 = [UIAlertAction
              actionWithTitle:button2
              style:UIAlertActionStyleDefault
              handler:^(UIAlertAction *action) {
                  [alert dismissViewControllerAnimated:YES completion:nil];
                  if (callback == YES)
                      [wig messageBoxCallback];
              }];

    if (b1 != NULL)
        [alert addAction:b1];
    if (b2 != NULL)
        [alert addAction:b2];
    [alert addAction:close];

    [[self topMostController] presentViewController:alert animated:YES completion:nil];
}

@end
