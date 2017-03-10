//
//  WQRefreshFooter.h
//  GameHelper
//
//  Created by 青秀斌 on 16/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

@interface WQRefreshFooter : MJRefreshAutoFooter
@property (nonatomic, copy) NSString *textForIdle;
@property (nonatomic, copy) NSString *textForPulling;
@property (nonatomic, copy) NSString *textForRefreshing;
@property (nonatomic, copy) NSString *textForNoMoreData;
@end
