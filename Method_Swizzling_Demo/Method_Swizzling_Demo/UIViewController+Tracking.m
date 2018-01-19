//
//  UIViewController+Tracking.m
//  Method_Swizzling_Demo
//
//  Created by ECHINACOOP1 on 2018/1/19.
//  Copyright © 2018年 吃面多放葱. All rights reserved.
//

#import "UIViewController+Tracking.h"
#import <objc/runtime.h>

@implementation UIViewController (Tracking)

/**
 实现方法实现替换;
 1.如果没有该方法,先添加该方法到相应类
 2.交换两个方法的方法实现
 3.如果想要替换所有类的 viewViewAppear,选择在使用分类,在 +(load) 方法中实现.
 4.使用单例防止多次交换.
 5.交换后注意调用原来方法实现.
 6.方法名注意区分,避免冲突.
 */
+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = [self class];
        
        Method orginalMethod = class_getInstanceMethod(class, @selector(viewWillAppear:));
        Method SwizzlingMethod = class_getInstanceMethod(class, @selector(xxx_viewWillAppear:));
        
        BOOL didAddMethod = class_addMethod(class, @selector(viewWillAppear:), method_getImplementation(SwizzlingMethod), method_getTypeEncoding(SwizzlingMethod));
        
        if (didAddMethod) {
            class_addMethod(class, @selector(xxx_viewWillAppear:), method_getImplementation(orginalMethod), method_getTypeEncoding(orginalMethod));
        }else{
            method_exchangeImplementations(orginalMethod, SwizzlingMethod);
        }
        
    });
}

- (void)xxx_viewWillAppear:(BOOL)animated{
    [self xxx_viewWillAppear:animated];
    NSLog(@"viewWillAppear:%@",NSStringFromClass([self class]));
}

@end
