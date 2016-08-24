//
//  CSNetWorkManager.h
//  CSAF3.0Demo
//
//  Created by Shaochong Du on 16/5/13.
//  Copyright © 2016年 Shaochong Du. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


typedef void(^SuccessBlock)(NSURLSessionDataTask *task,id responseObject);
typedef void(^FailureBlock)(NSURLSessionDataTask *task, NSError *error);
typedef void(^ProgressBlock)(NSProgress *downloadProgress);

typedef void(^ErrorBlock)(NSError *error);
typedef void(^UploadSuccessBlock)(NSURLResponse *reponse,id responseObject);
typedef void(^DownloadSuccessBlock)(NSURLResponse *reponse,NSURL *filePath);

@interface CSNetWorkManager : NSObject

@property (nonatomic, retain)AFHTTPSessionManager *manager;

//  若 报错（415）或 failed: unacceptable content-type: text/plain
//  试着注释或放开一下两行代码
//  defaultNetManager.manager.requestSerializer = [AFJSONRequestSerializer serializer];
//  defaultNetManager.manager.responseSerializer = [AFJSONResponseSerializer serializer];


/**
 *  网络请求单例
 *
 *  @return 网络请求单例
 */
+ (CSNetWorkManager *)shareManager;

/**
 *   get方式请求服务器数据
 *
 *  @param serverUrlStr       服务器地址
 *  @param headerParameterDic 请求的头部信息
 *  @param parameterDic       参数字典
 *  @param successBlok        成功回调
 *  @param failureBlock       失败回调
 *
 *  @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)getWithUrlStr:(NSString *)serverUrlStr
                     headerParameterDic:(NSDictionary *)headerParameterDic
                           parameterDic:(NSDictionary *)parameterDic
                           successBlock:(SuccessBlock)successBlok
                           failureBlock:(FailureBlock)failureBlock;

/**
 *   get方式请求服务器数据 带有进度
 *
 *  @param serverUrlStr       服务器地址
 *  @param headerParameterDic 请求的头部信息
 *  @param parameterDic       参数字典
 *  @param successBlok        成功回调
 *  @param failureBlock       失败回调
 *  @param progressBlock      请求进度
 *
 *  @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)getWithUrlStr:(NSString *)serverUrlStr
                     headerParameterDic:(NSDictionary *)headerParameterDic
                           parameterDic:(NSDictionary *)parameterDic
                           successBlock:(SuccessBlock)successBlok
                           failureBlock:(FailureBlock)failureBlock
                          progressBlock:(ProgressBlock)progressBlock;

/**
 *  put方式请求服务器数据
 *
 *  @param serverUrlStr 服务器地址
 *  @param parameterDic 参数字典
 *  @param successBlok  成功回调
 *  @param failureBlock 失败回调
 */
- (NSURLSessionDataTask *)putWithUrlStr:(NSString *)serverUrlStr
                     headerParameterDic:(NSDictionary *)headerParameterDic
                           parameterDic:(NSDictionary *)parameterDic
                           successBlock:(SuccessBlock)successBlok
                           failureBlock:(FailureBlock)failureBlock;

/**
 *  post方式发送数据(文本)
 *
 *  @param serverUrlStr       服务器地址
 *  @param headerParameterDic 请求的头部信息
 *  @param parameterDic       参数字典
 *  @param successBlok        成功回调
 *  @param failureBlock       失败回调
 *  @param progressBlock      请求进度
 */
- (NSURLSessionDataTask *)postWithUrlStr:(NSString *)serverUrlStr
                      headerParameterDic:(NSDictionary *)headerParameterDic
                            parameterDic:(NSDictionary *)parameterDic
                            successBlock:(SuccessBlock)successBlok
                            failureBlock:(FailureBlock)failureBlock
                           progressBlock:(ProgressBlock)progressBlock;

/**
 *  多文件上传接口(图片/视频 + 文本)两个数组
 *
 *  @param urlStr             服务器地址
 *  @param headerParameterDic 请求的头部信息
 *  @param parameterDic       参数字典
 *  @param imageArray         图片数据模型数组
 *  @param videoArray         视频数据模型数组
 *  @param successBlock       成功回调
 *  @param failureBlock       失败回调
 *  @param progressBlock      请求进度
 */
- (void)uploadMultiImageWithServerUrl:(NSString *)urlStr
                   headerParameterDic:(NSDictionary *)headerParameterDic
                         parameterDic:(NSMutableDictionary *)parameterDic
                           imageArray:(NSMutableArray *)imageArray
                           videoArray:(NSMutableArray *)videoArray
                         successBlock:(UploadSuccessBlock)successBlock
                         failureBlock:(ErrorBlock)failureBlock
                        progressBlock:(ProgressBlock)progressBlock;


/**
 *  多文件上传接口(图片/视频 + 文本)多文件类型接口
 *
 *  @param urlStr             服务器地址
 *  @param headerParameterDic 请求的头部信息
 *  @param parameterDic       参数字典
 *  @param fileArray          文件数据模型数组
 *  @param successBlock       成功回调
 *  @param failureBlock       失败回调
 *  @param progressBlock      请求进度
 */
- (void)uploadMultiImageWithServerUrl:(NSString *)urlStr
                   headerParameterDic:(NSDictionary *)headerParameterDic
                         parameterDic:(NSMutableDictionary *)parameterDic
                            fileArray:(NSMutableArray *)fileArray
                         successBlock:(UploadSuccessBlock)successBlock
                         failureBlock:(ErrorBlock)failureBlock
                        progressBlock:(ProgressBlock)progressBlock;

/**
 *  文件下载
 *
 *  @param urlStr             服务器地址
 *  @param headerParameterDic 请求的头部信息
 *  @param parameterDic       参数字典
 *  @param savedPath          本地保存路径
 *  @param success            成功回调
 *  @param failure            失败回调
 *  @param progress           下载进度
 */
- (void)downloadFileWithServerUrl:(NSString *)urlStr
               headerParameterDic:(NSDictionary *)headerParameterDic
                     parameterDic:(NSMutableDictionary *)parameterDic
                        savedPath:(NSString*)savedPath
                  downloadSuccess:(DownloadSuccessBlock)success
                  downloadFailure:(ErrorBlock)failure
                         progress:(ProgressBlock)progress;



@end
