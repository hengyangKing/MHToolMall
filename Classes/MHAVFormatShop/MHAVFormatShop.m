//
//  MHAVFormatShop.m
//  musichome
//
//  Created by J on 2017/7/23.
//  Copyright © 2017年 J. All rights reserved.
//

#import "MHAVFormatShop.h"
@interface MHAVFormatShop()

/**
 *  计时器
 */
@property(nonatomic,strong)CADisplayLink *linkTimer;
@property(nonatomic,strong)AVAssetExportSession *exportSession;
@property(nonatomic,copy)void (^progressBlcok)(float progress);

@end
@implementation MHAVFormatShop

//单例创建
+ (MHAVFormatShop *) shareFormatShop{
    static MHAVFormatShop *formatShop;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatShop = [[MHAVFormatShop alloc] init];
    });
    return formatShop;
}

-(CADisplayLink *)linkTimer
{
    if (!_linkTimer) {
        _linkTimer=[CADisplayLink displayLinkWithTarget:self selector:@selector(timerAction)];
        [_linkTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return _linkTimer;
}
-(void)exportAVURLAssetWithConfig:(void (^)(MHAVFormatShopConfig *config))config andProgress:(void (^)(float progress))progress andCompletion:(void (^)(MHAVFormatShopConfig *config))completion andFailed:(void (^)(void))failed {
    [self setProgressBlcok:progress];
    if (config) {
        MHAVFormatShopConfig *exportConfig=[MHAVFormatShopConfig defaultConfig];
        config(exportConfig);
        
        if (!exportConfig.asset) {
            !failed?:failed();
            return;
        }
        
        AVURLAsset* myAsset=exportConfig.asset;
        NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:myAsset];
        if ([compatiblePresets containsObject:exportConfig.presetName]) {
            self.exportSession=[[AVAssetExportSession alloc] initWithAsset:myAsset presetName:exportConfig.presetName];
            
            self.exportSession.outputURL = exportConfig.outputPathURL;
            self.exportSession.outputFileType = exportConfig.outputFileType;
            self.exportSession.shouldOptimizeForNetworkUse = YES;
            
            // 关闭定时器
            [self deallocTime];
            [self.linkTimer setPaused:NO];
            
            __weak typeof(self) weakself = self;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [weakself.exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
                    switch (weakself.exportSession.status) {
                        case AVAssetExportSessionStatusUnknown:
                            NSLog(@"AVAssetExportSessionStatusUnknown");
                            [weakself deallocTime];
                            break;
                        case AVAssetExportSessionStatusWaiting:
                            NSLog(@"AVAssetExportSessionStatusWaiting"); break;
                        case AVAssetExportSessionStatusExporting:
                            NSLog(@"AVAssetExportSessionStatusExporting");
                            [weakself deallocTime];
                            break;
                            
                        case AVAssetExportSessionStatusCompleted:
                            NSLog(@"AVAssetExportSessionStatusCompleted");
                            [weakself deallocTime];
                            !completion?:completion(exportConfig);
                            break;
                        case AVAssetExportSessionStatusFailed:
                            NSLog(@"AVAssetExportSessionStatusFailed");
                            [weakself deallocTime];
                            !failed?:failed();
                            break;
                        default: break;
                    }
                }];
            });
        }else{
            if (failed) {
                failed();
            }
        }
    }else{
        if (failed) {
            failed();
        }
    }
}
-(void)deallocTime {
    [self.linkTimer invalidate];
    self.linkTimer=nil;
}
-(void)timerAction{
    
    if (self.progressBlcok) {
        self.progressBlcok(self.exportSession.progress);
    }
}
@end
