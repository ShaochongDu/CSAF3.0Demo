# CSAF3.0Demo
对af3.0请求进行封装

具体参考demo
```
//  普通get请求
[[CSNetWorkManager shareManager] getWithUrlStr:serverUrl headerParameterDic:headerParameterDic parameterDic:parameterDic successBlock:^(NSURLSessionDataTask *task, id responseObject) {
    NSLog(@"成功");
  } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"失败");
  }];
```
