//
//  WQThemeManager.h
//  GameHelper
//
//  Created by 青秀斌 on 16/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ThemeType) {
    ThemeType_Defalt,
    ThemeType_Night,
};

@interface WQThemeManager : NSObject
@property (nonatomic, assign, readonly) ThemeType themeType;

+ (instancetype)shareInstance;
- (void)addThemeObserver:(id)observer selector:(SEL)selector;
- (void)switchTheme:(ThemeType)themeType;
@end

#define APPTHEME  [WQThemeManager shareInstance]

NS_ASSUME_NONNULL_END
