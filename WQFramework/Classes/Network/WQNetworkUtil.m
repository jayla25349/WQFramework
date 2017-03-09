//
//  WQNetworkUtil.m
//  GameHelper
//
//  Created by 青秀斌 on 16/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "WQNetworkUtil.h"

static NSString * const kAFCharactersToBeEscapedInQueryString = @":/?&=;+!@#$()',*";

static NSString * WQPercentEscapedQueryStringKeyFromStringWithEncoding(NSString *string, NSStringEncoding encoding) {
    static NSString * const kAFCharactersToLeaveUnescapedInQueryStringPairKey = @"[].";
    
    return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, (__bridge CFStringRef)kAFCharactersToLeaveUnescapedInQueryStringPairKey, (__bridge CFStringRef)kAFCharactersToBeEscapedInQueryString, CFStringConvertNSStringEncodingToEncoding(encoding));
}

static NSString * WQPercentEscapedQueryStringValueFromStringWithEncoding(NSString *string, NSStringEncoding encoding) {
    return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)kAFCharactersToBeEscapedInQueryString, CFStringConvertNSStringEncodingToEncoding(encoding));
}

@implementation WQQueryStringPair

- (id)initWithField:(id)field value:(id)value {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.field = field;
    self.value = value;
    
    return self;
}

- (NSString *)URLEncodedStringValueWithEncoding:(NSStringEncoding)stringEncoding {
    if (!self.value || [self.value isEqual:[NSNull null]]) {
        return WQPercentEscapedQueryStringKeyFromStringWithEncoding([self.field description], stringEncoding);
    } else {
        return [NSString stringWithFormat:@"%@=%@", WQPercentEscapedQueryStringKeyFromStringWithEncoding([self.field description], stringEncoding), WQPercentEscapedQueryStringValueFromStringWithEncoding([self.value description], stringEncoding)];
    }
}
@end

static NSArray * WQQueryStringPairsFromKeyAndValue(NSString *key, id value) {
    NSMutableArray *mutableQueryStringComponents = [NSMutableArray array];
    
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = value;
        for (id nestedKey in dictionary.allKeys) {
            id nestedValue = [dictionary objectForKey:nestedKey];
            if (nestedValue) {
                [mutableQueryStringComponents addObjectsFromArray:WQQueryStringPairsFromKeyAndValue((key ? [NSString stringWithFormat:@"%@[%@]", key, nestedKey] : nestedKey), nestedValue)];
            }
        }
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = value;
        int i = 0;
        for (id nestedValue in array) {
            [mutableQueryStringComponents addObjectsFromArray:WQQueryStringPairsFromKeyAndValue([NSString stringWithFormat:@"%@[%d]", key, i++], nestedValue)];
        }
    } else if ([value isKindOfClass:[NSSet class]]) {
        NSSet *set = value;
        for (id obj in set) {
            [mutableQueryStringComponents addObjectsFromArray:WQQueryStringPairsFromKeyAndValue(key, obj)];
        }
    } else {
        [mutableQueryStringComponents addObject:[[WQQueryStringPair alloc] initWithField:key value:value]];
    }
    
    return mutableQueryStringComponents;
}

NSArray * WQQueryStringPairsFromDictionary(NSDictionary *dictionary) {
    NSArray<WQQueryStringPair *> *tempArray = WQQueryStringPairsFromKeyAndValue(nil, dictionary);
    tempArray = [tempArray sortedArrayUsingComparator:^NSComparisonResult(WQQueryStringPair * _Nonnull obj1, WQQueryStringPair   * _Nonnull obj2) {
        return [obj1.field compare:obj2.field];
    }];
    return tempArray;
}

NSString * WQQueryStringFromParametersWithEncoding(NSDictionary *parameters, NSStringEncoding stringEncoding) {
    NSMutableArray *mutablePairs = [NSMutableArray array];
    for (WQQueryStringPair *pair in WQQueryStringPairsFromDictionary(parameters)) {
        [mutablePairs addObject:[pair URLEncodedStringValueWithEncoding:stringEncoding]];
    }
    
    return [mutablePairs componentsJoinedByString:@"&"];
}

@implementation WQNetworkUtil

//请求地址
+ (NSString *)requestUrlWithUrl:(NSString *)url api:(NSString *)api {
    if (api) {
        url = [url stringByAppendingString:api];
    }
    return url;
}

//请求参数
+ (NSDictionary *)requestParamsWithApi:(NSString *)api params:(NSDictionary *)params {
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
    [tempDic setValue:@"ios" forKey:@"platform"];
    [tempDic setValue:@"v1" forKey:@"apiVersion"];
    [tempDic setValue:api forKey:@"api"];
    if ([params isKindOfClass:[NSDictionary class]]) {
        [tempDic addEntriesFromDictionary:params];
    }
    
    //数字签名
    //TODE
    
    return tempDic;
}

@end
