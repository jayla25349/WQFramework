//
//  WQBlankView.m
//  GameHelper
//
//  Created by 青秀斌 on 16/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "WQBlankView.h"
#import "UILabel+WQConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface WQBlankView ()
@property (strong, nonatomic) UIView *contentView;
@property (nullable, strong, nonatomic) UIImageView *imageView;
@property (nullable, strong, nonatomic) UILabel *titleLabel;
@property (nullable, strong, nonatomic) UILabel *messageLabel;
@property (assign, nonatomic) CGFloat topOffset;
@property (strong, nonatomic) NSString *imageName;

@property (copy, nonatomic) BlankImageBlock image;
@property (copy, nonatomic) BlankTextBlock title;
@property (copy, nonatomic) BlankTextBlock message;
@property (copy, nonatomic) BlankOffsetBlock offsetY;
@end

@implementation WQBlankView

- (void)dealloc {
    [self unObserveThemeChange];
}

- (instancetype)init {
    if (self = [super init]) {
        [self observeThemeChange];
    }
    return self;
}

/**********************************************************************/
#pragma mark - OverWrite
/**********************************************************************/

- (void)updateConstraints {
    
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(self.topOffset);
        make.left.equalTo(self).offset(20);
    }];
    
    UIView *tempView = nil;
    if (self.imageView) {
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView);
            make.right.lessThanOrEqualTo(self.contentView);
        }];
        tempView = self.imageView;
    }
    
    if (self.titleLabel) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (tempView && tempView == self.imageView) {
                make.top.equalTo(tempView.mas_bottom).offset(20);
            } else {
                make.top.equalTo(self.contentView);
            }
            make.centerX.equalTo(self.contentView);
            make.right.lessThanOrEqualTo(self.contentView);
        }];
        tempView = self.titleLabel;
    }
    
    if (self.messageLabel) {
        [self.messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (tempView && tempView == self.titleLabel) {
                make.top.equalTo(tempView.mas_bottom).offset(8);
            } else if (tempView && tempView == self.imageView) {
                make.top.equalTo(tempView.mas_bottom).offset(20);
            } else {
                make.top.equalTo(self.contentView);
            }
            make.centerX.equalTo(self.contentView);
            make.right.lessThanOrEqualTo(self.contentView);
        }];
        tempView = self.messageLabel;
    }
    
    if (tempView) {
        [tempView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
        }];
    }
    
    [super updateConstraints];
}

- (void)themeChangeAction {
    self.imageView.image = self.imageName?[UIImage imageNamed:self.imageName]:nil;
    self.titleLabel.configText = @"T2";
    self.messageLabel.configText = @"T2";
}

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        [self addSubview:_contentView];
    }
    return _contentView;
}

/**********************************************************************/
#pragma mark - Public
/**********************************************************************/

- (BlankImageBlock)image {
    return ^WQBlankView *(NSString *image) {
        self.imageName = image;
        if (image) {
            if (!self.imageView) {
                self.imageView = [[UIImageView alloc] init];
                self.imageView.backgroundColor = [UIColor clearColor];
                self.imageView.contentMode = UIViewContentModeCenter;
                [self.contentView addSubview:self.imageView];
            }
            self.imageView.image = [UIImage imageNamed:image];
        } else {
            if (self.imageView) {
                [self.imageView removeFromSuperview];
                self.imageView = nil;
            }
        }
        return self;
    };
}

- (BlankTextBlock)title {
    return ^WQBlankView *(NSString *title) {
        if (title) {
            if (!self.titleLabel) {
                self.titleLabel = [[UILabel alloc] init];
                self.titleLabel.configText = @"T2";
                self.titleLabel.backgroundColor = [UIColor clearColor];
                self.titleLabel.textAlignment = NSTextAlignmentCenter;
                self.titleLabel.font = [UIFont systemFontOfSize:17];
                self.titleLabel.numberOfLines = 2;
                [self.contentView addSubview:self.titleLabel];
            }
            self.titleLabel.text = title;
        } else {
            if (self.titleLabel) {
                [self.titleLabel removeFromSuperview];
                self.titleLabel = nil;
            }
        }
        return self;
    };
}

- (BlankTextBlock)message {
    return ^WQBlankView *(NSString *message) {
        if (message) {
            if (!self.messageLabel) {
                self.messageLabel = [[UILabel alloc] init];
                self.messageLabel.configText = @"T2";
                self.messageLabel.backgroundColor = [UIColor clearColor];
                self.messageLabel.textAlignment = NSTextAlignmentCenter;
                self.messageLabel.font = [UIFont systemFontOfSize:16];
                self.messageLabel.numberOfLines = 2;
                [self.contentView addSubview:self.messageLabel];
            }
            self.messageLabel.text = message;
        } else {
            if (self.messageLabel) {
                [self.messageLabel removeFromSuperview];
                self.messageLabel = nil;
            }
        }
        return self;
    };
}

- (BlankOffsetBlock)offsetY {
    return ^WQBlankView *(CGFloat offsetY) {
        self.topOffset = offsetY;
        [self setNeedsUpdateConstraints];
        [self setNeedsLayout];
        return self;
    };
}

@end

NS_ASSUME_NONNULL_END
