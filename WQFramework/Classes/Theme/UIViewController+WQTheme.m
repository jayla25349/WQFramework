//
//  UIViewController+WQTheme.m
//  GameHelper
//
//  Created by Jayla on 16/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "UIViewController+WQTheme.h"

extern NSNotificationName const WQThemeChangeNotification;

@implementation UIViewController (WQTheme)

- (void)observeThemeChange {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(themeChangeAction)
                                                 name:WQThemeChangeNotification
                                               object:nil];
}

- (void)unObserveThemeChange {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:WQThemeChangeNotification
                                                  object:nil];
}

- (void)themeChangeAction {
    
}

@end
