//
//  UIButton+WQConfig.m
//  GameHelper
//
//  Created by 青秀斌 on 16/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "UIButton+WQConfig.h"
#import <objc/runtime.h>
#import <YYCategories/YYCategories.h>
#import "UIImage+WQ.h"
#import "WQAppEngine+WQConfig.h"

@implementation UIButton (WQConfig)

- (void)setConfigStyle:(NSString *)configStyle corner:(CGFloat)corner {
    [self setBackgroundColor:[UIColor clearColor]];
    
    //配置颜色
    void (^ConfigColorBlock)(NSDictionary *, UIControlState) = ^(NSDictionary *colorDic, UIControlState state) {
        if (colorDic) {
            NSString *background = colorDic[@"background"];
            NSString *border = colorDic[@"border"];
            NSString *text = colorDic[@"text"];
            
            UIColor *backgroundColor = [UIColor colorWithHexString:background];
            UIColor *borderColor = [UIColor colorWithHexString:border];
            UIColor *textColor = [UIColor colorWithHexString:text];
            UIImage *image = [UIImage imageWithCornerRadius:corner
                                                borderWidth:borderColor?0.5f:0.0f
                                                borderColor:borderColor
                                                  fillColor:backgroundColor];
            
            [self setBackgroundImage:image forState:state];
            [self setTitleColor:textColor forState:state];
        } else {
            [self setBackgroundImage:nil forState:state];
            [self setTitleColor:nil forState:state];
        }
    };
    
    //配置样式
    NSDictionary *styleDic = [WQAppEngine dictionaryForColorKey:configStyle];
    if (styleDic) {
        ConfigColorBlock(styleDic[@"normal"], UIControlStateNormal);
        ConfigColorBlock(styleDic[@"highlighted"], UIControlStateHighlighted);
        ConfigColorBlock(styleDic[@"selected"], UIControlStateSelected);
        ConfigColorBlock(styleDic[@"disabled"], UIControlStateDisabled);
    } else {
        NSAssert(configStyle, @"不存在该按钮样式配置：%@", configStyle);
    }
}

static const char *__configStyle__ = "__configStyle__";
- (void)setConfigStyle:(NSString *)configStyle{
    objc_setAssociatedObject(self, __configStyle__, configStyle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setConfigStyle:configStyle corner:2.0f];
}
- (NSString *)configStyle {
    return objc_getAssociatedObject(self, __configStyle__);
}

static const char *__configNText__ = "__configNText__";
- (void)setConfigNText:(NSString *)configNText{
    objc_setAssociatedObject(self, __configNText__, configNText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setTitleColor:[WQAppEngine colorForColorKey:configNText] forState:UIControlStateNormal];
}
- (NSString *)configNText {
    return objc_getAssociatedObject(self, __configNText__);
}

static const char *__configHText__ = "__configHText__";
- (void)setConfigHText:(NSString *)configHText{
    objc_setAssociatedObject(self, __configHText__, configHText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setTitleColor:[WQAppEngine colorForColorKey:configHText] forState:UIControlStateHighlighted];
}
- (NSString *)configHText {
    return objc_getAssociatedObject(self, __configHText__);
}

static const char *__configSText__ = "__configSText__";
- (void)setConfigSText:(NSString *)configSText{
    objc_setAssociatedObject(self, __configSText__, configSText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setTitleColor:[WQAppEngine colorForColorKey:configSText] forState:UIControlStateSelected];
}
- (NSString *)configSText {
    return objc_getAssociatedObject(self, __configSText__);
}

static const char *__configDText__ = "__configDText__";
- (void)setConfigDText:(NSString *)configDText{
    objc_setAssociatedObject(self, __configDText__, configDText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setTitleColor:[WQAppEngine colorForColorKey:configDText] forState:UIControlStateDisabled];
}
- (NSString *)configDText {
    return objc_getAssociatedObject(self, __configDText__);
}

@end
