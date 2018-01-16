//
//  ViewController.m
//  Runtime_Demo
//
//  Created by ECHINACOOP1 on 2018/1/16.
//  Copyright © 2018年 吃面多放葱. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "MyClass.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //判断两个对象是否完全相等
    NSLog(@"%d",[self isEqual:[UIViewController class]]);
    NSLog(@"%d",[self isEqual:[ViewController class]]);
    NSLog(@"%d",[self isEqual:self]);
    
    //判断一个对象的类型是否是某个类型或者其继承的类类型
    NSLog(@"%d",[self isKindOfClass: [UIViewController class]]);
    NSLog(@"%d",[self isKindOfClass: [ViewController class]]);
    
    //判断一个对象是否是某个类的成员变量
    NSLog(@"%d",[self isMemberOfClass: [UIViewController class]]);
    NSLog(@"%d",[self isMemberOfClass:[ViewController class]]);
    
    //测试动态添加实例方法和类方法
    [self testInstanceMethod];
    [ViewController testClassMethod];
    
    //消息转发
    [self testForwardInvocation];
    
    // Do any additional setup after loading the view, typically from a nib.
}

void dynamicResolveInstanceMethodIMP(id self, SEL _cmd){
    
    NSLog(@"这是动态实现的实例方法");
}

void dynamicResolveClassMethodIMP(id ViewController, SEL _cmd){
    
    NSLog(@"这是动态实现的类方法");
}

+ (BOOL)resolveInstanceMethod:(SEL)sel{
    
    if (sel == @selector(testInstanceMethod)) {
        class_addMethod([self class], sel, (IMP)dynamicResolveInstanceMethodIMP, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

+ (BOOL)resolveClassMethod:(SEL)sel{
    
    if (sel == @selector(testClassMethod)) {
        class_addMethod(object_getClass(self), sel, (IMP)dynamicResolveClassMethodIMP, "v@:");
        return YES;
    }
    return [super resolveClassMethod:sel];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    
    MyClass *object = [[MyClass alloc] init];
    if ([object respondsToSelector:[anInvocation selector]] ) {
        
        [anInvocation invokeWithTarget:object];
    }else{
        [super forwardInvocation:anInvocation];
    }
}

-(NSMethodSignature*)methodSignatureForSelector:(SEL)selector{
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    
    //生成方法签名
    if (! signature)
    {
        //处理不同的方法
        if (sel_isEqual(selector, @selector(testForwardInvocation)))
        {
            signature = [[[MyClass alloc] init] methodSignatureForSelector:selector];
        }
    }
    return signature;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
