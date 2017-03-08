//
//  NSString+WQ.m
//  GameHelper
//
//  Created by 青秀斌 on 2016/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "NSString+WQ.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

extern const DDLogLevel ddLogLevel;

@implementation NSString (WQ)

- (NSString *)replaceUnicode {
    NSString *tempStr1 = [self stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListWithData:tempData
                                                                    options:NSPropertyListImmutable
                                                                     format:nil
                                                                      error:nil];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

@end


@implementation NSString (Regular)

- (NSString *)stringByReplacingMatchesWithPattern:(NSString *)pattern
                                          options:(NSMatchingOptions)options
                                            range:(NSRange)range
                                         template:(NSString *)templ
                              matchTransformation:(NSString *(^)(NSString *element))transformation {
    NSError *error = nil;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    if (error) {
        DDLogError(@"正则表达式错误：%@",error);
        return self;
    }
    
    NSMutableString* mutableString = [self mutableCopy];
    NSInteger offset = 0; // keeps track of range changes in the string due to replacements.
    for (NSTextCheckingResult* result in [regular matchesInString:self options:options range:range]) {
        NSRange resultRange = [result range];
        resultRange.location += offset; // resultRange.location is updated based on the offset updated below
        
        // implement your own replace functionality using
        // replacementStringForResult:inString:offset:template:
        // note that in the template $0 is replaced by the match
        NSString* match = [regular replacementStringForResult:result inString:mutableString offset:offset template:templ];
        
        // get the replacement from the provided block
        NSString *replacement = transformation(match);
        
        // make the replacement
        [mutableString replaceCharactersInRange:resultRange withString:replacement];
        
        // update the offset based on the replacement
        offset += ([replacement length] - resultRange.length);
    }
    return mutableString;
}

@end
