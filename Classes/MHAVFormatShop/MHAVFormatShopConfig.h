//
//  MHAVFormatShopConfig.h
//  musichome
//
//  Created by J on 2017/7/23.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface MHAVFormatShopConfig : NSObject
@property(nonatomic,strong,readonly)AVURLAsset *asset;

@property(nonatomic,copy,readonly)NSString *presetName;

@property(nonatomic,strong,readonly)NSURL *outputPathURL;

@property(nonatomic,copy,readonly)NSString *outputFileType;


@property(nonatomic,copy,readonly)MHAVFormatShopConfig *(^MHAVFormatShopAsset)(AVURLAsset *asset);

@property(nonatomic,copy,readonly)MHAVFormatShopConfig *(^MHAVFormatShopPresetName)(NSString *presetName);

@property(nonatomic,copy,readonly)MHAVFormatShopConfig *(^MHAVFormatShopOutputFileName)(NSString *outputFileName);

@property(nonatomic,copy,readonly)MHAVFormatShopConfig *(^MHAVFormatShopOutputFileType)(NSString *outputFileType);

+(MHAVFormatShopConfig *)defaultConfig;

@end
