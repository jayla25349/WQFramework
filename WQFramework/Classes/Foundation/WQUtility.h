//
//  WQUtility.h
//  GameHelper
//
//  Created by 青秀斌 on 2016/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQUtility : NSObject

+ (void)updateDeviceToken:(NSData *)deviceToken;
+ (NSString *)deviceToken;

@end
