//
//  WIGUI.h
//  ios
//
//  Created by Edwin Groothuis on 22/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

@interface WIGUI : NSObject <AVAudioPlayerDelegate>

+ (void)WIGUIMessageBox:(NSString *)text media:(NSNumber *)media button1:(NSString *)button1 button2:(NSString *)button2 callback:(BOOL)callback;
+ (void)WIGUIShowScreen:(NSString *)screen item:(NSNumber *)item;
+ (void)WIGUIPlayAudio:(NSNumber *)media;
+ (void)WIGUIStopSound;
+ (void)WIGUIGetInput:(NSString *)inputType text:(NSString *)text options:(NSString *)o media:(NSNumber *)media;

@end
