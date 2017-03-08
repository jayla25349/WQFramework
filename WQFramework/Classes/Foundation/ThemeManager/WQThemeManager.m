//
//  WQThemeManager.m
//  GameHelper
//
//  Created by 青秀斌 on 16/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "WQThemeManager.h"

#define USERINFO_THEME_TYPE         @"USERINFO_THEME_TYPE"
NSNotificationName const WQThemeChangeNotification = @"WQThemeChangeNotification";

@interface WQThemeManager ()
@property (nonatomic, assign) ThemeType themeType;
@end

@implementation WQThemeManager

- (instancetype)init {
    if (self = [super init]) {
        NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
        NSNumber *themeType = [userInfo objectForKey:USERINFO_THEME_TYPE];
        switch (themeType.integerValue) {
            case ThemeType_Night:{
                self.themeType = ThemeType_Night;
            }break;
            default:{
                self.themeType = ThemeType_Defalt;
            }break;
        }
    }
    return self;
}

/**********************************************************************/
#pragma mark - Public
/**********************************************************************/

- (void)switchToTheme:(ThemeType)themeType {
    self.themeType = themeType;
    
    [WQAppEngine loadColorConfigDic];
    [[NSNotificationCenter defaultCenter] postNotificationName:WQThemeChangeNotification object:self];
}

@end
