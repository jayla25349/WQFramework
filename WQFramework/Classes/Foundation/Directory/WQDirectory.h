//
//  WQDirectory.h
//  GameHelper
//
//  Created by 青秀斌 on 2016/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WQDirectory : NSObject
@property (nonatomic, readonly) NSURL *dirURL;      //根目录（存放正式数据）
@property (nonatomic, readonly) NSURL *tempURL;     //临时目录（隐藏）
@property (nonatomic, readonly) NSURL *trashURL;    //回收站（隐藏）


- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (instancetype)initWithBaseURL:(NSURL *)baseURL dirName:(NSString *)dirName;
+ (instancetype)dirWithBaseURL:(NSURL *)baseURL dirName:(NSString *)dirName;


//删除文件夹内容（忽略隐藏文件）
+ (BOOL)deleteContentOfDir:(NSURL *)dirURL;

//移动文件夹内容（忽略隐藏文件）
+ (BOOL)moveContentOfDir:(NSURL *)dirURL toDir:(NSURL *)toDirURL;

//拷贝文件夹内容（忽略隐藏文件）
+ (BOOL)copyContentOfDir:(NSURL *)dirURL toDir:(NSURL *)toDirURL;


//清空临时文件
- (BOOL)clearTemp;

//清空回收站
- (BOOL)clearTrash;

//删除文件（直接删除）
- (BOOL)removeAllFiles;

//删除文件（放入回收站）
- (BOOL)deleteAllFiles;

//恢复文件（从回收站放回）
- (BOOL)rollbackAllFiles;

//拷贝数据到当前目录（将当前目录文件放入回收站）
- (BOOL)copyFilesFromDir:(NSURL *)dirURL;

//移动数据到当前目录（将当前目录文件放入回收站）
- (BOOL)moveFilesFromDir:(NSURL *)dirURL;

@end

NS_ASSUME_NONNULL_END
