//
//  WQDirectoryManager.h
//  Pods
//
//  Created by Jayla on 17/3/9.
//
//

#import <Foundation/Foundation.h>
#import "WQDirectory.h"

NS_ASSUME_NONNULL_BEGIN

@interface WQDirectoryManager : NSObject
@property (nonatomic, strong, readonly) NSURL *baseURL;
@property (nonatomic, strong, readonly) WQDirectory *dataDir;
@property (nonatomic, strong, readonly) WQDirectory *videoDir;
@property (nonatomic, strong, readonly) WQDirectory *patchDir;
@property (nonatomic, strong, readonly) WQDirectory *pluginDir;

+ (instancetype)shareInstance;
@end

#define APPDIRECTORY  [WQDirectoryManager shareInstance]

NS_ASSUME_NONNULL_END
