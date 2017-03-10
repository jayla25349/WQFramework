//
//  NSString+WQCore.h
//  GameHelper
//
//  Created by 青秀斌 on 2016/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WQCore)

- (NSString *)replaceUnicode;

@end


@interface NSString (Regular)

- (NSString *)stringByReplacingMatchesWithPattern:(NSString *)pattern
                                          options:(NSMatchingOptions)options
                                            range:(NSRange)range
                                         template:(NSString *)templ
                              matchTransformation:(NSString *(^)(NSString *element))transformation;

@end
