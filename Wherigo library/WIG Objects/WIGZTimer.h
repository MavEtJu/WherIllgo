//
//  WIGZTimer.h
//  ios
//
//  Created by Edwin Groothuis on 25/11/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

@interface WIGZTimer : WIGZObject

/*
 Duration     Number.
        Number of seconds until the timer expires.
 Remaining     Number.
        Number of seconds until the timer expires.
 Running     Boolean.
        If the timer is running or not.
 StartTime     Time.
        Time when the timer has started.
 Type     String.
        Type of the timer. Could be "Interval" or "Countdown".
 */

@property (nonatomic, retain) NSNumber *duration;
@property (nonatomic, retain) NSNumber *remaining;
@property (nonatomic        ) BOOL *running;
@property (nonatomic, retain) NSNumber *startTime;
@property (nonatomic, retain) NSString *type;

@end
