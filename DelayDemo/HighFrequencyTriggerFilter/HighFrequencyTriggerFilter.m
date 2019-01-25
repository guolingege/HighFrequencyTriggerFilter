//
//  HighFrequencyTriggerFilter.m
//  DelayDemo
//
//  Created by 孙国林 on 2017/4/26.
//  Copyright © 2017年 孙国林. All rights reserved.
//

#import "HighFrequencyTriggerFilter.h"

@interface HighFrequencyTriggerFilter ()

@property (nonatomic, assign) NSTimeInterval delayTime;
@property (nonatomic, copy) void (^triggerHandler)();
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL repeats;

@end

@implementation HighFrequencyTriggerFilter

+ (instancetype)filterWithDelayTime:(NSTimeInterval)delayTime triggerHandler:(void(^)())triggerHandler {
    HighFrequencyTriggerFilter *filter = [HighFrequencyTriggerFilter new];
    filter.delayTime = delayTime;
    filter.triggerHandler = triggerHandler;
    filter.repeats = true;
    return filter;
}

+ (instancetype)filterWithDelayTime:(NSTimeInterval)delayTime delegate:(id<HighFrequencyTriggerFilterDelegate>)delegate {
    HighFrequencyTriggerFilter *filter = [HighFrequencyTriggerFilter new];
    filter.delayTime = delayTime;
    filter.delegate = delegate;
    filter.repeats = true;
    return filter;
}

- (void)trigger {
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.delayTime target:self selector:@selector(delayTrigger) userInfo:nil repeats:NO];
}

- (void)delayTrigger {
    if (self.triggerHandler) {
        self.triggerHandler();
    }
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(highFrequencyTriggerFilterFired:)]) {
            [self.delegate highFrequencyTriggerFilterFired:self];
        }
    }
    if (!self.repeats) {
        [self cancel];
    }
}

- (void)cancel {
    [self.timer invalidate];
    self.timer = nil;
    self.triggerHandler = nil;
}

@end
