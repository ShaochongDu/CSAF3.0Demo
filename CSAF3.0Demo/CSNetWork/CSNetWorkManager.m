//
//  CSNetWorkManager.m
//  CSAF3.0Demo
//
//  Created by Shaochong Du on 16/5/13.
//  Copyright © 2016年 Shaochong Du. All rights reserved.
//

#import "CSNetWorkManager.h"
#import "CSUploadFileModel.h"
//  服务器基本地址
//static NSString * const AFAppDotNetAPIBaseURLString = @"https://api.app.net/";
static CSNetWorkManager *defaultNetManager = nil;
@implementation CSNetWorkManager

/**
 *  网络请求单例
 *
 *  @return 网络请求单例
 */
+ (CSNetWorkManager *)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultNetManager = [[CSNetWorkManager alloc] init];
//        defaultNetManager.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
        defaultNetManager.manager = [AFHTTPSessionManager manager];
        defaultNetManager.manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    return defaultNetManager;
}

/**
 *  拼接请求url地址
 *
 *  @param serverUrl    服务端地址
 *  @param parameterDic 参数字典
 */
- (void)printRequestUrl:(NSString *)serverUrl parameterDic:(NSDictionary *)parameterDic
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSLog(@"tip:url-->%@",serverUrl);
    NSLog(@"tip:para-->%@",parameterDic);
    NSString *paraStr;
    for (NSString *key in parameterDic.allKeys) {
        if (paraStr == nil) {
            paraStr = [NSString stringWithFormat:@"%@=%@",key, parameterDic[key]];
        }else{
            paraStr = [NSString stringWithFormat:@"%@&%@=%@",paraStr,key, parameterDic[key]];
        }
    }
    NSString *fullUrl = [NSString stringWithFormat:@"%@?%@",serverUrl,paraStr];
    NSLog(@"\ntip:当前页面请求地址为:\n--------------------\n%@\n--------------------\n",fullUrl);
}

/**
 *  添加头部信息
 *
 *  @param headerParameterDic 头部信息字典
 */
- (void)setHeaderParameterDic:(NSDictionary *)headerParameterDic
{
    if ([headerParameterDic allKeys].count > 0) {
        //  添加头部信息
        for (NSString *key in [headerParameterDic allKeys]) {
            [defaultNetManager.manager.requestSerializer setValue:headerParameterDic[key] forHTTPHeaderField:key];
        }
    }
    NSLog(@"tip:--------- 请求参数头部信息 ---------\n\n\n%@",defaultNetManager.manager.requestSerializer.HTTPRequestHeaders);
}

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
- (NSURLSessionDataTask *)getWithUrlStr:(NSString *)serverUrlStr headerParameterDic:(NSDictionary *)headerParameterDic parameterDic:(NSDictionary *)parameterDic successBlock:(SuccessBlock)successBlok failureBlock:(FailureBlock)failureBlock
{
    return [self getWithUrlStr:serverUrlStr headerParameterDic:headerParameterDic parameterDic:parameterDic successBlock:^(NSURLSessionDataTask *task, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        successBlok(task,responseObject);
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        failureBlock(task,error);
    } progressBlock:nil];
}

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
- (NSURLSessionDataTask *)getWithUrlStr:(NSString *)serverUrlStr headerParameterDic:(NSDictionary *)headerParameterDic parameterDic:(NSDictionary *)parameterDic successBlock:(SuccessBlock)successBlok failureBlock:(FailureBlock)failureBlock progressBlock:(ProgressBlock)progressBlock
{
    defaultNetManager.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain",@"text/json",@"image/jpeg",nil];
    defaultNetManager.manager.requestSerializer.timeoutInterval = 30.f;
    
//    defaultNetManager.manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    defaultNetManager.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [self printRequestUrl:serverUrlStr parameterDic:parameterDic];
    //  设置header信息必须在序列化之后设置
    [self setHeaderParameterDic:headerParameterDic];
    return [[defaultNetManager manager] GET:serverUrlStr parameters:parameterDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"%lld-%lld",downloadProgress.totalUnitCount,downloadProgress.completedUnitCount);
        NSLog(@"downloadProgress:---------%.2f---------",downloadProgress.fractionCompleted);
        if (progressBlock) {
            progressBlock(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"tip:---------GET 服务器数据返回头部---------\n\n\n%@",response.allHeaderFields);
        NSLog(@"tip:---------GET 服务器数据请求结果数据---------\n\n\n%@",responseObject);
        successBlok(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"error:---------GET 数据请求失败---------\n\n\n%@ ",error);
        failureBlock(task,error);
    }];
}

/**
 *  put方式请求服务器数据
 *
 *  @param serverUrlStr 服务器地址
 *  @param parameterDic 参数字典
 *  @param successBlok  成功回调
 *  @param failureBlock 失败回调
 */
- (NSURLSessionDataTask *)putWithUrlStr:(NSString *)serverUrlStr headerParameterDic:(NSDictionary *)headerParameterDic parameterDic:(NSDictionary *)parameterDic successBlock:(SuccessBlock)successBlok failureBlock:(FailureBlock)failureBlock
{
    defaultNetManager.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain",@"image/jpeg",nil];
    defaultNetManager.manager.requestSerializer.timeoutInterval = 30.f;
    
    defaultNetManager.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    defaultNetManager.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [self printRequestUrl:serverUrlStr parameterDic:parameterDic];
    //  设置header信息必须在序列化之后设置
    [self setHeaderParameterDic:headerParameterDic];

    return [[defaultNetManager manager] PUT:serverUrlStr parameters:parameterDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"tip:---------PUT 服务器数据返回头部---------\n\n\n%@",response.allHeaderFields);
        NSLog(@"tip:---------PUT 服务器数据请求结果数据---------\n\n\n%@",responseObject);
        successBlok(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"error:---------PUT 数据请求失败---------\n\n\n%@ ",error);
        failureBlock(task,error);
    }];
}

/**
 *  post方式发送数据
 *
 *  @param serverUrlStr       服务器地址
 *  @param headerParameterDic 请求的头部信息
 *  @param parameterDic       参数字典
 *  @param successBlok        成功回调
 *  @param failureBlock       失败回调
 *  @param progressBlock      请求进度
 */
- (NSURLSessionDataTask *)postWithUrlStr:(NSString *)serverUrlStr headerParameterDic:(NSDictionary *)headerParameterDic parameterDic:(NSDictionary *)parameterDic successBlock:(SuccessBlock)successBlok failureBlock:(FailureBlock)failureBlock progressBlock:(ProgressBlock)progressBlock
{
    defaultNetManager.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain",@"image/jpeg",nil];
    defaultNetManager.manager.requestSerializer.timeoutInterval = 30.f;
    
    defaultNetManager.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    defaultNetManager.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [self printRequestUrl:serverUrlStr parameterDic:parameterDic];
    //  设置header信息必须在序列化之后设置
    [self setHeaderParameterDic:headerParameterDic];
    
    return [[defaultNetManager manager] POST:serverUrlStr parameters:parameterDic progress:^(NSProgress * _Nonnull uploadProgress) {
//        NSLog(@"%lld-%lld",uploadProgress.totalUnitCount,uploadProgress.completedUnitCount);
        NSLog(@"downloadProgress:---------%.2f---------",uploadProgress.fractionCompleted);
        progressBlock(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"tip:---------POST 服务器数据返回头部---------\n\n\n%@",response.allHeaderFields);
        NSLog(@"tip:---------POST 服务器数据请求结果数据---------\n\n\n%@",responseObject);
        successBlok(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"error:---------POST 数据请求失败---------\n\n\n%@ ",error);
        failureBlock(task,error);
    }];
}

/**
 *  多文件上传接口(图片/视频 + 文本)
 *
 *  @param urlStr             服务器地址
 *  @param headerParameterDic 请求的头部信息
 *  @param parameterDic       参数字典
 *  @param dataPathArray      本地文件路径
 *  @param successBlok        成功回调
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
                        progressBlock:(ProgressBlock)progressBlock
{
    NSMutableArray *fileArray = [NSMutableArray array];
    if (imageArray.count) {
        [fileArray addObjectsFromArray:imageArray];
    }
    if (videoArray.count) {
        [fileArray addObjectsFromArray:videoArray];
    }
    [self uploadMultiImageWithServerUrl:urlStr headerParameterDic:headerParameterDic parameterDic:parameterDic fileArray:fileArray successBlock:successBlock failureBlock:failureBlock progressBlock:progressBlock];
}

/**
 *  多文件上传接口(图片/视频 + 文本)
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
                        progressBlock:(ProgressBlock)progressBlock
{
    defaultNetManager.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain",@"image/jpeg",nil];
    //        defaultNetManager.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //            defaultNetManager.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    defaultNetManager.manager.requestSerializer.timeoutInterval = 30.f;
    
    [self printRequestUrl:urlStr parameterDic:parameterDic];
    //  设置header信息必须在序列化之后设置
    [self setHeaderParameterDic:headerParameterDic];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlStr parameters:parameterDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //将图片装换为二进制格式--UIImageJPEGRepresentation第一个参数为要上传的图片,第二个参数是图片压缩的倍数
        //如果要上传多张图片把下面两句代码放到for循环里即可
        for (int i = 0; i< fileArray.count; i++) {
            //  判断图片在本地或网络
            CSUploadFileModel *fileModel = fileArray[i];
            NSData *fileData = [NSData dataWithContentsOfFile:fileModel.originalFilePath];
            if (!fileData) {
                fileData = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileModel.originalFilePath]];
            }
            //  此处fileName文件名 必须带有后缀如:.jpg;.mov;.gif
            if (fileModel.fileType == FileTypeImage) {
                [formData appendPartWithFileData:fileData name:[NSString stringWithFormat:@"image_%d",i] fileName:fileModel.originalFileName mimeType:@"image/jpeg"];
            } else if (fileModel.fileType == FileTypeVideo) {
                [formData appendPartWithFileData:fileData name:[NSString stringWithFormat:@"video_%d",i] fileName:fileModel.originalFileName mimeType:@"video/quicktime"];
            } else if (fileModel.fileType == FileTypeGif) {
                [formData appendPartWithFileData:fileData name:[NSString stringWithFormat:@"gif_%d",i] fileName:fileModel.originalFileName mimeType:@"image/gif"];
            } else {
                NSLog(@"error：文件类型未知");
            }
            
        }
        //        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [defaultNetManager.manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      //                      dispatch_async(dispatch_get_main_queue(), ^{
                      //                          //Update the progress view
                      //                          [progressView setProgress:uploadProgress.fractionCompleted];
                      //                      });
                      //                      NSLog(@"%lld-%lld",uploadProgress.totalUnitCount,uploadProgress.completedUnitCount);
                      NSLog(@"uploadProgress:---------%.2f---------",uploadProgress.fractionCompleted);
                      progressBlock(uploadProgress);
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                      if (error) {
                          NSLog(@"error:---------upload 数据上传失败---------\n\n\n%@ ",error);
                          failureBlock(error);
                      } else {
                          NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
                          NSLog(@"tip:---------upload 服务器数据返回头部---------\n\n\n%@",res.allHeaderFields);
                          NSLog(@"tip:---------upload 服务器数据请求结果数据---------\n\n\n%@",responseObject);
                          successBlock(response,responseObject);
                      }
                  }];
    
    [uploadTask resume];
}

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
                         progress:(ProgressBlock)progress
{
    defaultNetManager.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain",@"image/jpeg",nil];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    defaultNetManager.manager.requestSerializer.timeoutInterval = 30.f;
    
    [self printRequestUrl:urlStr parameterDic:parameterDic];
    //  设置header信息必须在序列化之后设置
    [self setHeaderParameterDic:headerParameterDic];
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [defaultNetManager.manager downloadTaskWithRequest:request progress:^(NSProgress * uploadProgress) {
//        NSLog(@"%lld-%lld",uploadProgress.totalUnitCount,uploadProgress.completedUnitCount);
        NSLog(@"downloadProgress:---------%.2f---------",uploadProgress.fractionCompleted);
        progress(uploadProgress);
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        return [NSURL fileURLWithPath:savedPath];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"File downloaded to: %@", filePath);
        if (error) {
            NSLog(@"error:---------upload 数据上传失败---------\n\n\n%@ ",error);
            failure(error);
        } else {
            NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
            NSLog(@"tip:---------upload 服务器数据返回头部---------\n\n\n%@",res.allHeaderFields);
            NSLog(@"tip:---------upload 服务器数据请求结果数据---------\n\n\n%@",[filePath absoluteString]);
            success(response,filePath);
        }
    }];
    [downloadTask resume];
}




@end
