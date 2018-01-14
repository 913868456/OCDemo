//
//  ViewController.m
//  GCD_Demo
//
//  Created by ECHINACOOP1 on 2018/1/14.
//  Copyright © 2018年 蔺国防. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic)dispatch_source_t timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     
     GCD(全称 Grand Central Dispatch),主要是用来管理线程和任务之间的底层C语言API.
     主要目的是为了让我们从繁杂的手动线程管理中解放出来,用更多的精力去处理任务代码.
     
     */
    
    //GCD单例
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //single instance
    });
    
    //GCD定时器 (注意定时器需要持有一下,否则创建的定时器出了作用域就会释放)
    [self timerDemo];
    
    //延时执行
    [self delayDemo];

    //串行队列同步执行任务 (在串行队列中,添加同步任务到该队列,运行时会造成死锁)
//    [self serial_sync_task];

    //串行队列异步执行任务
    [self serial_async_task];

    //并发队列同步执行任务
    [self concurrent_sync_task];

    //并发队列异步执行任务
    [self concurrent_async_task];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)timerDemo{
    
    __block int i = 0;
    dispatch_queue_t queue= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    self.timer = timer;
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        //code to be executed when timer fires
        NSLog(@"%@",[NSThread currentThread]);
        NSLog(@"%d",i++);
    });
    dispatch_resume(timer);
}

- (void)delayDemo{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //code to be executed after a specified delay
        NSLog(@"%@",[NSThread currentThread]);
        NSLog(@"5秒后执行");
    });
}

- (void)serial_sync_task{
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        //code to be executed
    });
}

- (void)serial_async_task{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //code to be executed
        NSLog(@"%@",[NSThread currentThread]);
    });
}

- (void)concurrent_sync_task{
    
    dispatch_queue_t queue= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^{
        //code to be executed
        NSLog(@"%@",[NSThread currentThread]);
    });
}

- (void)concurrent_async_task{
    
    dispatch_queue_t queue= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        //code to be executed
        NSLog(@"%@",[NSThread currentThread]);
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
