//
//  WQThemeManager.m
//  GameHelper
//
//  Created by 青秀斌 on 16/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "WQThemeManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ThemeTarget : NSObject
@property (nonatomic, weak) id observer;
@property (nonatomic, assign) SEL selector;
@end

@implementation ThemeTarget

@end


@interface WQThemeManager ()
@property (nonatomic, assign) ThemeType themeType;
@property (nonatomic, strong) NSMutableArray<ThemeTarget *> *targets;
@end

@implementation WQThemeManager

- (instancetype)init {
    if (self = [super init]) {
        self.targets = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)shareInstance {
    static WQThemeManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WQThemeManager alloc] init];
    });
    return manager;
}

/**********************************************************************/
#pragma mark -
/**********************************************************************/

- (void)addThemeObserver:(id)observer selector:(SEL)selector {
    if (!observer) {
        return;
    }
    __block ThemeTarget *target = nil;
    [self.targets enumerateObjectsUsingBlock:^(ThemeTarget * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (observer == obj.observer) {
            target = obj;
            *stop = YES;
        }
    }];
    if (!target) {
        target = [[ThemeTarget alloc] init];
        target.observer = observer;
        target.selector = selector;
        [self.targets addObject:target];
    }
}

- (void)switchTheme:(ThemeType)themeType {
    self.themeType = themeType;
    
    NSArray<ThemeTarget *> *tempArray = [self.targets copy];
    [tempArray enumerateObjectsUsingBlock:^(ThemeTarget * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.observer) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            if ([obj.observer respondsToSelector:obj.selector]) {
                [obj.observer performSelector:obj.selector];
            } else {
                NSAssert(NO, @"主题切换方法未实现");
            }
#pragma clang diagnostic pop;
        } else {
            [self.targets removeObject:obj];
        }
    }];
}

@end

NS_ASSUME_NONNULL_END
