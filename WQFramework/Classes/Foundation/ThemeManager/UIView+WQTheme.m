//
//  UIView+WQTheme.m
//  GameHelper
//
//  Created by 青秀斌 on 16/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "UIView+WQTheme.h"

@implementation UIView (WQTheme)

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
