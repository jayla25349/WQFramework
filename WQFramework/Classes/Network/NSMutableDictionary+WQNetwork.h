//
//  NSMutableDictionary+WQNetwork.h
//  GameHelper
//
//  Created by 青秀斌 on 16/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WQParameterDic <NSObject>

- (void)setFloat:(float)value forField:(NSString *)field;
- (void)setDouble:(double)value forField:(NSString *)field;
- (void)setInteger:(NSInteger)value forField:(NSString *)field;

- (void)setObject:(id)value forField:(NSString *)field;
- (void)removeObjectForField:(NSString *)field;

//设置子参数
- (void)setParameter:(void (^)(id<WQParameterDic> parameter))block forField:(NSString *)value;
- (void)setParameterForParams:(void (^)(id<WQParameterDic> parameter))block;
@end

@interface NSMutableDictionary (WQNetwork)<WQParameterDic>

@end
