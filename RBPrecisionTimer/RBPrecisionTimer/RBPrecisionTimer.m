//
//  RBPrecisionTimer.m
//  Razio
//
//  Created by Razvan Bangu on 2014-06-24.
//  Copyright (c) 2014 Razvan Bangu. All rights reserved.
//

#import "RBPrecisionTimer.h"
#include <mach/mach.h>
#include <mach/mach_time.h>
#include <pthread.h>

static mach_timebase_info_data_t timebase_info;
static int original_priority = -1;

@implementation RBPrecisionTimer

+ (void)waitForTimeInterval:(NSTimeInterval)interval {
    if (interval <= 0) {
        /* Return immediately for negative durations */
        return;
    }
    mach_timebase_info(&timebase_info);
    uint64_t time_to_wait = [self nanos_to_abs:(interval * NSEC_PER_SEC)];
    uint64_t now = mach_absolute_time();
    mach_wait_until(now + time_to_wait);
}

+ (BOOL)performBlockWithHighPriority:(void (^)(void))block {
    int resultRaise = [self raise_thread_priority];
    block();
    int resultRestore = [self restore_original_thread_priority];
    return resultRaise && resultRestore;
}

+ (void)setRealtimeSchedulingForTimeInterval:(NSTimeInterval)interval {
    mach_timebase_info_data_t info;
    mach_timebase_info(&info);
    uint32_t hzms = (uint32_t)((uint64_t)1000000 * info.denom / info.numer);
    
    struct thread_time_constraint_policy policy;
    
    policy.period = interval * hzms;
    policy.computation = interval * hzms;
    policy.constraint = policy.period;
    policy.preemptible = true;
    
    int ret;
    if((ret = thread_policy_set(mach_thread_self(), THREAD_TIME_CONSTRAINT_POLICY, (thread_policy_t)&policy, THREAD_TIME_CONSTRAINT_POLICY_COUNT)) != KERN_SUCCESS) {
        NSLog(@"Setting thread to realtime failed");
    } else {
        NSLog(@"Setting thread to realtime succeeded");
    }
}

#pragma mark -
#pragma mark - Private methods
#pragma mark -

+ (int)raise_thread_priority {
    return [self set_my_thread_priority:99];
}

+ (int)restore_original_thread_priority {
    return [self set_my_thread_priority:original_priority];
}

+ (uint64_t)nanos_to_abs:(uint64_t)nanos {
    return nanos * timebase_info.denom / timebase_info.numer;
}

#pragma mark - Thread priorities

+ (int)set_my_thread_priority:(int)priority {
    if(original_priority == -1) {
        [self save_original_thread_priority];
    }
    
    struct sched_param newSchedParam;
    
    memset(&newSchedParam, 0, sizeof(struct sched_param));
    newSchedParam.sched_priority = priority;
    if (pthread_setschedparam(pthread_self(), SCHED_RR, &newSchedParam)  == -1) {
        NSLog(@"Failed to change thread priority");
        return -1;
    }
    
    return 0;
}

+ (void)save_original_thread_priority {
    struct sched_param currentSchedParam;
    int policy;
    pthread_getschedparam(pthread_self(), &policy, &currentSchedParam);
    original_priority = currentSchedParam.sched_priority;
}

+ (int)get_current_thread_priority {
    struct sched_param currentSchedParam;
    int policy;
    pthread_getschedparam(pthread_self(), &policy, &currentSchedParam);
    return currentSchedParam.sched_priority;
}

@end
