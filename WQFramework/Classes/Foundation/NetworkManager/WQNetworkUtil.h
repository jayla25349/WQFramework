//
//  WQNetworkUtil.h
//  GameHelper
//
//  Created by 青秀斌 on 16/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQQueryStringPair : NSObject
@property (readwrite, nonatomic, strong) id field;
@property (readwrite, nonatomic, strong) id value;

- (id)initWithField:(id)field value:(id)value;
- (NSString *)URLEncodedStringValueWithEncoding:(NSStringEncoding)stringEncoding;
@end

extern NSArray * WQQueryStringPairsFromDictionary(NSDictionary *dictionary);
extern NSString * WQQueryStringFromParametersWithEncoding(NSDictionary *parameters, NSStringEncoding stringEncoding);

@interface WQNetworkUtil : NSObject

//请求地址
+ (NSString *)requestUrlWithUrl:(NSString *)url api:(NSString *)api;

//请求参数
+ (NSDictionary *)requestParamsWithApi:(NSString *)api params:(NSDictionary *)params;

@end
