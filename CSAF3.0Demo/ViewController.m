//
//  ViewController.m
//  CSAF3.0Demo
//
//  Created by Shaochong Du on 16/5/13.
//  Copyright © 2016年 Shaochong Du. All rights reserved.
//

#import "ViewController.h"
#import "CSNetWorkManager.h"
#import "CSUploadFileModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableDictionary *headerParameterDic = [NSMutableDictionary dictionary];
    [headerParameterDic setObject:@"iPhone" forKey:@"ctype"];
    [headerParameterDic setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forKey:@"cversion"];
    
    NSMutableDictionary *parameterDic = [NSMutableDictionary dictionary];
//    [parameterDic setObject:@"gettypecps" forKey:@"type"];
    NSString *serverUrl = @"http://192.168.0.56:2000/Actitvity.ashx";
//    http://192.168.0.56:2000/Actitvity.ashx?type=gettypecps
    
    //  普通get请求
//    [[CSNetWorkManager shareManager] getWithUrlStr:serverUrl headerParameterDic:headerParameterDic parameterDic:parameterDic successBlock:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"成功");
//    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"失败");
//    }];
    
    //  带有头部信息的get请求
//    http://101.201.210.249:18080//moble/activity?orderType=0
//    serverUrl = @"http://101.201.210.249:18080//moble/activity";
//    [parameterDic setObject:@"0" forKey:@"orderType"];
//    [[CSNetWorkManager shareManager] getWithUrlStr:serverUrl headerParameterDic:headerParameterDic parameterDic:parameterDic successBlock:^(NSURLSessionDataTask *task, id responseObject) {
//        
//    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    } progressBlock:^(NSProgress *downloadProgress) {
//        
//    }];
    
    //  post请求
//    serverUrl = @"http://101.201.210.249:18080//moble/activity/2/unregister/87";
//    [[CSNetWorkManager shareManager] postWithUrlStr:serverUrl headerParameterDic:headerParameterDic parameterDic:nil successBlock:^(NSURLSessionDataTask *task, id responseObject) {
//        
//    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    } progressBlock:^(NSProgress *downloadProgress) {
//        
//    }];
    
    //  put请求
//    http://101.201.210.249:18080//moble/user/87? email=&telephone=13426357545
//    serverUrl = @"http://101.201.210.249:18080//moble/user/87";
//    [parameterDic setObject:@"a.163.com" forKey:@"email"];
//    [parameterDic setObject:@"13426357145" forKey:@"telephone"];
//    [[CSNetWorkManager shareManager] putWithUrlStr:serverUrl headerParameterDic:headerParameterDic parameterDic:parameterDic successBlock:^(NSURLSessionDataTask *task, id responseObject) {
//        
//    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];
    

    //  图片上传
    serverUrl = @"http://192.168.0.158:8088/OrderSup.ashx";
    [parameterDic setObject:@"测试光头强" forKey:@"Theme"];
    [parameterDic setObject:@"845" forKey:@"TrmsId"];
    //  此参数跟图片张数有关
    [parameterDic setObject:@"image1图片1的描述&image2图片2的描述" forKey:@"comments"];
    [parameterDic setObject:@"1" forKey:@"iType"];
    [parameterDic setObject:@"27b1f14f-8783-40d4-98e5-2f79b4e2c418" forKey:@"token"];
    [parameterDic setObject:@"992" forKey:@"trId"];
    [parameterDic setObject:@"update" forKey:@"type"];
    NSMutableArray *fileArray = [NSMutableArray array];
    for (int i = 0; i < 2; i++) {
        CSUploadFileModel *fileModel = [[CSUploadFileModel alloc] init];
        fileModel.fileType = FileTypeImage;
        fileModel.originalFileName = [NSString stringWithFormat:@"filename%d.jpg",i];   //  一定要带有后缀
        fileModel.originalFilePath = [[NSBundle mainBundle] pathForResource:@"guangtouqiang" ofType:@"jpg"];
        [fileArray addObject:fileModel];
    }
    [[CSNetWorkManager shareManager] uploadMultiImageWithServerUrl:serverUrl headerParameterDic:nil parameterDic:parameterDic imageArray:fileArray videoArray:nil successBlock:^(NSURLResponse *reponse, id responseObject) {
        
    } failureBlock:^(NSError *error) {
        
    } progressBlock:^(NSProgress *downloadProgress) {
        
    }];
    
    //  文件下载
//    serverUrl = @"http://baotou.gongyeyun.com///CloudFile//2015//12//23//14//2015122302430050QANTA3MNBD.jpg";
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docDir = [paths objectAtIndex:0];
//    NSString *filePath = [docDir stringByAppendingPathComponent:@"downloadFile.jpg"];
//    [[CSNetWorkManager shareManager] downloadFileWithServerUrl:serverUrl headerParameterDic:nil parameterDic:nil savedPath:filePath downloadSuccess:^(NSURLResponse *reponse, NSURL *filePath) {
//        
//    } downloadFailure:^(NSError *error) {
//        
//    } progress:^(NSProgress *downloadProgress) {
//        
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
