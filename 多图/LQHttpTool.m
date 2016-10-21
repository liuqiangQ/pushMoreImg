//
//  LQHttpTool.m
//  多图
//
//  Created by lqq on 2016/10/21.
//  Copyright © 2016年 lqq. All rights reserved.
//

#import "LQHttpTool.h"

#define BASE_URL @"http://www.baidu.com"//这里是服务端的基本链接,建议写到pch文件里

@implementation LQHttpTool

+ (LQHttpTool *)sharedManager {
    
    static LQHttpTool *handle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handle = [LQHttpTool manager];
        handle.requestSerializer.timeoutInterval = 20;
        handle.requestSerializer = [AFJSONRequestSerializer serializer];
        handle.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html",nil];
    });
    
    
    if (@"token".length) {
        [handle.requestSerializer setValue:@"userid" forHTTPHeaderField:@"userId"];
        [handle.requestSerializer setValue:@"token" forHTTPHeaderField:@"token"];
    }
    
    return handle;
}
    
+ (AFSecurityPolicy *)setHttpsSecurity
{
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    return securityPolicy;
}
    
//get请求
+ (void )get:(NSString *)url parameter:(id)parameters success:(void (^)(id responseObject))success faliure:(void (^)(NSError *error))failure
    {
        
    [[LQHttpTool sharedManager] GET:[BASE_URL stringByAppendingString:url] parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if(responseObject)  {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
        
}
    
//post请求
+ (void)post:(NSString *)url parameters:(id)parameters success:(void(^)(id responseObject))success faliure:(void(^)(NSError *error))failure {
    
    [[LQHttpTool sharedManager] POST:[BASE_URL stringByAppendingString:url] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if(responseObject)  {
        
            NSLog(@"%@",responseObject);
        
            NSInteger statusCode = [responseObject[@"status"][@"code"] intValue];
            switch (statusCode) {
                    case 200://这里是返回码,建议写成枚举
                    if (success) {
                        success(responseObject[@"status"]);
                    }
                    
            }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSInteger statusCode = [response statusCode];
        
        NSLog(@"%ld",(long)statusCode);
        
        failure(error);
    }];
}


    
//文件上传 
+ (void )post:(NSString *)url parameters:(id)parameters  constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block success:(void (^)(id responseObject))success faliure:(void (^)(NSError *error))failure{
    
    [[LQHttpTool sharedManager] POST:[BASE_URL stringByAppendingString:url] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        block(formData);
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(responseObject)  {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
    
    
//文件下载
+ (void)downloadTaskWithUrl:(NSString *)url progress:(void (^)(id downloadProgress))ProgressBlock savePath:(NSString *)savePath  completionHandler:(void (^)(NSURLResponse *response ,NSURL *filePath))completion  error:(void (^)(NSError *error))failure{
    //创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[BASE_URL stringByAppendingString:url]]];
    //创建任务
    NSURLSessionDownloadTask *download =  [[LQHttpTool sharedManager]  downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        if (downloadProgress) {
            ProgressBlock(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return  [NSURL fileURLWithPath:savePath];
        
    }completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (!error) {
            completion(response,filePath);
        }
        else {
            
            failure(error);
            
        }
    }];
    //开启任务
    [download resume];   
}
@end
