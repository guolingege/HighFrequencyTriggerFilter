//
//  HighFrequencyTriggerFilter.h
//  DelayDemo
//
//  Created by 孙国林 on 2017/4/26.
//  Copyright © 2017年 孙国林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HighFrequencyTriggerFilter : NSObject

/**
 无论是触发成功还是最后取消掉，该对象都会失效，需要重新创建

 @param delayTime 缓冲时间
 @param triggerHandler 成功触发后调用的block
 @return 返回可操作的对象
 */
+ (instancetype)filterWithDelayTime:(NSTimeInterval)delayTime triggerHandler:(void(^)())triggerHandler;

/**
 触发
 */
- (void)trigger;
/**
 取消
 */
- (void)cancel;

@end
