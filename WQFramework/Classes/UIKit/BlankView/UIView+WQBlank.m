//
//  UIView+WQBlank.m
//  GameHelper
//
//  Created by 青秀斌 on 16/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "UIView+WQBlank.h"
#import <objc/runtime.h>
#import <YYCategories/YYCategories.h>
#import "WQBlankView.h"

@implementation UIView (WQBlank)

NS_ASSUME_NONNULL_BEGIN

const char *__blankView__ = "__blankView__";
const char *__blankAction__ = "__blankAction__";
- (void)showBlankWithImage:(nullable NSString *)image
                     title:(nullable NSString *)title
                   message:(nullable NSString *)message
                    action:(nullable void (^)(void))action offsetY:(CGFloat)offsetY{
    WQBlankView *blankView = objc_getAssociatedObject(self, __blankView__);
    if (blankView == nil) {
        blankView = [[WQBlankView alloc] init];
        blankView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:blankView];
        objc_setAssociatedObject(self, __blankView__, blankView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    CGRect frame = self.bounds;
    
    //修正TableView上对header和footer的遮挡
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        frame.origin.y += tableView.tableHeaderView.height;
        frame.size.height -= tableView.tableHeaderView.height + tableView.tableFooterView.height;
    }
    
    blankView.frame = frame;
    blankView.image(image).title(title).message(message).offsetY(offsetY);
    if (action) {
        objc_setAssociatedObject(self, __blankAction__, action, OBJC_ASSOCIATION_COPY);
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__blankAction:)];
        [blankView addGestureRecognizer:tapGesture];
    }
}
- (void)showBlankWithImage:(nullable NSString *)image
                     title:(nullable NSString *)title
                   message:(nullable NSString *)message
                    action:(nullable void (^)(void))action {
    [self showBlankWithImage:image title:title message:message action:action offsetY:0];
}


- (void)showBlankWithType:(BlankType)type
                    title:(nullable NSString *)title
                  message:(nullable NSString *)message
                   action:(nullable void (^)(void))action
                  offsetY:(CGFloat)offsetY{
    NSString *image = nil;
    switch (type) {
        case BlankType_NoData: {
            image = @"no_data";
        }break;
        case BlankType_NoNetWork: {
            image = @"no_network";
        }break;
        case BlankType_LoadFailure: {
            image = @"failed_to_load";
        }break;
    }
    [self showBlankWithImage:image title:title message:message action:action offsetY:offsetY];
}
- (void)showBlankWithType:(BlankType)type
                    title:(nullable NSString *)title
                  message:(nullable NSString *)message
                   action:(nullable void (^)(void))action {
    [self showBlankWithType:type title:title message:message action:action offsetY:0];
}

- (void)dismissBlank {
    WQBlankView *blankView = objc_getAssociatedObject(self, __blankView__);
    [blankView removeFromSuperview];
    
    objc_setAssociatedObject(self, __blankView__, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, __blankAction__, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**********************************************************************/
#pragma mark -
/**********************************************************************/

//暂无数据
- (void)showBlankNoData:(nullable void (^)(void))action offsetY:(CGFloat)offsetY {
    __weak typeof(self) weakSelf = self;
    [self showBlankWithType:BlankType_NoData title:action?@"暂无数据，点击刷新":@"暂无数据" message:nil action:^{
        if (action) {
            [weakSelf dismissBlank];
            action();
        }
    } offsetY:offsetY];
}
- (void)showBlankNoData:(nullable void (^)(void))action {
    [self showBlankNoData:action offsetY:0];
}

//网络断开
- (void)showBlankNoNetWork:(nullable void (^)(void))action offsetY:(CGFloat)offsetY {
    __weak typeof(self) weakSelf = self;
    [self showBlankWithType:BlankType_NoNetWork title:@"网络已断开，请连接后重试" message:nil action:^{
        if (action) {
            [weakSelf dismissBlank];
            action();
        }
    } offsetY:offsetY];
}
- (void)showBlankNoNetWork:(nullable void (^)(void))action {
    [self showBlankNoNetWork:action offsetY:0];
}

//加载失败
- (void)showBlankLoadFailure:(nullable void (^)(void))action offsetY:(CGFloat)offsetY {
    __weak typeof(self) weakSelf = self;
    [self showBlankWithType:BlankType_LoadFailure title:action?@"加载失败，点击刷新":@"加载失败" message:nil action:^{
        if (action) {
            [weakSelf dismissBlank];
            action();
        }
    } offsetY:offsetY];
}
- (void)showBlankLoadFailure:(nullable void (^)(void))action {
    [self showBlankLoadFailure:action offsetY:0];
}

/**********************************************************************/
#pragma mark - Action
/**********************************************************************/

- (void)__blankAction:(id)sender {
    void (^action)(void) = objc_getAssociatedObject(self, __blankAction__);
    if (action) {
        action();
    }
}

@end

NS_ASSUME_NONNULL_END
