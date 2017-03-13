//
//  WQConfigManager.h
//  Pods
//
//  Created by Jayla on 17/3/9.
//
//

#import <Foundation/Foundation.h>
#import "WQConfig.h"
#import "WQColorConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface WQConfigManager : NSObject
@property (nonatomic, strong, readonly) WQConfig *appConfig;
@property (nonatomic, strong, readonly) WQConfig *ucmConfig;
@property (nonatomic, strong, readonly) WQColorConfig *colorConfig;

+ (instancetype)shareInstance;
- (void)reloadAppConfig;
- (void)reloadUcmConfig;
- (void)reloadColorConfig;
@end

#define APPCONFIG  [WQConfigManager shareInstance]

NS_ASSUME_NONNULL_END
