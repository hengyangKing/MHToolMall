//
//  MHAVFormatShopConfig.m
//  musichome
//
//  Created by J on 2017/7/23.
//  Copyright © 2017年 J. All rights reserved.
//

#import "MHAVFormatShopConfig.h"
#import "NSDate+MHDateExtension.h"
#import "NSFileManager+MHFilePath.h"
#import "MHBase.h"
@interface MHAVFormatShopConfig()
@end
@implementation MHAVFormatShopConfig
+(MHAVFormatShopConfig *)defaultConfig {
    MHAVFormatShopConfig *config=[[MHAVFormatShopConfig alloc]init];
    config.MHAVFormatShopOutputFileType(AVFileTypeMPEG4);
    config.MHAVFormatShopPresetName(AVAssetExportPresetMediumQuality);
    config.MHAVFormatShopOutputFilePath([[JHYFILEMANAGER getSmallMovieFilePath] stringByAppendingPathComponent:kSmallMovieFile]);
    
    return config;
}
-(void)setAsset:(AVURLAsset *)asset
{
    _asset=asset;
}
-(void)setPresetName:(NSString *)presetName
{
    _presetName=presetName;
}
-(void)setOutputPathURL:(NSURL *)outputPathURL
{
    _outputPathURL=outputPathURL;
}
-(void)setOutputFileType:(NSString *)outputFileType
{
    _outputFileType=outputFileType;
}

-(MHAVFormatShopConfig *(^)(AVURLAsset *))MHAVFormatShopAsset {
    return ^(AVURLAsset *asset){
        if (asset) {
            self.asset=asset;
        }
        return self;
    };
}
-(MHAVFormatShopConfig *(^)(NSString *))MHAVFormatShopPresetName {
    return ^(NSString *presetName){
        if (presetName.length) {
            self.presetName=presetName;
        }
        return self;
    };
}
-(MHAVFormatShopConfig *(^)(NSString *))MHAVFormatShopOutputFilePath {
    return ^(NSString *path){
        
        path.length?[self setOutputPathURL:[NSURL fileURLWithPath:path]]:NSLog(@"%@", [NSString stringWithFormat:@"路径为空 该实力存储于%@",self.outputPathURL.absoluteString]);
        return self;
    };
}
-(MHAVFormatShopConfig *(^)(NSString *))MHAVFormatShopOutputFileType
{
    return ^(NSString *fileType){
        if (fileType.length) {
            self.outputFileType=fileType;
        }
        return self;
    };
}
@end
