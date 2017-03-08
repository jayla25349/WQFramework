//
//  WQAppEngine+Config.m
//  GameHelper
//
//  Created by 青秀斌 on 2016/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "WQAppEngine+WQConfig.h"

@implementation WQAppEngine (WQConfig)

/**********************************************************************/
#pragma mark - Pirvate
/**********************************************************************/

+ (YYMemoryCache *)colorConfigCache {
    static YYMemoryCache *instance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[YYMemoryCache alloc] init];
    });
    return instance;
}

/**********************************************************************/
#pragma mark - 配置管理
/**********************************************************************/

//加载应用配置
static NSDictionary *appConfigDic = nil;
+ (NSDictionary *)loadAppConfigDic{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"app" ofType:@"plist"];
    appConfigDic = [NSDictionary dictionaryWithContentsOfFile:path];
    return appConfigDic;
}
+ (NSDictionary *)appConfigDic{
    if (appConfigDic == nil) {
        [self loadAppConfigDic];
    }
    return appConfigDic;
}

//加载颜色配置
static NSDictionary *colorConfigDic = nil;
+ (NSDictionary *)loadColorConfigDic{
    NSString *filePath = nil;
    switch (0) {
        case 1:{
            filePath = [[NSBundle mainBundle] pathForResource:@"nightcolor" ofType:@"plist"];
        }break;
        default:{
            filePath = [[NSBundle mainBundle] pathForResource:@"color" ofType:@"plist"];
        }break;
    }
    colorConfigDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    [[self colorConfigCache] removeAllObjects];
    return colorConfigDic;
}
+ (NSDictionary *)colorConfigDic{
    if (colorConfigDic == nil) {
        [self loadColorConfigDic];
    }
    return colorConfigDic;
}

//加载UCM配置
static NSDictionary *ucmConfigDic = nil;
+ (NSDictionary *)loadUCMConfigDic{
    NSString *filePath = [[UIApplication sharedApplication].cachesPath stringByAppendingPathComponent:@"ucm.plist"];
    if (!filePath || ![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        filePath = [[NSBundle mainBundle] pathForResource:@"ucm" ofType:@"plist"];
    }
    ucmConfigDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return ucmConfigDic;
}
+ (NSDictionary *)ucmConfigDic{
    if (ucmConfigDic == nil) {
        [self loadUCMConfigDic];
    }
    return ucmConfigDic;
}


//读取应用配置
+ (BOOL)boolForAppKey:(NSString *)key {
    if (!key) {
        return NO;
    }
    id value = [[self appConfigDic] valueForKey:key];
    DDAssert(value, @"%s", __FUNCTION__);
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value boolValue];
    }
    if ([value isKindOfClass:[NSString class]]) {
        return [value boolValue];
    }
    return NO;
}
+ (NSString *)stringForAppKey:(NSString *)key {
    if (!key) {
        return nil;
    }
    id value = [[self appConfigDic] valueForKey:key];
    DDAssert(value, @"%s", __FUNCTION__);
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    return nil;
}
+ (NSArray *)arrayForAppKey:(NSString *)key {
    if (!key) {
        return nil;
    }
    id value = [[self appConfigDic] valueForKey:key];
    DDAssert(value, @"%s", __FUNCTION__);
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    }
    return nil;
}
+ (NSDictionary *)dictionaryForAppKey:(NSString *)key {
    if (!key) {
        return nil;
    }
    id value = [[self appConfigDic] valueForKey:key];
    DDAssert(value, @"%s", __FUNCTION__);
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    return nil;
}

//读取颜色配置
+ (UIColor *)colorForColorKey:(NSString *)key{
    if (!key) {
        return nil;
    }
    NSString *tempString = [self stringForColorKey:key];
    NSArray *tempArray = [tempString componentsSeparatedByString:@"-"];
    tempString = tempArray.firstObject;
    
    UIColor *color = [[self colorConfigCache] objectForKey:tempString];
    if (!color) {
        color = [UIColor colorWithHexString:tempString];
        if (color) {
            [[self colorConfigCache] setObject:color forKey:tempString];
        }
    }
    return color;
}
+ (NSString *)stringForColorKey:(NSString *)key {
    if (!key) {
        return nil;
    }
    id value = [[self colorConfigDic] valueForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    return nil;
}
+ (NSDictionary *)dictionaryForColorKey:(NSString *)key {
    if (!key) {
        return nil;
    }
    id value = [[self colorConfigDic] valueForKey:key];
    DDAssert(value, @"%s", __FUNCTION__);
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    return nil;
}

//读取UCM配置
+ (BOOL)boolForUCMKey:(NSString *)key{
    if (!key) {
        return NO;
    }
    id value = [[self ucmConfigDic] valueForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value boolValue];
    }
    if ([value isKindOfClass:[NSString class]]) {
        return [value boolValue];
    }
    return NO;
}
+ (NSString *)stringForUCMKey:(NSString *)key{
    if (!key) {
        return nil;
    }
    id value = [[self ucmConfigDic] valueForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    return nil;
}

/**********************************************************************/
#pragma mark - 接口地址
/**********************************************************************/


+ (PLANTFORM_TYPE)plantformType {
    NSString *plantform = [[NSUserDefaults standardUserDefaults] valueForKey:@"WQ_PLANTFORM_TYPE"];
    if (plantform == nil) {
        NSDictionary *serverDict = [self dictionaryForAppKey:@"Server"];
        plantform = [serverDict objectForKey:@"default"];
    }
    DDAssert(plantform, @"获取接口地址配置出错！");
    
    if ([plantform isEqualToString:@"OL"]) {
        return PLANTFORM_TYPE_OL;
    }
    if ([plantform isEqualToString:@"PP"]) {
        return PLANTFORM_TYPE_PP;
    }
    if ([plantform isEqualToString:@"RD"]) {
        return PLANTFORM_TYPE_RD;
    }
    return PLANTFORM_TYPE_OL;
}

+ (void)setPlantformType:(PLANTFORM_TYPE)plantformType {
    NSString *tempString = nil;
    switch (plantformType) {
        case PLANTFORM_TYPE_OL:
            tempString = @"OL";
            break;
        case PLANTFORM_TYPE_PP:
            tempString = @"PP";
            break;
        case PLANTFORM_TYPE_RD:
            tempString = @"RD";
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:tempString forKey:@"WQ_PLANTFORM_TYPE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSString *)urlForApiType:(API_TYPE)apiType {
    NSDictionary *serverDict = [self dictionaryForAppKey:@"Server"];
    
    NSDictionary *urlDict = nil;
    switch ([self plantformType]) {
        case PLANTFORM_TYPE_OL:{//正式平台
            urlDict = serverDict[@"OL"];
        }break;
        case PLANTFORM_TYPE_PP:{//预上线平台
            urlDict = serverDict[@"PP"];
        }break;
        case PLANTFORM_TYPE_RD:{//测试平台
            urlDict = serverDict[@"RD"];
        }break;
    }
    DDAssert(urlDict, @"获取接口地址配置出错！");
    
    NSString *url = nil;
    switch (apiType) {
        case API_TYPE_GAME:{
            url = urlDict[@"game"];
        }break;
        case API_TYPE_USER:{
            url = urlDict[@"user"];
        }break;
        case API_TYPE_ADVERT:{
            url = urlDict[@"advert"];
        }break;
    }
    DDAssert(url, @"获取接口地址配置出错！");
    
    return url;
}

@end
