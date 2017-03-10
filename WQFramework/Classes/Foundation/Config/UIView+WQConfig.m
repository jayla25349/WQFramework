//
//  UIView+WQConfig.m
//  GameHelper
//
//  Created by 青秀斌 on 16/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "UIView+WQConfig.h"
#import "WQConfigManager.h"
#import <objc/runtime.h>

@implementation UIView (WQConfig)

static const char *__configBackground__ = "__configBackground__";
- (void)setConfigBackground:(NSString *)configBackground{
    objc_setAssociatedObject(self, __configBackground__, configBackground, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.backgroundColor = APPCONFIG.colorConfig.color(configBackground);
}
- (NSString *)configBackground {
    return objc_getAssociatedObject(self, __configBackground__);
}

@end
