//
//  WIGZMediaResources.h
//  ios
//
//  Created by Edwin Groothuis on 22/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

@interface WIGZMediaResource : NSObject

@property (nonatomic, retain) NSArray<NSString *> *directives;
@property (nonatomic, retain) NSString *filename;
@property (nonatomic, retain) NSString *type;

- (void)importFromDict:(NSDictionary *)dict;

@end
