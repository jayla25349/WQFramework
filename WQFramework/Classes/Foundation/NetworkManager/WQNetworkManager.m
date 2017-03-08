//
//  WQNetworkManager.m
//  GameHelper
//
//  Created by 青秀斌 on 2016/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "WQNetworkManager.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <YYCategories/YYCategories.h>

extern DDLogLevel const ddLogLevel;

#define TASK_BEGIN \
NSTimeInterval beginTime = [NSDate timeIntervalSinceReferenceDate];

#define TASK_END(task, parameters) \
DDLogInfo(@"******************************请求开始(%lu)******************************", task.taskIdentifier);\
DDLogInfo(@"请求地址：%@", task.currentRequest.URL);\
DDLogInfo(@"请求参数：%@", parameters);\
DDLogInfo(@"请求头部：%@", task.currentRequest.allHTTPHeaderFields);

#define TASK_SUCCESS(task, responseObject) \
NSTimeInterval endTime = [NSDate timeIntervalSinceReferenceDate];\
DDLogInfo(@"响应头部：%@", ((NSHTTPURLResponse *)task.response).allHeaderFields);\
DDLogInfo(@"响应内容：%@", responseObject);\
DDLogInfo(@"请求用时：%f", endTime-beginTime);\
DDLogInfo(@"******************************请求完成(%lu)******************************\n\n\n", task.taskIdentifier);

#define TASK_FAILURE(task, responseObject, error) \
NSTimeInterval endTime = [NSDate timeIntervalSinceReferenceDate];\
DDLogInfo(@"请求失败：%@", error.localizedDescription);\
DDLogInfo(@"响应头部：%@", ((NSHTTPURLResponse *)task.response).allHeaderFields);\
DDLogInfo(@"响应内容：%@", responseObject);\
DDLogInfo(@"请求用时：%f", endTime-beginTime);\
DDLogInfo(@"******************************请求完成(%lu)******************************\n\n\n", task.taskIdentifier);


@implementation WQNetworkManager

-(instancetype)init {
    self = [super init];
    self.securityPolicy = [self mySecurityPolicy];
    
    AFHTTPRequestSerializer *requestSerializer = self.requestSerializer;
    [requestSerializer setTimeoutInterval:15];
    
    AFJSONResponseSerializer *responseSerializer = (AFJSONResponseSerializer *)self.responseSerializer;
    responseSerializer.removesKeysWithNullValues = YES;
    responseSerializer.readingOptions = NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments;
    
    [self.reachabilityManager startMonitoring];
    return self;
}

- (AFSecurityPolicy *)mySecurityPolicy {
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    //如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    //validatesCertificateChain 是否验证整个证书链，默认为YES
    //设置为YES，会将服务器返回的Trust Object上的证书链与本地导入的证书进行对比，这就意味着，假如你的证书链是这样的：
    //GeoTrust Global CA
    //    Google Internet Authority G2
    //        *.google.com
    //那么，除了导入*.google.com之外，还需要导入证书链上所有的CA证书（GeoTrust Global CA, Google Internet Authority G2）；
    //如是自建证书的时候，可以设置为YES，增强安全性；假如是信任的CA所签发的证书，则建议关闭该验证，因为整个证书链一一比对是完全没有必要（请查看源代码）；
    //    securityPolicy.validatesCertificateChain = NO;
    
    // 导入证书 ,可以自动导入bundle中所有证书。
    //    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"http1s" ofType:@"cer"];//证书的路径
    //    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    //    securityPolicy.pinnedCertificates = @[certData];
    
    return securityPolicy;
}

/**********************************************************************/
#pragma mark - Overwrite
/**********************************************************************/

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    TASK_BEGIN
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request
                          uploadProgress:uploadProgress
                        downloadProgress:downloadProgress
                       completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                           if (error) {
                               TASK_FAILURE(dataTask, responseObject, error)
                               if (failure) {
                                   failure(dataTask, error);
                               }
                           } else {
                               TASK_SUCCESS(dataTask, responseObject)
                               if (success) {
                                   success(dataTask, responseObject);
                               }
                           }
                       }];
    TASK_END(dataTask, parameters)
    
    return dataTask;
}
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    TASK_BEGIN
    __block NSURLSessionDataTask *task = [self uploadTaskWithStreamedRequest:request progress:uploadProgress completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            TASK_FAILURE(task, responseObject, error)
            if (failure) {
                failure(task, error);
            }
        } else {
            TASK_SUCCESS(task, responseObject)
            if (success) {
                success(task, responseObject);
            }
        }
    }];
    TASK_END(task, parameters)
    
    [task resume];
    
    return task;
}

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/

- (void)handleSuccess:(NSURLSessionDataTask *)task response:(id)responseObject
              success:(void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
              failure:(void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject, NSError *error))failure {
    NSAssert([responseObject isKindOfClass:[NSDictionary class]], @"请求数据错误:%@", task);
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSNumber *code = responseObject[@"code"];
        if (code.integerValue == 200) {
            if (success) {
                success(task, responseObject);
            }
        } else {
            ErrorAlert([[NSString stringWithFormat:@"%@", responseObject] replaceUnicode]);
            if (failure) {
                NSMutableDictionary *userInfo = [responseObject mutableCopy];
                [userInfo setObject:responseObject[@"message"]?:NET_REQUEST_ERROR forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:BussinessErrorDoman code:-2 userInfo:userInfo];
                failure(task, responseObject, error);
            }
        }
    } else {
        ErrorAlert([[NSString stringWithFormat:@"%@", responseObject] replaceUnicode]);
        if (failure) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NET_SERVER_ERROR};
            NSError *error = [NSError errorWithDomain:BussinessErrorDoman code:-1 userInfo:userInfo];
            failure(task, responseObject, error);
        }
    }
}

- (void)handleFailure:(NSURLSessionDataTask *)task error:(NSError *)error
              failure:(void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject, NSError *error))failure {
    ErrorAlert(@"%@", error);
    if (failure){
        NSError *tempError = nil;
        if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorNotConnectedToInternet) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NET_CONNECT_ERROR};
            tempError = [NSError errorWithDomain:RequestErrorDoman code:error.code userInfo:userInfo];
        } else {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NET_REQUEST_ERROR};
            tempError = [NSError errorWithDomain:ResponseErrorDoman code:error.code userInfo:userInfo];
        }
        failure(task, nil, tempError);
    }
}

/**********************************************************************/
#pragma mark - Public
/**********************************************************************/

- (nullable NSURLSessionDataTask *)HTTP_GET:(NSString *)url action:(nullable NSString *)action
                                 parameters:(nullable void (^)(id<WQParameterDic> parameter))parameters
                                    success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                    failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject, NSError *error))failure {
    return [self HTTP_GET:url action:action parameters:parameters progress:nil success:success failure:failure];
}
- (nullable NSURLSessionDataTask *)HTTP_GET:(NSString *)url action:(nullable NSString *)action
                                 parameters:(nullable void (^)(id<WQParameterDic> parameter))parameters
                                   progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                                    success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                    failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject, NSError *error))failure {
    NSParameterAssert(url);
    NSParameterAssert(action);
    
    NSMutableDictionary *tempDict = nil;
    if (parameters) {
        tempDict = [NSMutableDictionary dictionary];
        parameters(tempDict);
    }
    
    //请求参数
    NSDictionary *retParams = [WQNetworkUtil requestParamsWithApi:action params:tempDict];
    
    //请求网络数据
    @weakify(self)
    NSURLSessionDataTask *dataTask = [self GET:url parameters:retParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self)
        [self handleSuccess:task response:responseObject success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        @strongify(self)
        [self handleFailure:task error:error failure:failure];
    }];
    
    return dataTask;
}

- (nullable NSURLSessionDataTask *)HTTP_POST:(NSString *)url action:(nullable NSString *)action
                                  parameters:(nullable void (^)(id<WQParameterDic> parameter))parameters
                                     success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                     failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject, NSError *error))failure {
    NSParameterAssert(url);
    NSParameterAssert(action);
    
    NSMutableDictionary *tempDict = nil;
    if (parameters) {
        tempDict = [NSMutableDictionary dictionary];
        parameters(tempDict);
    }
    
    //请求参数
    NSString *retUrl = [WQNetworkUtil requestUrlWithUrl:url api:action];
    NSDictionary *retParams = [WQNetworkUtil requestParamsWithApi:action params:tempDict];
    
    //请求网络数据
    @weakify(self)
    NSURLSessionDataTask *dataTask = [self POST:retUrl parameters:retParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self)
        [self handleSuccess:task response:responseObject success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        @strongify(self)
        [self handleFailure:task error:error failure:failure];
    }];
    
    return dataTask;
}

- (nullable NSURLSessionDataTask *)HTTP_POST:(NSString *)url action:(nullable NSString *)action
                                  parameters:(nullable void (^)(id<WQParameterDic> parameter))parameters
                   constructingBodyWithBlock:(nullable void (^)(id<AFMultipartFormData> formData))block
                                    progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                     success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                     failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject, NSError *error))failure {
    NSParameterAssert(url);
    NSParameterAssert(action);
    
    NSMutableDictionary *tempDict = nil;
    if (parameters) {
        tempDict = [NSMutableDictionary dictionary];
        parameters(tempDict);
    }
    
    //请求参数
    NSString *retUrl = [WQNetworkUtil requestUrlWithUrl:url api:action];
    NSDictionary *retParams = [WQNetworkUtil requestParamsWithApi:action params:tempDict];
    
    //请求网络数据
    @weakify(self)
    NSURLSessionDataTask *dataTask = [self POST:retUrl parameters:retParams constructingBodyWithBlock:block progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self)
        [self handleSuccess:task response:responseObject success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        @strongify(self)
        [self handleFailure:task error:error failure:failure];
    }];
    
    return dataTask;
}

@end
