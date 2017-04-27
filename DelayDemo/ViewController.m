//
//  ViewController.m
//  DelayDemo
//
//  Created by 孙国林 on 2017/4/26.
//  Copyright © 2017年 孙国林. All rights reserved.
//

#import "ViewController.h"
#import "HighFrequencyTriggerFilter.h"

@interface ViewController ()

@end

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
