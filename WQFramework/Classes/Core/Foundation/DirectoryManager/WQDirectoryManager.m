//
//  WQDirectoryManager.m
//  Pods
//
//  Created by Jayla on 17/3/9.
//
//

#import "WQDirectoryManager.h"

@interface WQDirectoryManager ()
@property (nonatomic, strong) WQDirectory *dataDir;
@property (nonatomic, strong) WQDirectory *videoDir;
@property (nonatomic, strong) WQDirectory *patchDir;
@property (nonatomic, strong) WQDirectory *pluginDir;
@end

@implementation WQDirectoryManager

- (instancetype)init {
    NSString *basePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSURL *baseURL = [NSURL fileURLWithPath:basePath isDirectory:YES];
    self = [super init];
    if (self) {
        self.dataDir = [WQDirectory dirWithBaseURL:baseURL dirName:@"data"];
        self.videoDir = [WQDirectory dirWithBaseURL:baseURL dirName:@"video"];
        self.patchDir = [WQDirectory dirWithBaseURL:baseURL dirName:@"patch"];
        self.pluginDir = [WQDirectory dirWithBaseURL:baseURL dirName:@"plugin"];
    }
    return self;
}

@end
