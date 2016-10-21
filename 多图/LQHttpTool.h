//
//  LQHttpTool.h
//  多图
//
//  Created by lqq on 2016/10/21.
//  Copyright © 2016年 lqq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface LQHttpTool : AFHTTPSessionManager

+ (LQHttpTool *)sharedManager;
    
/**
 *  get请求
 */
+ (void)get:(NSString *)url parameter:(id )parameters success:(void(^)(id responseObject))success faliure:(void(^)(NSError *error))failure;
    
/**
 *  post请求
 */
+ (void)post:(NSString *)url parameters:(id)parameters success:(void(^)(id responseObject))success faliure:(void(^)(NSError *error))failure;
    
/**
 *  文件上传
 *
 *  @param url        接口url
 *  @param parameters 参数
 *  @param block      图片data
 *  @param success    请求成功的block
 *  @param failure    请求失败的block
 */
+ (void )post:(NSString *)url parameters:(id)parameters  constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block success:(void (^)(id responseObject))success faliure:(void (^)(NSError *error))failure;
    
/**
 *  文件下载
 *
 *  @param url       下载请求url
 *  @param ProgressBlock 下载进度block
 *  @param savePath      储存路径
 *  @param failure       下载失败block
 */
+ (void)downloadTaskWithUrl:(NSString *)url progress:(void (^)(id downloadProgress))ProgressBlock savePath:(NSString *)savePath  completionHandler:(void (^)(NSURLResponse *response ,NSURL *filePath))completion  error:(void (^)(NSError *error))failure;
    
@end
