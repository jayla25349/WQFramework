//
//  WQThemeManager.h
//  GameHelper
//
//  Created by 青秀斌 on 16/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ThemeType) {
    ThemeType_Defalt,
    ThemeType_Night,
};

extern NSNotificationName const WQThemeChangeNotification;

@interface WQThemeManager : NSObject<UIApplicationDelegate>
@property (nonatomic, assign, readonly) ThemeType themeType;

- (void)switchToTheme:(ThemeType)themeType;
@end
