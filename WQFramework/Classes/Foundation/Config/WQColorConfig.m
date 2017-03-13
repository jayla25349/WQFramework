//
//  WQColorConfig.m
//  Pods
//
//  Created by 青秀斌 on 2017/3/13.
//
//

#import "WQColorConfig.h"
#import <YYCategories/YYCategories.h>

NS_ASSUME_NONNULL_BEGIN

@interface WQColorConfig ()
@property (nonatomic, copy) WQConfigColorBlock color;
@property (nonatomic, copy) WQConfigImageBlock image;
@end

@implementation WQColorConfig

- (nullable instancetype)initWithContentsOfURL:(NSURL *)url {
    self = [super initWithContentsOfURL:url];
    if (self) {
        __weak typeof(self) __weakSelf = self;
        self.color = ^UIColor * _Nullable(NSString * _Nonnull key) {
            id obj = __weakSelf.configDic[key];
            if ([obj isKindOfClass:[NSString class]]) {
                return [UIColor colorWithHexString:obj];
            }
            if ([obj isKindOfClass:[NSNumber class]]) {
                return [UIColor colorWithRGBA:[obj unsignedIntValue]];
            }
            return nil;
        };
        self.image = ^UIImage * _Nullable(NSString * _Nonnull key) {
            UIColor *color = __weakSelf.color(key);
            return [UIImage imageWithColor:color];
        };
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END
