//
//  WIGZCommand.h
//  ios
//
//  Created by Edwin Groothuis on 22/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

@interface WIGZCommand : WIGZObject

/*
 Text     String.
        Label of the button.
 CmdWith     Boolean.
        True if you can choose a target for this command, false if the command script is started right away.
 Custom     Boolean.
        no idea what it means, but it seems to be set to True on all commands.
 Enabled     Boolean.
        Whether the user can see (and invoke) the command.
 EmptyTargetListText     String.
        Text that is displayed when the command is intended to be used with a target (CmdWith is true), but no suitable targets are visible.
 MakeReciprocal     Boolean.
        Only applies when CmdWith is true. When true, this command is automatically listed not only on the item/character where it's defined, but also on all items/characters that can be its targets. There it is listed as ZReciprocalCommand. (This is the default.) When false, the command is only listed on the item/character where it's defined.
 WorksWithAll     Boolean.
        Whether every object is a target for this command. Only applies when CmdWith is true.
 WorksWithList     Table.
        A list of ZCharacters and ZItems that are valid targets for this command. Only applies when CmdWith is true.
 */

@property (nonatomic, retain) NSString *text;
@property (nonatomic        ) BOOL cmdwith;
@property (nonatomic        ) BOOL custom;
@property (nonatomic        ) BOOL enabled;
@property (nonatomic, retain) NSString *emptyTargetListText;
@property (nonatomic        ) BOOL makeReciprocal;
@property (nonatomic        ) BOOL worksWithAll;
@property (nonatomic, retain) NSArray<WIGZObject *> *worksWithList;

@end
