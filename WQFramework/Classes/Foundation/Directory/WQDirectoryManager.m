//
//  WQDirectoryManager.m
//  Pods
//
//  Created by Jayla on 17/3/9.
//
//

#import "WQDirectoryManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface WQDirectoryManager ()
@property (nonatomic, strong) NSURL *baseURL;
@property (nonatomic, strong) WQDirectory *dataDir;
@property (nonatomic, strong) WQDirectory *videoDir;
@property (nonatomic, strong) WQDirectory *patchDir;
@property (nonatomic, strong) WQDirectory *pluginDir;
@end

@implementation WQDirectoryManager

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *basePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        basePath = [basePath stringByAppendingPathComponent:@"com.wq.dir"];
        
        self.baseURL = [NSURL fileURLWithPath:basePath isDirectory:YES];
        self.dataDir = [WQDirectory dirWithBaseURL:self.baseURL dirName:@"data"];
        self.videoDir = [WQDirectory dirWithBaseURL:self.baseURL dirName:@"video"];
        self.patchDir = [WQDirectory dirWithBaseURL:self.baseURL dirName:@"patch"];
        self.pluginDir = [WQDirectory dirWithBaseURL:self.baseURL dirName:@"plugin"];
    }
    return self;
}

+ (instancetype)shareInstance {
    static WQDirectoryManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WQDirectoryManager alloc] init];
    });
    return manager;
}

@end

NS_ASSUME_NONNULL_END
