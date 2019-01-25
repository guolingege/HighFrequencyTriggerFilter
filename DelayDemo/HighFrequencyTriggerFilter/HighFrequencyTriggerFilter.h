//
//  HighFrequencyTriggerFilter.h
//  DelayDemo
//
//  Created by 孙国林 on 2017/4/26.
//  Copyright © 2017年 孙国林. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HighFrequencyTriggerFilterDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface HighFrequencyTriggerFilter : NSObject

@property (nonatomic, weak) id<HighFrequencyTriggerFilterDelegate> _Nullable delegate;

/**
 无论是触发成功还是最后取消掉，该对象都会失效，需要重新创建
 
 @param delayTime 缓冲时间
 @param triggerHandler 成功触发后调用的block
 @return 返回可操作的对象
 */
+ (instancetype)filterWithDelayTime:(NSTimeInterval)delayTime triggerHandler:(void(^ _Nullable)())triggerHandler;
+ (instancetype)filterWithDelayTime:(NSTimeInterval)delayTime delegate:(id<HighFrequencyTriggerFilterDelegate>)delegate;

/**
 触发
 */
- (void)trigger;
/**
 取消
 */
- (void)cancel;

@end

@protocol HighFrequencyTriggerFilterDelegate <NSObject>

@optional
- (void)highFrequencyTriggerFilterFired:(HighFrequencyTriggerFilter *)filter;

@end

NS_ASSUME_NONNULL_END
