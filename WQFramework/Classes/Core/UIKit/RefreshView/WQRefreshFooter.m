//
//  WQRefreshFooter.m
//  GameHelper
//
//  Created by 青秀斌 on 16/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "WQRefreshFooter.h"
#import "UILabel+WQConfig.h"
#import "WQThemeManager.h"

@interface WQRefreshFooter ()
@property (strong, nonatomic) UILabel *stateLabel;
@property (strong, nonatomic) UIActivityIndicatorView *loadingView;
@end

@implementation WQRefreshFooter

- (instancetype)init {
    self = [super init];
    self.textForIdle = @"上拉即可加载更多...";
    self.textForPulling = @"释放即可加载更多...";
    self.textForRefreshing = @"正在加载...";
    self.textForNoMoreData = @"没有更多了...";
    return self;
}

/**********************************************************************/
#pragma mark - OverWrite
/**********************************************************************/

- (void)themeChangeAction{
    self.stateLabel.configText = @"T2";
    
    if (APPTHEME.themeType == ThemeType_Night) {
        self.loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }else{
        self.loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
}

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/

- (void)prepare {
    [super prepare];
    self.mj_h = 50;
    self.triggerAutomaticallyRefreshPercent = 0.0f;
    
    
    if (self.stateLabel == nil) {
        self.stateLabel = [[UILabel alloc] init];
        self.stateLabel.textAlignment = NSTextAlignmentCenter;
        self.stateLabel.font = [UIFont boldSystemFontOfSize:12];
        self.stateLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.stateLabel];
    }
    
    if (self.loadingView == nil) {
        self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:self.loadingView];
    }
    
    [self themeChangeAction];
    [APPTHEME addThemeObserver:self selector:@selector(themeChangeAction)];
}

- (void)placeSubviews {
    [super placeSubviews];
    self.stateLabel.frame = self.bounds;
    self.loadingView.center = CGPointMake(self.mj_w * 0.5, self.mj_h * 0.5);
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:{
            self.stateLabel.hidden = NO;
            self.stateLabel.text = self.textForIdle;
            [self.loadingView stopAnimating];
        }break;
        case MJRefreshStatePulling:{
            self.stateLabel.hidden = NO;
            self.stateLabel.text = self.textForPulling;
            [self.loadingView stopAnimating];
        }break;
        case MJRefreshStateRefreshing:{
            self.stateLabel.hidden = YES;
            self.stateLabel.text = self.textForRefreshing;
            [self.loadingView startAnimating];
        }break;
        case MJRefreshStateNoMoreData:{
            self.stateLabel.hidden = NO;
            self.stateLabel.text = self.textForNoMoreData;
            [self.loadingView stopAnimating];
        }break;
        default:break;
    }
}

@end
