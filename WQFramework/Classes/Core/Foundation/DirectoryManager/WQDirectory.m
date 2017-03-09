//
//  WQDirectory.m
//  GameHelper
//
//  Created by 青秀斌 on 2016/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "WQDirectory.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

extern DDLogLevel const ddLogLevel;

NS_ASSUME_NONNULL_BEGIN

@interface WQDirectory ()
@property (nonatomic, strong) NSURL *dirURL;
@property (nonatomic, strong) NSURL *tempURL;
@property (nonatomic, strong) NSURL *trashURL;
@end

@implementation WQDirectory

- (instancetype)initWithBaseURL:(NSURL *)baseURL dirName:(NSString *)dirName {
    self = [super init];
    self.dirURL = [baseURL URLByAppendingPathComponent:dirName];
    self.tempURL = [self.dirURL URLByAppendingPathComponent:@".temp"];
    self.trashURL = [self.dirURL URLByAppendingPathComponent:@".trash"];
    
    //创建目录
    BOOL isDirectory = NO;
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:self.dirURL.path isDirectory:&isDirectory] || !isDirectory) {
        if (![fileManager createDirectoryAtURL:self.dirURL withIntermediateDirectories:YES attributes:nil error:&error]) {
            DDLogError(@"创建文件夹失败：%@", error);
            return nil;
        }
    }
    if (![fileManager fileExistsAtPath:self.tempURL.path isDirectory:&isDirectory] || !isDirectory) {
        if (![fileManager createDirectoryAtURL:self.tempURL withIntermediateDirectories:YES attributes:nil error:&error]) {
            DDLogError(@"创建文件夹失败：%@", error);
            return nil;
        }
    }
    if (![fileManager fileExistsAtPath:self.trashURL.path isDirectory:&isDirectory] || !isDirectory) {
        if (![fileManager createDirectoryAtURL:self.trashURL withIntermediateDirectories:YES attributes:nil error:&error]) {
            DDLogError(@"创建文件夹失败：%@", error);
            return nil;
        }
    }
    
    return self;
}
+ (instancetype)dirWithBaseURL:(NSURL *)baseURL dirName:(NSString *)dirName  {
    return [[self alloc] initWithBaseURL:baseURL dirName:dirName];
}

/**********************************************************************/
#pragma mark - Public
/**********************************************************************/

//清空文件夹内容（忽略隐藏文件）
+ (BOOL)deleteContentOfDir:(NSURL *)dirURL {
    BOOL isDirectory = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dirURL.path isDirectory:&isDirectory] || !isDirectory) {
        return NO;
    }
    
    NSError *error = nil;
    NSArray<NSURL *> *fileURLs = [fileManager contentsOfDirectoryAtURL:dirURL
                                            includingPropertiesForKeys:nil
                                                               options:NSDirectoryEnumerationSkipsHiddenFiles //忽略隐藏文件
                                                                 error:&error];
    for (NSURL *fileURL in fileURLs) {
        DDLogDebug(@"删除文件--->\nfrom--->%@", fileURL);
        if (![fileManager removeItemAtURL:fileURL error:&error]) {
            DDLogError(@"删除文件失败：%@", error);
            return NO;
        }
    }
    
    return YES;
}

//移动文件夹内容（忽略隐藏文件）
+ (BOOL)moveContentOfDir:(NSURL *)dirURL toDir:(NSURL *)toDirURL {
    BOOL isDirectory = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dirURL.path isDirectory:&isDirectory] || !isDirectory) {
        return NO;
    }
    
    NSError *error = nil;
    NSArray<NSURL *> *fileURLs = [fileManager contentsOfDirectoryAtURL:dirURL
                                            includingPropertiesForKeys:nil
                                                               options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                 error:&error];
    for (NSURL *fileURL in fileURLs) {
        NSURL *toURL = [toDirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
        
        //删除文件
        if ([fileManager fileExistsAtPath:toURL.path isDirectory:&isDirectory]) {
            DDLogDebug(@"删除文件--->\nfrom--->%@", toURL);
            if (![fileManager removeItemAtURL:toURL error:&error]) {
                DDLogError(@"删除文件失败：%@", error);
                return NO;
            }
        }
        
        //移动文件
        DDLogDebug(@"移动文件--->\nfrom--->%@\nto--->%@", fileURL, toURL);
        if (![fileManager moveItemAtURL:fileURL toURL:toURL error:&error]) {
            DDLogError(@"移动文件失败：%@", error);
            return NO;
        }
    }
    
    return YES;
}

//拷贝文件夹内容（忽略隐藏文件）
+ (BOOL)copyContentOfDir:(NSURL *)dirURL toDir:(NSURL *)toDirURL {
    BOOL isDirectory = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dirURL.path isDirectory:&isDirectory] || !isDirectory) {
        return NO;
    }
    
    NSError *error = nil;
    NSArray<NSURL *> *fileURLs = [fileManager contentsOfDirectoryAtURL:dirURL
                                            includingPropertiesForKeys:nil
                                                               options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                 error:&error];
    for (NSURL *fileURL in fileURLs) {
        NSURL *toURL = [toDirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
        
        //删除文件
        if ([fileManager fileExistsAtPath:toURL.path isDirectory:&isDirectory]) {
            DDLogDebug(@"删除文件--->\nfrom--->%@", toURL);
            if (![fileManager removeItemAtURL:toURL error:&error]) {
                DDLogError(@"删除文件失败：%@", error);
                return NO;
            }
        }
        
        //拷贝文件
        DDLogDebug(@"拷贝文件--->\nfrom--->%@\nto--->%@", fileURL, toURL);
        if (![fileManager copyItemAtURL:fileURL toURL:toURL error:&error]) {
            DDLogError(@"拷贝文件失败：%@", error);
            return NO;
        }
    }
    
    return YES;
}


//清空临时文件
- (BOOL)clearTemp {
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray<NSURL *> *fileURLs = [fileManager contentsOfDirectoryAtURL:self.tempURL
                                            includingPropertiesForKeys:nil
                                                               options:0
                                                                 error:&error];
    for (NSURL *fileURL in fileURLs) {
        DDLogDebug(@"删除文件--->\nfrom--->%@", fileURL);
        if (![fileManager removeItemAtURL:fileURL error:&error]) {
            DDLogError(@"删除文件失败：%@", error);
            return NO;
        }
    }
    return YES;
}

//清空回收站
- (BOOL)clearTrash {
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray<NSURL *> *fileURLs = [fileManager contentsOfDirectoryAtURL:self.trashURL
                                            includingPropertiesForKeys:nil
                                                               options:0
                                                                 error:&error];
    for (NSURL *fileURL in fileURLs) {
        DDLogDebug(@"删除文件--->\nfrom--->%@", fileURL);
        if (![fileManager removeItemAtURL:fileURL error:&error]) {
            DDLogError(@"删除文件失败：%@", error);
            return NO;
        }
    }
    return YES;
}

//删除文件（直接删除）
- (BOOL)removeAllFiles {
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray<NSURL *> *fileURLs = [fileManager contentsOfDirectoryAtURL:self.dirURL
                                            includingPropertiesForKeys:nil
                                                               options:NSDirectoryEnumerationSkipsHiddenFiles //忽略隐藏文件
                                                                 error:&error];
    for (NSURL *fileURL in fileURLs) {
        DDLogDebug(@"删除文件--->\nfrom--->%@", fileURL);
        if (![fileManager removeItemAtURL:fileURL error:&error]) {
            DDLogError(@"删除文件失败：%@", error);
            return NO;
        }
    }
    return YES;
}

//删除文件（放入回收站）
- (BOOL)deleteAllFiles {
    [self clearTrash];
    
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray<NSURL *> *fileURLs = [fileManager contentsOfDirectoryAtURL:self.dirURL
                                            includingPropertiesForKeys:nil
                                                               options:NSDirectoryEnumerationSkipsHiddenFiles //忽略隐藏文件
                                                                 error:&error];
    for (NSURL *fileURL in fileURLs) {
        NSURL *toURL = [self.trashURL URLByAppendingPathComponent:fileURL.lastPathComponent];
        DDLogDebug(@"移动文件--->\nfrom--->%@\nto--->%@", fileURL, toURL);
        if (![fileManager moveItemAtURL:fileURL toURL:toURL error:&error]) {
            DDLogError(@"移动文件失败：%@", error);
            return NO;
        }
    }
    return YES;
}

//恢复文件（从回收站恢复文件）
- (BOOL)rollbackAllFiles {
    
    //删除工作目录中所有文件
    [self removeAllFiles];
    
    //移动回收站中的文件
    [WQDirectory moveContentOfDir:self.trashURL toDir:self.dirURL];
    
    return YES;
}


//拷贝数据到当前目录（将当前目录文件放入回收站）
- (BOOL)copyFilesFromDir:(NSURL *)dirURL {
    BOOL isDirectory = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dirURL.path isDirectory:&isDirectory] || !isDirectory) {
        return NO;
    }
    
    //删除当前文件夹内容
    [self deleteAllFiles];
    
    //拷贝文件夹内容
    NSError *error = nil;
    NSArray<NSURL *> *fileURLs = [fileManager contentsOfDirectoryAtURL:dirURL
                                            includingPropertiesForKeys:nil
                                                               options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                 error:&error];
    for (NSURL *fileURL in fileURLs) {
        NSURL *toURL = [self.dirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
        DDLogDebug(@"拷贝文件--->\nfrom--->%@\nto--->%@", fileURL, toURL);
        if (![fileManager copyItemAtURL:fileURL toURL:toURL error:&error]) {
            DDLogError(@"拷贝文件失败：%@", error);
            return NO;
        }
    }
    
    return YES;
}


//移动数据到当前目录（将当前目录文件放入回收站）
- (BOOL)moveFilesFromDir:(NSURL *)dirURL {
    BOOL isDirectory = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dirURL.path isDirectory:&isDirectory] || !isDirectory) {
        return NO;
    }
    
    //删除当前文件夹内容
    [self deleteAllFiles];
    
    //拷贝文件夹内容
    NSError *error = nil;
    NSArray<NSURL *> *fileURLs = [fileManager contentsOfDirectoryAtURL:dirURL
                                            includingPropertiesForKeys:nil
                                                               options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                 error:&error];
    for (NSURL *fileURL in fileURLs) {
        NSURL *toURL = [self.dirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
        DDLogDebug(@"移动文件--->\nfrom--->%@\nto--->%@", fileURL, toURL);
        if (![fileManager moveItemAtURL:fileURL toURL:toURL error:&error]) {
            DDLogError(@"移动文件失败：%@", error);
            return NO;
        }
    }
    
    return YES;
}

@end

NS_ASSUME_NONNULL_END
