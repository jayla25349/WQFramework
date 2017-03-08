//
//  WQRefreshTableView.m
//  GameHelper
//
//  Created by 青秀斌 on 16/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "WQRefreshTableView.h"
#import <YYCategories/YYCategories.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "WQRefreshHeader.h"
#import "WQRefreshFooter.h"
#import "UIView+WQBlank.h"

@interface WQRefreshTableView ()
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) NSUInteger pageIndex;
@end

@implementation WQRefreshTableView

- (instancetype)init {
    if (self = [super init]) {
        [self awakeFromNib];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self awakeFromNib];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.pageIndex = 0;
    self.allowShowMore = YES;
    self.allowShowBlank = YES;
    self.allowShowNoNetworkBlank = YES;
    self.blankImage = nil;
    self.blankTitle = nil;
    self.blankMessage = nil;
}

- (void)setRefreshDelegate:(id<WQRefreshTableViewDelegate>)refreshDelegate {
    _refreshDelegate = refreshDelegate;
    
    if ([self.refreshDelegate respondsToSelector:@selector(tableView:pageIndex:success:failure:)]) {
        [self addRefreshHeader];
    }
}

- (void)setAllowShowMore:(BOOL)allowShowMore {
    _allowShowMore = allowShowMore;
    
    if (self.mj_footer) {
        [self.mj_footer removeFromSuperview];
        self.mj_footer = nil;
    }
}

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/

- (void)addRefreshHeader {
    if (self.mj_header) {
        return;
    }
    
    WQRefreshHeader *header = [WQRefreshHeader headerWithRefreshingBlock:^{
        NSUInteger pageIndex = 0;
        
        @weakify(self)
        [self.refreshDelegate tableView:self pageIndex:pageIndex success:^(NSArray *list, BOOL hasNext) {
            @strongify(self)
            [self.mj_header endRefreshing];
            
            //添加RefreshFooter
            [self addRefreshFooter];
            if (hasNext) {
                [self.mj_footer endRefreshing];
            } else {
                [self.mj_footer endRefreshingWithNoMoreData];
            }
            
            //加载数据
            self.pageIndex = pageIndex;
            if (self.reloadView) {
                self.reloadView(list);
            } else {
                self.dataArray = [list mutableCopy];
                [self reloadData];
            }
            
            //显示占位图
            if (self.allowShowBlank && self.dataArray.count==0) {
                self.mj_footer.hidden = YES;
                [self showBlankWithImage:self.blankImage?:@"no_data"
                                   title:self.blankTitle?:@"暂无数据"
                                 message:self.blankMessage
                                  action:nil];
            } else {
                self.mj_footer.hidden = NO;
                [self dismissBlank];
            }
        } failure:^(NSError *error) {
            @strongify(self)
            [self.mj_header endRefreshing];
            
            //显示占位图
            NSString *blankTitle = error.localizedDescription?:self.blankTitle;
            if (self.allowShowBlank && self.dataArray.count==0) {
                self.mj_footer.hidden = YES;
                
                if (self.allowShowNoNetworkBlank && ![AFNetworkReachabilityManager sharedManager].isReachable) {
                    [self showBlankWithImage:@"no_network"
                                       title:NET_CONNECT_ERROR
                                     message:nil
                                      action:nil];
                } else {
                    [self showBlankWithImage:@"failed_to_load"
                                       title:blankTitle?:@"加载失败"
                                     message:self.blankMessage
                                      action:nil];
                }
            } else {
                self.mj_footer.hidden = NO;
                [self dismissBlank];
                [SVProgressHUD showErrorWithStatus:blankTitle];
            }
        }];
    }];
    self.mj_header = header;
}

- (void)addRefreshFooter {
    if (!self.allowShowMore) {
        return;
    }
    if (self.mj_footer) {
        return;
    }
    
    WQRefreshFooter *footer = [WQRefreshFooter footerWithRefreshingBlock:^{
        NSUInteger pageIndex = self.pageIndex + 1;
        
        @weakify(self)
        [self.refreshDelegate tableView:self pageIndex:pageIndex success:^(NSArray * _Nullable list, BOOL hasNext) {
            @strongify(self)
            if (hasNext) {
                [self.mj_footer endRefreshing];
            } else {
                [self.mj_footer endRefreshingWithNoMoreData];
            }
            
            //加载数据
            self.pageIndex = pageIndex;
            if (self.reloadView) {
                self.reloadView(list);
            } else {
                [self.dataArray addObjectsFromArray:list];
                [self reloadData];
            }
            
            //显示占位图
            if (self.allowShowBlank && self.dataArray.count==0) {
                self.mj_footer.hidden = YES;
                [self showBlankWithImage:self.blankImage?:@"no_data"
                                   title:self.blankTitle?:@"暂无数据"
                                 message:self.blankMessage
                                  action:nil];
            } else {
                self.mj_footer.hidden = NO;
                [self dismissBlank];
            }
        } failure:^(NSError *error) {
            @strongify(self)
            [self.mj_footer endRefreshing];
            
            //显示占位图
            NSString *blankTitle = error.localizedDescription?:self.blankTitle;
            if (self.allowShowBlank && self.dataArray.count==0) {
                self.mj_footer.hidden = YES;
                
                if (self.allowShowNoNetworkBlank && ![AFNetworkReachabilityManager sharedManager].isReachable) {
                    [self showBlankWithImage:@"no_network"
                                       title:NET_CONNECT_ERROR
                                     message:nil
                                      action:nil];
                } else {
                    [self showBlankWithImage:@"failed_to_load"
                                       title:blankTitle?:@"加载失败"
                                     message:self.blankMessage
                                      action:nil];
                }
            } else {
                self.mj_footer.hidden = NO;
                [self dismissBlank];
                [SVProgressHUD showErrorWithStatus:blankTitle];
            }
        }];
    }];
    self.mj_footer = footer;
}

/**********************************************************************/
#pragma mark - Public
/**********************************************************************/

- (void)refreshData {
    [self.mj_header beginRefreshing];
}

@end
