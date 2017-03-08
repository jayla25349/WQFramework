//
//  WQAppEngine.m
//  GameHelper
//
//  Created by 青秀斌 on 2016/12/28.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "WQAppEngine.h"
#import <UserNotifications/UserNotifications.h>

#ifdef DEBUG
const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
const DDLogLevel ddLogLevel = DDLogLevelWarning;
#endif

@interface WQAppEngine ()
@property (nonatomic, strong) NSMutableArray<id<UIApplicationDelegate>> *modules;
@end

@implementation WQAppEngine

/**********************************************************************/
#pragma mark - Init
/**********************************************************************/

- (instancetype)init {
    if (self = [super init]) {
        self.modules = [NSMutableArray new];
        
        //控制台日志
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        
        //文件日志
        DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
        fileLogger.rollingFrequency = 60 * 60 * 24; // 10s写一次
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7;//log 文件最多允许 7个
        [DDLog addLogger:fileLogger];
    }
    return self;
}

/**********************************************************************/
#pragma mark - Public
/**********************************************************************/

- (void)initModule {
    WQUserManager *userManager = [[WQUserManager alloc] init];
    self.userManager = userManager;
    WQThemeManager *themeManager = [[WQThemeManager alloc] init];
    self.themeManager = themeManager;
    WQNetworkManager *networkManager = [[WQNetworkManager alloc] init];
    self.networkManager = networkManager;
    
    [self registerModule:userManager];
    [self registerModule:themeManager];
    [self registerModule:networkManager];
}

- (void)registerModule:(id<UIApplicationDelegate>)module {
    if (!module) {
        return;
    }
    if (![self.modules containsObject:module]) {
        [self.modules addObject:module];
        DDLogInfo(@"已注册 %@", module);
    }
}

- (void)unregisterModule:(id<UIApplicationDelegate>)module {
    if (!module) {
        return;
    }
    if ([self.modules containsObject:module]) {
        [self.modules removeObject:module];
        DDLogInfo(@"已卸载 %@", module);
    }
}

/**********************************************************************/
#pragma mark - UIApplicationDelegate
/**********************************************************************/

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions {
    [self initModule];
    
    __block BOOL flag = NO;
    [self.modules enumerateObjectsUsingBlock:^(id<UIApplicationDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SEL sel = @selector(application:didFinishLaunchingWithOptions:);
        if ([obj respondsToSelector:sel]) {
            DDLogDebug(@"-[%@ %@]", obj, NSStringFromSelector(sel));
            BOOL ret = [obj application:application didFinishLaunchingWithOptions:launchOptions];
            if (!flag && ret) {
                flag = YES;
            }
        }
    }];
    return flag;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [self.modules enumerateObjectsUsingBlock:^(id<UIApplicationDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SEL sel = @selector(applicationWillResignActive:);
        if ([obj respondsToSelector:sel]) {
            DDLogDebug(@"-[%@ %@]", obj, NSStringFromSelector(sel));
            [obj applicationWillResignActive:application];
        }
    }];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self.modules enumerateObjectsUsingBlock:^(id<UIApplicationDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SEL sel = @selector(applicationDidEnterBackground:);
        if ([obj respondsToSelector:sel]) {
            DDLogDebug(@"-[%@ %@]", obj, NSStringFromSelector(sel));
            [obj applicationDidEnterBackground:application];
        }
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self.modules enumerateObjectsUsingBlock:^(id<UIApplicationDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SEL sel = @selector(applicationWillEnterForeground:);
        if ([obj respondsToSelector:sel]) {
            DDLogDebug(@"-[%@ %@]", obj, NSStringFromSelector(sel));
            [obj applicationWillEnterForeground:application];
        }
    }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self.modules enumerateObjectsUsingBlock:^(id<UIApplicationDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SEL sel = @selector(applicationDidBecomeActive:);
        if ([obj respondsToSelector:sel]) {
            DDLogDebug(@"-[%@ %@]", obj, NSStringFromSelector(sel));
            [obj applicationDidBecomeActive:application];
        }
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self.modules enumerateObjectsUsingBlock:^(id<UIApplicationDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SEL sel = @selector(applicationWillTerminate:);
        if ([obj respondsToSelector:sel]) {
            DDLogDebug(@"-[%@ %@]", obj, NSStringFromSelector(sel));
            [obj applicationWillTerminate:application];
        }
    }];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(nonnull UIUserNotificationSettings *)notificationSettings {
    [self.modules enumerateObjectsUsingBlock:^(id<UIApplicationDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SEL sel = @selector(application:didRegisterUserNotificationSettings:);
        if ([obj respondsToSelector:sel]) {
            DDLogDebug(@"-[%@ %@]", obj, NSStringFromSelector(sel));
            [obj application:application didRegisterUserNotificationSettings:notificationSettings];
        }
    }];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {
    [WQUtility updateDeviceToken:deviceToken];
    
    [self.modules enumerateObjectsUsingBlock:^(id<UIApplicationDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SEL sel = @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:);
        if ([obj respondsToSelector:sel]) {
            DDLogDebug(@"-[%@ %@]", obj, NSStringFromSelector(sel));
            [obj application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
        }
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error {
    [self.modules enumerateObjectsUsingBlock:^(id<UIApplicationDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SEL sel = @selector(application:didFailToRegisterForRemoteNotificationsWithError:);
        if ([obj respondsToSelector:sel]) {
            DDLogDebug(@"-[%@ %@]", obj, NSStringFromSelector(sel));
            [obj application:application didFailToRegisterForRemoteNotificationsWithError:error];
        }
    }];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(nonnull UILocalNotification *)notification {
    [self.modules enumerateObjectsUsingBlock:^(id<UIApplicationDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SEL sel = @selector(application:didReceiveLocalNotification:);
        if ([obj respondsToSelector:sel]) {
            DDLogDebug(@"-[%@ %@]", obj, NSStringFromSelector(sel));
            [obj application:application didReceiveLocalNotification:notification];
        }
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo {
    [self.modules enumerateObjectsUsingBlock:^(id<UIApplicationDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SEL sel = @selector(application:didReceiveRemoteNotification:);
        if ([obj respondsToSelector:sel]) {
            DDLogDebug(@"-[%@ %@]", obj, NSStringFromSelector(sel));
            [obj application:application didReceiveRemoteNotification:userInfo];
        }
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    [self.modules enumerateObjectsUsingBlock:^(id<UIApplicationDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SEL sel = @selector(application:didReceiveRemoteNotification:fetchCompletionHandler:);
        if ([obj respondsToSelector:sel]) {
            DDLogDebug(@"-[%@ %@]", obj, NSStringFromSelector(sel));
            [obj application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
        }
    }];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    [self.modules enumerateObjectsUsingBlock:^(id<UIApplicationDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SEL sel = @selector(application:performFetchWithCompletionHandler:);
        if ([obj respondsToSelector:sel]) {
            DDLogDebug(@"-[%@ %@]", obj, NSStringFromSelector(sel));
            [obj application:application performFetchWithCompletionHandler:completionHandler];
        }
    }];
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(nonnull UIApplicationShortcutItem *)shortcutItem completionHandler:(nonnull void (^)(BOOL))completionHandler {
    [self.modules enumerateObjectsUsingBlock:^(id<UIApplicationDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SEL sel = @selector(application:performActionForShortcutItem:completionHandler:);
        if ([obj respondsToSelector:sel]) {
            DDLogDebug(@"-[%@ %@]", obj, NSStringFromSelector(sel));
            [obj application:application performActionForShortcutItem:shortcutItem completionHandler:completionHandler];
        }
    }];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(nonnull NSURL *)url {
    __block BOOL flag = NO;
    [self.modules enumerateObjectsUsingBlock:^(id<UIApplicationDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SEL sel = @selector(application:handleOpenURL:);
        if ([obj respondsToSelector:sel]) {
            DDLogDebug(@"-[%@ %@]", obj, NSStringFromSelector(sel));
            BOOL ret = [obj application:application handleOpenURL:url];
            if (!flag && ret) {
                flag = YES;
            }
        }
    }];
    return flag;
}

- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    __block BOOL flag = NO;
    [self.modules enumerateObjectsUsingBlock:^(id<UIApplicationDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SEL sel = @selector(application:openURL:options:);
        if ([obj respondsToSelector:sel]) {
            DDLogDebug(@"-[%@ %@]", obj, NSStringFromSelector(sel));
            BOOL ret = [obj application:application openURL:url options:options];
            if (!flag && ret) {
                flag = YES;
            }
        }
    }];
    return flag;
}

- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation {
    __block BOOL flag = NO;
    [self.modules enumerateObjectsUsingBlock:^(id<UIApplicationDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SEL sel = @selector(application:openURL:sourceApplication:annotation:);
        if ([obj respondsToSelector:sel]) {
            DDLogDebug(@"-[%@ %@]", obj, NSStringFromSelector(sel));
            BOOL ret = [obj application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
            if (!flag && ret) {
                flag = YES;
            }
        }
    }];
    return flag;
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(nonnull NSString *)identifier completionHandler:(nonnull void (^)())completionHandler {
    [self.modules enumerateObjectsUsingBlock:^(id<UIApplicationDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SEL sel = @selector(application:handleEventsForBackgroundURLSession:completionHandler:);
        if ([obj respondsToSelector:sel]) {
            DDLogDebug(@"-[%@ %@]", obj, NSStringFromSelector(sel));
            [obj application:application handleEventsForBackgroundURLSession:identifier completionHandler:completionHandler];
        }
    }];
}

@end
