//
//  WQUtility.m
//  GameHelper
//
//  Created by 青秀斌 on 2016/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "WQUtility.h"

#define USERINFO_DEVICE_TOKEN       @"USERINFO_DEVICE_TOKEN"

@implementation WQUtility

//推送Token
static NSString *wqDeviceToken = nil;
+ (void)updateDeviceToken:(NSData *)deviceToken {
    wqDeviceToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    wqDeviceToken = [wqDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
}
+ (NSString *)deviceToken{
    return wqDeviceToken;
}

@end
