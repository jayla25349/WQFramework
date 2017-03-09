//
//  UIViewController+WQ.m
//  GameHelper
//
//  Created by 青秀斌 on 16/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "UIViewController+WQ.h"
#import <objc/runtime.h>

@implementation UIViewController (WQ)

#ifdef DEBUG

+ (void)load {
    Method originalMethod = class_getInstanceMethod(self, @selector(viewDidLoad));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(sw_viewDidLoad));
    method_exchangeImplementations(originalMethod, swizzledMethod);
    
    originalMethod = class_getInstanceMethod(self, NSSelectorFromString(@"dealloc"));
    swizzledMethod = class_getInstanceMethod(self, @selector(sw_dealloc));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)sw_dealloc {
    NSLog(@"页面已释放--->:%@", self);
    [self sw_dealloc];
}

- (void)sw_viewDidLoad {
    NSLog(@"进入页面--->:%@", self);
    [self sw_viewDidLoad];
}

#endif

@end
