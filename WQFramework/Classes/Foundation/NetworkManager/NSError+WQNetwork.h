//
//  NSError+WQNetwork.h
//  GameHelper
//
//  Created by 青秀斌 on 2016/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NET_CONNECT_ERROR @"当前网络不给力,请稍后重试"
#define NET_REQUEST_ERROR @"请求失败，请稍后重试"
#define NET_SERVER_ERROR @"服务器繁忙，请稍后再试"

#define RequestErrorDoman   @"RequestErrorDoman"
#define ResponseErrorDoman  @"ResponseErrorDoman"
#define BussinessErrorDoman @"BussinessErrorDoman"

@interface NSError (WQNetwork)

+ (NSError *)reqeustError:(NSInteger)code message:(NSString *)message;
+ (NSError *)responseError:(NSInteger)code message:(NSString *)message;
+ (NSError *)bussinessError:(NSInteger)code message:(NSString *)message;

@end
