//
//  WQAppEngine.h
//  GameHelper
//
//  Created by 青秀斌 on 2016/12/28.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Reachability/Reachability.h>

NS_ASSUME_NONNULL_BEGIN

@interface WQAppEngine : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) Reachability *reachability;

- (void)registerDelegate:(id<UIApplicationDelegate>)delegate;
- (void)unregisterDelegate:(id<UIApplicationDelegate>)delegate;

@end

#define APPENGINE   ((WQAppEngine *)[[UIApplication sharedApplication] delegate])

NS_ASSUME_NONNULL_END
