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
#define  FILEMANAGER [NSFileManager defaultManager]

@interface MHAVFormatShopConfig()
@end
@implementation MHAVFormatShopConfig
+(MHAVFormatShopConfig *)defaultConfig
{
    MHAVFormatShopConfig *config=[[MHAVFormatShopConfig alloc]init];
    config.MHAVFormatShopOutputFileType(AVFileTypeMPEG4);
    config.MHAVFormatShopPresetName(AVAssetExportPresetMediumQuality);
    config.MHAVFormatShopOutputFileName(kSmallMovieFile);
    
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

-(MHAVFormatShopConfig *(^)(AVURLAsset *))MHAVFormatShopAsset
{
    return ^(AVURLAsset *asset){
        if (asset) {
            self.asset=asset;
        }
        return self;
    };
}
-(MHAVFormatShopConfig *(^)(NSString *))MHAVFormatShopPresetName
{
    return ^(NSString *presetName){
        if (presetName.length) {
            self.presetName=presetName;
        }
        return self;
    };
}
-(MHAVFormatShopConfig *(^)(NSString *))MHAVFormatShopOutputFileName
{
    return ^(NSString *fileName){
        
        NSString *name=(fileName.length)?fileName:kSmallMovieFile;
        
        [self setOutputPathURL:[NSURL fileURLWithPath:[[FILEMANAGER getSmallMovieFilePath] stringByAppendingPathComponent:name]]];
        
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
