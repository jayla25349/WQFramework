//
//  WQAppEngine.h
//  GameHelper
//
//  Created by 青秀斌 on 2016/12/28.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQUserManager.h"
#import "WQThemeManager.h"
#import "WQNetworkManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface WQAppEngine : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong, nullable) WQUserManager *userManager;
@property (nonatomic, strong, nullable) WQThemeManager *themeManager;
@property (nonatomic, strong, nullable) WQNetworkManager *networkManager;


- (void)initModule;
- (void)registerModule:(id<UIApplicationDelegate>)module;
- (void)unregisterModule:(id<UIApplicationDelegate>)module;

@end

NS_ASSUME_NONNULL_END

#define APPENGINE       ((WQAppEngine *)[[UIApplication sharedApplication] delegate])
