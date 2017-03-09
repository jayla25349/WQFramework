//
//  WQConfig.h
//  Pods
//
//  Created by Jayla on 17/3/9.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef UIColor * _Nullable (^WQConfigColorBlock)(NSString *key);
typedef UIImage * _Nullable (^WQConfigImageBlock)(NSString *key);
typedef NSArray * _Nullable (^WQConfigArrayBlock)(NSString *key);
typedef NSNumber * _Nullable (^WQConfigNumberBlock)(NSString *key);
typedef NSString * _Nullable (^WQConfigStringBlock)(NSString *key);
typedef NSDictionary * _Nullable (^WQConfigDictionaryBlock)(NSString *key);

@interface WQConfig : NSObject
@property (nonatomic, copy, readonly) WQConfigColorBlock color;
@property (nonatomic, copy, readonly) WQConfigImageBlock image;
@property (nonatomic, copy, readonly) WQConfigArrayBlock array;
@property (nonatomic, copy, readonly) WQConfigNumberBlock number;
@property (nonatomic, copy, readonly) WQConfigStringBlock string;
@property (nonatomic, copy, readonly) WQConfigDictionaryBlock dictionary;

- (nullable instancetype)initWithContentsOfURL:(NSURL *)url;
+ (nullable instancetype)configWithContentsOfURL:(NSURL *)url;
@end

NS_ASSUME_NONNULL_END
