//
//  WQColorConfig.h
//  Pods
//
//  Created by 青秀斌 on 2017/3/13.
//
//

#import "WQConfig.h"

NS_ASSUME_NONNULL_BEGIN

typedef UIColor * _Nullable (^WQConfigColorBlock)(NSString *key);
typedef UIImage * _Nullable (^WQConfigImageBlock)(NSString *key);

@interface WQColorConfig : WQConfig
@property (nonatomic, copy, readonly) WQConfigColorBlock color;
@property (nonatomic, copy, readonly) WQConfigImageBlock image;

@end

NS_ASSUME_NONNULL_END
