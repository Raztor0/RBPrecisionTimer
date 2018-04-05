//
//  RBPrecisionTimer.h
//  RBPrecisionTimer
//
//  Created by Razvan Bangu on 2014-06-24.
//  Copyright (c) 2014 Razvan Bangu. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for RBPrecisionTimer.
FOUNDATION_EXPORT double RBPrecisionTimerVersionNumber;

//! Project version string for RBPrecisionTimer.
FOUNDATION_EXPORT const unsigned char RBPrecisionTimerVersionString[];

@interface RBPrecisionTimer : NSObject

/**
 @param interval The interval of time to wait for.

 @discussion This method blocks for the given amount of time. Upon return, `interval` amount of time will have passed.
 */
+ (void)waitForTimeInterval:(NSTimeInterval)interval;

/**
 @param block The block of code to execute at highest thread priority.

 @discussion This method raises the current thread's priority to the highest possible, executes the block, and restores the original thread's priority.
 */
+ (BOOL)performBlockWithHighPriority:(void (^)(void))block;

/**
 @param interval The amount of time to be scheduled in real time.

 @discussion This method sets the current thread's scheduling to realtime scheduling for `interval` amount of time.
 */
+ (void)setRealtimeSchedulingForTimeInterval:(NSTimeInterval)interval;

@end
