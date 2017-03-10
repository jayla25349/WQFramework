//
//  UIImage+WQ.m
//  GameHelper
//
//  Created by 青秀斌 on 16/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "UIImage+WQCore.h"

@implementation UIImage (WQCore)

+ (UIImage *)imageWithSize:(CGSize)size
              cornerRadius:(CGFloat)cornerRadius
               borderWidth:(CGFloat)borderWidth
               borderColor:(UIColor *)borderColor
                 fillColor:(UIColor *)fillColor {
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        return nil;
    }
    borderColor = borderColor?:[UIColor clearColor];
    fillColor = fillColor?:[UIColor clearColor];
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth*0.5, borderWidth*0.5)
                                                    cornerRadius:cornerRadius];
    [path setLineWidth:borderWidth];
    [path stroke];
    [path fill];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithCornerRadius:(CGFloat)cornerRadius
                       borderWidth:(CGFloat)borderWidth
                       borderColor:(UIColor *)borderColor
                         fillColor:(UIColor *)fillColor{
    CGFloat width = cornerRadius + borderWidth;
    CGSize size = CGSizeMake(width * 2 + 1, width * 2 + 1);
    UIImage *image = [self imageWithSize:size
                            cornerRadius:cornerRadius
                             borderWidth:borderWidth
                             borderColor:borderColor
                               fillColor:fillColor];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(width, width, width, width)];
    return image;
}

@end
