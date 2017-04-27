曾经遇到过这样的问题：
调用定位功能，该对象获得位置信息后代理会通知你经纬度。该代理在开始的时候会在很短的时间内被调用两次。我在代理里做了一些操作，如果高频率调用的话，例如0.1秒内2次，就会不正常。这时候我想通过某种机制来过滤多余的部分，只接收最后一次调用。当时没想出办法，现在想出来了，写成了一个类，有点类似NSTimer，取名叫HighFrequencyTriggerFilter，以下是用法：
```Objective-C
@implementation ViewController {
    HighFrequencyTriggerFilter *filter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    filter = [HighFrequencyTriggerFilter filterWithDelayTime:2 triggerHandler:^{
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"aaa" message:@"df233ew34f" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [ac addAction:confirmAction];
        [self presentViewController:ac animated:YES completion:nil];
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"show" style:UIBarButtonItemStyleDone target:self action:@selector(show)];
}

- (void)show {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int ii = 0; ii < 6; ii++) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [filter trigger];
            });
            [NSThread sleepForTimeInterval:1.2];
        }
    });
}
```
