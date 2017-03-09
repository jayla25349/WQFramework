//
//  WQDirectoryManager.h
//  Pods
//
//  Created by Jayla on 17/3/9.
//
//

#import <Foundation/Foundation.h>
#import "WQDirectory.h"

@interface WQDirectoryManager : NSObject
@property (nonatomic, strong, readonly) WQDirectory *dataDir;
@property (nonatomic, strong, readonly) WQDirectory *videoDir;
@property (nonatomic, strong, readonly) WQDirectory *patchDir;
@property (nonatomic, strong, readonly) WQDirectory *pluginDir;
@end
