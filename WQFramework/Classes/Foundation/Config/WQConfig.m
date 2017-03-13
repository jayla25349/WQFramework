//
//  WQConfig.m
//  Pods
//
//  Created by Jayla on 17/3/9.
//
//

#import "WQConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface WQConfig ()
@property (nonatomic, strong) NSDictionary *configDic;
@property (nonatomic, copy) WQConfigBoolBlock boolean;
@property (nonatomic, copy) WQConfigArrayBlock array;
@property (nonatomic, copy) WQConfigNumberBlock number;
@property (nonatomic, copy) WQConfigStringBlock string;
@property (nonatomic, copy) WQConfigDictionaryBlock dictionary;
@end

@implementation WQConfig

- (nullable instancetype)initWithContentsOfURL:(NSURL *)url {
    self = [super init];
    if (self) {
        self.configDic = [NSDictionary dictionaryWithContentsOfURL:url];
        NSAssert(self.configDic, @"未读取到配置文件!");
        
        __weak typeof(self) __weakSelf = self;
        self.boolean =  ^BOOL(NSString * _Nonnull key) {
            id obj = __weakSelf.configDic[key];
            if ([obj isKindOfClass:[NSNumber class]]) {
                return [obj boolValue];
            }
            if ([obj isKindOfClass:[NSString class]]) {
                return [obj boolValue];
            }
            return NO;
        };
        self.number =  ^NSNumber * _Nullable(NSString * _Nonnull key) {
            id obj = __weakSelf.configDic[key];
            if ([obj isKindOfClass:[NSNumber class]]) {
                return obj;
            }
            return nil;
        };
        self.string = ^NSString * _Nullable(NSString * _Nonnull key) {
            id obj = __weakSelf.configDic[key];
            if ([obj isKindOfClass:[NSString class]]) {
                return obj;
            }
            return nil;
        };
        self.array = ^NSArray * _Nullable(NSString * _Nonnull key) {
            id obj = __weakSelf.configDic[key];
            if ([obj isKindOfClass:[NSArray class]]) {
                return obj;
            }
            return nil;
        };
        self.dictionary = ^NSDictionary * _Nullable(NSString * _Nonnull key) {
            id obj = __weakSelf.configDic[key];
            if ([obj isKindOfClass:[NSDictionary class]]) {
                return obj;
            }
            return nil;
        };
    }
    return self;
}
+ (nullable instancetype)configWithContentsOfURL:(NSURL *)url{
    return [[WQConfig alloc] initWithContentsOfURL:url];
}

@end

NS_ASSUME_NONNULL_END
