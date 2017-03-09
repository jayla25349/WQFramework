//
//  UITextView+WQConfig.m
//  GameHelper
//
//  Created by Jayla on 17/3/6.
//  Copyright © 2017年 kylincc. All rights reserved.
//

#import "UITextView+WQConfig.h"
#import <objc/runtime.h>
#import "WQAppEngine+WQConfig.h"

@implementation UITextView (WQConfig)

static const char *__configText__ = "__configText__";
- (void)setConfigText:(NSString *)configText{
    objc_setAssociatedObject(self, __configText__, configText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.textColor = [WQAppEngine colorForColorKey:configText];
}
- (NSString *)configText {
    return objc_getAssociatedObject(self, __configText__);
}

@end
