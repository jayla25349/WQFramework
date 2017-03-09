//
//  UIButton+WQConfig.h
//  GameHelper
//
//  Created by 青秀斌 on 16/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton ()
@property (strong, nonatomic) IBInspectable NSString *configStyle;
@property (strong, nonatomic) IBInspectable NSString *configNText;
@property (strong, nonatomic) IBInspectable NSString *configHText;
@property (strong, nonatomic) IBInspectable NSString *configSText;
@property (strong, nonatomic) IBInspectable NSString *configDText;
@end

@interface UIButton (WQConfig)

- (void)setConfigStyle:(NSString *)configStyle corner:(CGFloat)corner;

@end
