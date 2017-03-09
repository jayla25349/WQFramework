//
//  WQConfigManager.m
//  Pods
//
//  Created by Jayla on 17/3/9.
//
//

#import "WQConfigManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface WQConfigManager ()
@property (nonatomic, strong) WQConfig *appConfig;
@property (nonatomic, strong) WQConfig *ucmConfig;
@property (nonatomic, strong) WQConfig *colorConfig;
@end

@implementation WQConfigManager

- (instancetype)init {
    self = [super init];
    if (self) {
        [self reloadAppConfig];
        [self reloadUcmConfig];
        [self reloadColorConfig];
    }
    return self;
}

+ (instancetype)shareInstance {
    static WQConfigManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WQConfigManager alloc] init];
    });
    return manager;
}

/**********************************************************************/
#pragma mark -
/**********************************************************************/

- (void)reloadAppConfig {
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"app" withExtension:@"plist"];
    self.appConfig = [WQConfig configWithContentsOfURL:fileURL];
}
- (void)reloadUcmConfig {
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"ucm" withExtension:@"plist"];
    self.ucmConfig = [WQConfig configWithContentsOfURL:fileURL];
}
- (void)reloadColorConfig {
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"color" withExtension:@"plist"];
    self.colorConfig = [WQConfig configWithContentsOfURL:fileURL];
}

@end

NS_ASSUME_NONNULL_END
