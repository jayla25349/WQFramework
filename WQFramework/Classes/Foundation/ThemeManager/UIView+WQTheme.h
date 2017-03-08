//
//  UIView+WQTheme.h
//  GameHelper
//
//  Created by 青秀斌 on 16/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WQTheme)

- (void)observeThemeChange;
- (void)unObserveThemeChange;

- (void)themeChangeAction;

@end