//
//  WIGUI.m
//  ios
//
//  Created by Edwin Groothuis on 22/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WIG.h"

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
    if (b1 == NULL && b2 == NULL)
        [alert addAction:close];

    [[self topMostController] presentViewController:alert animated:YES completion:nil];
}

+ (void)WIGUIShowScreen:(NSString *)screen item:(NSNumber *)item
{
    if ([screen isEqualToString:@"main"] == YES) {
    } else if ([screen isEqualToString:@"inventory"] == YES) {
    } else if ([screen isEqualToString:@"youSee"] == YES) {
    } else if ([screen isEqualToString:@"locations"] == YES) {
    } else if ([screen isEqualToString:@"tasks"] == YES) {
    } else if ([screen isEqualToString:@"detail"] == YES) {
    } else {
        NSAssert(FALSE, @"foo");
    }
}

+ (void)WIGUIPlayAudio:(NSNumber *)media_
{
    WIGZMedia *media = [wig mediaByObjId:media_];
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
