曾经遇到过这样的问题：
调用定位功能，该对象获得位置信息后代理会通知你经纬度。该代理在开始的时候会在很短的时间内被调用两次。我在代理里做了一些操作，如果高频率调用的话，例如0.1秒内2次，就会不正常。这时候我想通过某种机制来过滤多余的部分，只接收最后一次调用。当时没想出办法，现在想出来了，写成了一个类，有点类似NSTimer，取名叫HighFrequencyTriggerFilter，附上代码，头文件：
```Objective-C
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
```

执行文件：
```Objective-C
#import "HighFrequencyTriggerFilter.h"

@interface HighFrequencyTriggerFilter ()

@property (nonatomic, assign) NSTimeInterval delayTime;
@property (nonatomic, copy) void (^triggerHandler)();
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation HighFrequencyTriggerFilter

+ (instancetype)filterWithDelayTime:(NSTimeInterval)delayTime triggerHandler:(void(^)())triggerHandler {
    HighFrequencyTriggerFilter *filter = [HighFrequencyTriggerFilter new];
    filter.delayTime = delayTime;
    filter.triggerHandler = triggerHandler;
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
    [self cancel];
}

- (void)cancel {
    [self.timer invalidate];
    self.timer = nil;
    self.triggerHandler = nil;
}

@end
```
