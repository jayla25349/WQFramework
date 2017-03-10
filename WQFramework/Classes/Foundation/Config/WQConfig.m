//
//  WQConfig.m
//  Pods
//
//  Created by Jayla on 17/3/9.
//
//

#import "WQConfig.h"
#import <YYCategories/YYCategories.h>

NS_ASSUME_NONNULL_BEGIN

@interface WQConfig ()
@property (nonatomic, copy) WQConfigColorBlock color;
@property (nonatomic, copy) WQConfigImageBlock image;
@property (nonatomic, copy) WQConfigArrayBlock array;
@property (nonatomic, copy) WQConfigNumberBlock number;
@property (nonatomic, copy) WQConfigStringBlock string;
@property (nonatomic, copy) WQConfigDictionaryBlock dictionary;

@property (nonatomic, strong) NSDictionary *configDic;
@end

@implementation WQConfig

- (nullable instancetype)initWithContentsOfURL:(NSURL *)url {
    self = [super init];
    if (self) {
        self.configDic = [NSDictionary dictionaryWithContentsOfURL:url];
        NSAssert(self.configDic, @"未读取到配置文件!");
        
        __weak typeof(self) __weakSelf = self;
        [self setColor:^UIColor * _Nullable(NSString * _Nonnull key) {
            id obj = __weakSelf.configDic[key];
            if ([obj isKindOfClass:[NSString class]]) {
                return [UIColor colorWithHexString:obj];
            }
            if ([obj isKindOfClass:[NSNumber class]]) {
                return [UIColor colorWithRGBA:[obj unsignedIntValue]];
            }
            return nil;
        }];
        [self setImage:^UIImage * _Nullable(NSString * _Nonnull key) {
            UIColor *color = __weakSelf.color(key);
            return [UIImage imageWithColor:color];
        }];
        [self setNumber:^NSNumber * _Nullable(NSString * _Nonnull key) {
            id obj = __weakSelf.configDic[key];
            if ([obj isKindOfClass:[NSNumber class]]) {
                return obj;
            }
            return nil;
        }];
        [self setString:^NSString * _Nullable(NSString * _Nonnull key) {
            id obj = __weakSelf.configDic[key];
            if ([obj isKindOfClass:[NSNumber class]]) {
                return obj;
            }
            return nil;
        }];
        [self setArray:^NSArray * _Nullable(NSString * _Nonnull key) {
            id obj = __weakSelf.configDic[key];
            if ([obj isKindOfClass:[NSArray class]]) {
                return obj;
            }
            return nil;
        }];
        [self setDictionary:^NSDictionary * _Nullable(NSString * _Nonnull key) {
            id obj = __weakSelf.configDic[key];
            if ([obj isKindOfClass:[NSDictionary class]]) {
                return obj;
            }
            return nil;
        }];
    }
    return self;
}
+ (nullable instancetype)configWithContentsOfURL:(NSURL *)url{
    return [[WQConfig alloc] initWithContentsOfURL:url];
}

@end

NS_ASSUME_NONNULL_END
