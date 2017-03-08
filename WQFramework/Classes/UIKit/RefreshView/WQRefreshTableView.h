//
//  WQRefreshTableView.h
//  GameHelper
//
//  Created by 青秀斌 on 16/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WQRefreshTableViewDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface WQRefreshTableView : UITableView
@property (weak, nonatomic) IBOutlet id<WQRefreshTableViewDelegate> refreshDelegate;

@property (strong, nonatomic, readonly) NSMutableArray *dataArray;
@property (assign, nonatomic, readonly) NSUInteger pageIndex;
@property (nonatomic, copy) void (^reloadView)(NSArray *list);  //自定义加载数据方法

@property (assign, nonatomic) BOOL allowShowMore;               //是否显示加载更多（默认显示）
@property (assign, nonatomic) BOOL allowShowBlank;              //是否显示占位图（默认显示）
@property (assign, nonatomic) BOOL allowShowNoNetworkBlank;     //是否显示无网占位图（默认显示）
@property (nullable, strong, nonatomic) NSString *blankImage;
@property (nullable, strong, nonatomic) NSString *blankTitle;
@property (nullable, strong, nonatomic) NSString *blankMessage;

- (void)refreshData;
@end

@protocol WQRefreshTableViewDelegate <NSObject>
@required

/**
 上拉加载和下拉刷新回调事件
 
 @param tableView   当前TableView
 @param pageIndex   加载页号（为0是即为下拉刷新）
 @param success     成功回调（传入当前页数据，页面将自动刷新）
 @param failure     失败回调（传入失败信息，页面将自动提示）
 */
- (void)tableView:(WQRefreshTableView *)tableView
        pageIndex:(NSUInteger)pageIndex
          success:(void (^)(NSArray * _Nullable list, BOOL hasNext))success
          failure:(void (^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
