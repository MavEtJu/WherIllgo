//
//  WIGZInput.h
//  ios
//
//  Created by Edwin Groothuis on 25/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

@interface WIGZInput : WIGZObject

/*

 Choices     Table.
        Table with the different strings for multiple choices inputs.
 InputType     String.
        The type of input. Could be "Text" or "MultipleChoice".
 Text     String.
        Description of the input. Shown as text above or below the entry field.
 */

@property (nonatomic, retain) NSArray<NSString *> *choices;
@property (nonatomic, retain) NSString *inputType;
@property (nonatomic, retain) NSString *text;

@end
