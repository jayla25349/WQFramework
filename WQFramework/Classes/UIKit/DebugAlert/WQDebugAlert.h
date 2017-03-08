//
//  WQDebugAlert.h
//  GameHelper
//
//  Created by 青秀斌 on 16/8/11.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WQDebugAlert;

typedef NS_ENUM(NSInteger, DebugAlertStyle) {
    DebugAlertStyleInfo,
    DebugAlertStyleWarn,
    DebugAlertStyleError,
};

typedef WQDebugAlert *(^DebugAlertFormatBlock)(NSString *fromat, ...);
typedef WQDebugAlert *(^DebugAlertStyleBlock)(DebugAlertStyle);
typedef WQDebugAlert *(^DebugAlertBoolBlock)(BOOL);
typedef void (^DebugAlertVoidBlock)(void);


@interface WQDebugAlert : UIView
@property (nonatomic, copy, readonly) DebugAlertFormatBlock message;
@property (nonatomic, copy, readonly) DebugAlertStyleBlock style;
@property (nonatomic, copy, readonly) DebugAlertBoolBlock autoDismiss;
@property (nonatomic, copy, readonly) DebugAlertVoidBlock show;
@end


#ifdef DEBUG
#define InfoAlert(format, ...)  [WQDebugAlert new].message(format, ##__VA_ARGS__).style(DebugAlertStyleInfo).autoDismiss(YES).show()
#define WarnAlert(format, ...)  [WQDebugAlert new].message(format, ##__VA_ARGS__).style(DebugAlertStyleWarn).show()
#define ErrorAlert(format, ...) [WQDebugAlert new].message(format, ##__VA_ARGS__).style(DebugAlertStyleError).show()
#else
#define InfoAlert(format, ...)
#define WarnAlert(format, ...)
#define ErrorAlert(format, ...)
#endif
