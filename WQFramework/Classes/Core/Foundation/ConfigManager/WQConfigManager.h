//
//  WQConfigManager.h
//  Pods
//
//  Created by Jayla on 17/3/9.
//
//

#import <Foundation/Foundation.h>

@interface WQConfigManager : NSObject

//读取应用配置
- (BOOL)boolForAppKey:(NSString *)key;
- (NSString *)stringForAppKey:(NSString *)key;
- (NSArray *)arrayForAppKey:(NSString *)key;
- (NSDictionary *)dictionaryForAppKey:(NSString *)key;

//读取颜色配置
- (UIColor *)colorForColorKey:(NSString *)key;
- (NSString *)stringForColorKey:(NSString *)key;
- (NSArray *)arrayForColorKey:(NSString *)key;
- (NSDictionary *)dictionaryForColorKey:(NSString *)key;

//读取UCM配置
- (BOOL)boolForUCMKey:(NSString *)key;
- (NSString *)stringForUCMKey:(NSString *)key;

@end

@interface WQConfigManager (URL)

typedef NS_ENUM(NSInteger, PLANTFORM_TYPE) {
    PLANTFORM_TYPE_OL,
    PLANTFORM_TYPE_PP,
    PLANTFORM_TYPE_RD,
};

typedef NS_ENUM(NSInteger, API_TYPE) {
    API_TYPE_GAME,
    API_TYPE_USER,
    API_TYPE_ADVERT,
};

/**********************************************************************/
#pragma mark - 接口地址
/**********************************************************************/

#define URL_FOR_GAME            [WQAppEngine urlForApiType:API_TYPE_GAME]
#define URL_FOR_USER            [WQAppEngine urlForApiType:API_TYPE_USER]
#define URL_FOR_ADVERT          [WQAppEngine urlForApiType:API_TYPE_ADVERT]

+ (PLANTFORM_TYPE)plantformType;
+ (void)setPlantformType:(PLANTFORM_TYPE)plantformType;
+ (NSString *)urlForApiType:(API_TYPE)apiType;

@end
