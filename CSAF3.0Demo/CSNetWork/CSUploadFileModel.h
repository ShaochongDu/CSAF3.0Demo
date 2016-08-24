//
//  HLFileModel.h
//  ShuMaHaoLi
//
//  Created by Shaochong Du on 16/8/1.
//  Copyright © 2016年 X.T. All rights reserved.
//
/**
 *  文件model
 *
 */
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FileType){
    FileTypeImage,  //  图片类型
    FileTypeVideo,  //  视频类型
    FileTypeGif,    //  gif
};

@interface CSUploadFileModel : NSObject

@property (nonatomic, assign) FileType fileType;  //  文件类型

@property (nonatomic, copy) NSString *thumbnailFilePath; //  缩略图文件路径
@property (nonatomic, copy) NSString *thumbnailFileName; //  缩略图文件名称
@property (nonatomic, copy) NSString *thumbnailFileDesc; //  缩略图描述信息

@property (nonatomic, copy) NSString *originalFilePath; //  原图文件路径
@property (nonatomic, copy) NSString *originalFileName; //  原图文件名称
@property (nonatomic, copy) NSString *originalFileDesc; //  原图描述信息
@property (nonatomic, copy) NSString *originalFileSize; //  文件大小

@end
