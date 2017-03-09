//
//  UIImage+WQ.h
//  GameHelper
//
//  Created by 青秀斌 on 16/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WQ)

+ (UIImage *)imageWithSize:(CGSize)size
              cornerRadius:(CGFloat)cornerRadius
               borderWidth:(CGFloat)borderWidth
               borderColor:(UIColor *)borderColor
                 fillColor:(UIColor *)fillColor;

+ (UIImage *)imageWithCornerRadius:(CGFloat)cornerRadius
                       borderWidth:(CGFloat)borderWidth
                       borderColor:(UIColor *)borderColor
                         fillColor:(UIColor *)fillColor;

@end
