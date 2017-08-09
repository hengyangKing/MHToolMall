//
//  MHAVFormatShop.m
//  musichome
//
//  Created by J on 2017/7/23.
//  Copyright © 2017年 J. All rights reserved.
//

#import "MHAVFormatShop.h"
@interface MHAVFormatShop()
{
    AVAssetExportSession *_exportSession;
}

/**
 *  计时器
 */
@property(nonatomic,strong)CADisplayLink *linkTimer;
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
-(void)exportAVURLAssetWithConfig:(void (^)(MHAVFormatShopConfig *config))config andProgress:(void (^)(float progress))progress andCompletion:(void (^)(MHAVFormatShopConfig *config))completion andFailed:(void (^)())failed
{
    [self setProgressBlcok:progress];
    if (config) {
        MHAVFormatShopConfig *exportConfig=[MHAVFormatShopConfig defaultConfig];
        config(exportConfig);
        
        if (!exportConfig.asset) {
            if (failed) {
                failed();
            }
            return;
        }
        
        AVURLAsset* myAsset=exportConfig.asset;
        NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:myAsset];
        if ([compatiblePresets containsObject:exportConfig.presetName]) {
            _exportSession=[[AVAssetExportSession alloc] initWithAsset:myAsset presetName:exportConfig.presetName];
            
            _exportSession.outputURL = exportConfig.outputPathURL;
            _exportSession.outputFileType = exportConfig.outputFileType;
            _exportSession.shouldOptimizeForNetworkUse = YES;
            
            // 关闭定时器
            [self.linkTimer invalidate];
            _linkTimer=nil;
            [self.linkTimer setPaused:NO];

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [_exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
                    switch (_exportSession.status) {
                        case AVAssetExportSessionStatusUnknown:
                            NSLog(@"AVAssetExportSessionStatusUnknown");
                            [self.linkTimer invalidate];
                            _linkTimer=nil;
                            break;
                        case AVAssetExportSessionStatusWaiting:
                            NSLog(@"AVAssetExportSessionStatusWaiting"); break;
                        case AVAssetExportSessionStatusExporting:
                            NSLog(@"AVAssetExportSessionStatusExporting");
                            [self.linkTimer invalidate];
                            _linkTimer=nil;
                            break;
                            
                        case AVAssetExportSessionStatusCompleted:
                            NSLog(@"AVAssetExportSessionStatusCompleted");
                            [self.linkTimer invalidate];
                            _linkTimer=nil;
                            if (completion) {
                                completion(exportConfig);
                            }
                            break;
                        case AVAssetExportSessionStatusFailed:
                            NSLog(@"AVAssetExportSessionStatusFailed");
                            [self.linkTimer invalidate];
                            _linkTimer=nil;
                            if (failed){
                                failed();
                            }
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
-(void)timerAction{
    
    if (self.progressBlcok) {
        self.progressBlcok(_exportSession.progress);
    }
}
@end
