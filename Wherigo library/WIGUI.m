//
//  WIGUI.m
//  ios
//
//  Created by Edwin Groothuis on 22/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import "main.h"

@interface WIGUI ()

@end

@implementation WIGUI

+ (UIViewController *)topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;

    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }

    return topController;
}

+ (void)WIGUIMessageBox:(NSString *)text media:(NSNumber *)media button1:(NSString *)button1 button2:(NSString *)button2 callback:(BOOL)callback
{
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Message"
                                message:text
                                preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *close = [UIAlertAction
                            actionWithTitle:@"Close"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction *action) {
                                [alert dismissViewControllerAnimated:YES completion:nil];
                                if (callback == YES)
                                    [wig WIGMessageBoxCallback:@"Ok"];
                            }];

    if (media != nil && [media isEqualToNumber:[NSNumber numberWithInteger:0]] == NO) {
        UIAlertAction *image = [UIAlertAction
                                actionWithTitle:@""
                                style:UIAlertActionStyleDefault
                                handler:nil
                                ];
        WIGZMedia *m = [wig zmediaByObjIndex:media];
        WIGZMediaResource *resource = [m.resources firstObject];

        image.enabled = NO;
        [image setValue:[[UIImage imageNamed:resource.filename] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
        [alert addAction:image];
    }

    UIAlertAction *b1 = nil;
    UIAlertAction *b2 = nil;

    if (button1 != nil)
        b1 = [UIAlertAction
              actionWithTitle:button1
              style:UIAlertActionStyleDefault
              handler:^(UIAlertAction *action) {
                  [alert dismissViewControllerAnimated:YES completion:nil];
                  if (callback == YES)
                      [wig WIGMessageBoxCallback:@"Button1"];
              }];
    if (button2 != nil)
        b2 = [UIAlertAction
              actionWithTitle:button2
              style:UIAlertActionStyleDefault
              handler:^(UIAlertAction *action) {
                  [alert dismissViewControllerAnimated:YES completion:nil];
                  if (callback == YES)
                      [wig WIGMessageBoxCallback:@"Button2"];
              }];

    if (b1 != NULL)
        [alert addAction:b1];
    if (b2 != NULL)
        [alert addAction:b2];
    if (b1 == NULL && b2 == NULL)
        [alert addAction:close];

    [[self topMostController] presentViewController:alert animated:YES completion:nil];
}

+ (void)WIGUIGetInput:(NSString *)inputType text:(NSString *)text options:(NSString *)o media:(NSNumber *)media
{
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Input"
                                message:text
                                preferredStyle:UIAlertControllerStyleAlert];

    if (media != nil && [media isEqualToNumber:[NSNumber numberWithInteger:0]] == NO) {
        UIAlertAction *image = [UIAlertAction
                                actionWithTitle:@""
                                style:UIAlertActionStyleDefault
                                handler:nil
                                ];
        WIGZMedia *m = [wig zmediaByObjIndex:media];
        WIGZMediaResource *resource = [m.resources firstObject];

        image.enabled = NO;
        [image setValue:[[UIImage imageNamed:resource.filename] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
        [alert addAction:image];
    }

    if ([inputType isEqualToString:@"Text"] == YES) {
        UIAlertAction *submit = [UIAlertAction
                                 actionWithTitle:@"Submit"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction *action) {
                                     UITextField *tf = alert.textFields.firstObject;
                                     NSString *text = tf.text;
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     [wig WIGGetInputResponse:text];
                                 }];
        [alert addAction:submit];

        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Enter your text here";
        }];
    }

    if ([inputType isEqualToString:@"MultipleChoice"] == YES) {
        [[o componentsSeparatedByString:@";"] enumerateObjectsUsingBlock:^(NSString * _Nonnull choice, NSUInteger idx, BOOL * _Nonnull stop) {
            UIAlertAction *button = [UIAlertAction
                                     actionWithTitle:choice
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action) {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         [wig WIGGetInputResponse:choice];
                                     }];
            [alert addAction:button];
        }];
    }

    [[self topMostController] presentViewController:alert animated:YES completion:nil];
}

+ (void)WIGUIShowScreen:(NSString *)screen item:(NSNumber *)item
{
    if ([screen isEqualToString:@"main"] == YES) {
        // There is no main screen as it's all tabbed.
        tbc.selectedIndex = TABBAR_MAIN;
    } else if ([screen isEqualToString:@"inventory"] == YES) {
        tbc.selectedIndex = TABBAR_INVENTORY;
        while ([inventoryViewController.navigationController popViewControllerAnimated:NO] != nil)
            ;
    } else if ([screen isEqualToString:@"youSee"] == YES) {
        tbc.selectedIndex = TABBAR_YOUSEE;
        while ([youSeesViewController.navigationController popViewControllerAnimated:NO] != nil)
            ;
    } else if ([screen isEqualToString:@"locations"] == YES) {
        tbc.selectedIndex = TABBAR_LOCATIONS;
        while ([locationsViewController.navigationController popViewControllerAnimated:NO] != nil)
            ;
    } else if ([screen isEqualToString:@"tasks"] == YES) {
        tbc.selectedIndex = TABBAR_TASKS;
        while ([tasksViewController.navigationController popViewControllerAnimated:NO] != nil)
            ;
    } else if ([screen isEqualToString:@"detail"] == YES) {
        tbc.selectedIndex = TABBAR_YOUSEE;
        while ([inventoryViewController.navigationController popViewControllerAnimated:NO] != nil)
            ;
        // Do something with item
        WIGZItem *i = [wig zitemByObjectId:item];

        ItemViewController *newController = [[ItemViewController alloc] init];
        newController.title = @"Item";
        newController.item = i;
        [youSeesViewController.navigationController pushViewController:newController animated:YES];

        [wig WIGOnClick:i.luaObject];
    } else {
        NSAssert(FALSE, @"foo");
    }
}

+ (void)WIGUIPlayAudio:(NSNumber *)media_
{
    WIGZMedia *media = [wig zmediaByObjIndex:media_];
    WIGZMediaResource *resource = [media.resources objectAtIndex:0];

    /* Crappy way to do sound but will work for now */

    NSError *error = nil;
    NSURL *soundURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], resource.filename]];
    wig.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    if (error != nil) {
        NSLog(@"AVAudioPlayer: %@ - %@", soundURL, error);
        return;
    }
    if ([wig.audioPlayer play] == NO) {
        NSLog(@"AVAudioPlayer: failed on %@", soundURL);
        return;
    }
}

+ (void)WIGUIStopSound
{
    [wig.audioPlayer stop];
}

@end
