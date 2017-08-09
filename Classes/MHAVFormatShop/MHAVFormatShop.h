//
//  MHAVFormatShop.h
//  musichome
//
//  Created by J on 2017/7/23.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHAVFormatShopConfig.h"
@interface MHAVFormatShop : NSObject

/**
 单利创建
 */
+ (MHAVFormatShop *) shareFormatShop;


/**
   将目标url转换成小格式工具方法


 @param config 设置
 @param progress 进度
 @param completion 成功回调
 @param failed 失败回调
 */
-(void)exportAVURLAssetWithConfig:(void (^)(MHAVFormatShopConfig *config))config andProgress:(void (^)(float progress))progress andCompletion:(void (^)(MHAVFormatShopConfig *config))completion andFailed:(void (^)())failed;
@end
