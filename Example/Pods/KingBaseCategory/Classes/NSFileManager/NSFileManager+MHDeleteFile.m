//
//  NSFileManager+MHDeleteFile.m
//  musichome
//
//  Created by J on 2017/8/2.
//  Copyright © 2017年 J. All rights reserved.
//

#import "NSFileManager+MHDeleteFile.h"
#import "NSFileManager+MHFilePath.h"
#import "NSFileManager+MHFileHelper.h"
#import <WebKit/WebKit.h>
@implementation NSFileManager (MHDeleteFile)
-(BOOL)deleteRecordAudioFile
{
    NSString *filePath=[NSString stringWithFormat:@"%@/MusicHomeRecorder/%@",[self getMusicHomeCachePath],kRecordAudioFile];
    return [self deleteFile:filePath];
}
-(BOOL)deleteRecordVideoFile
{
    NSString *filePath=[NSString stringWithFormat:@"%@/MusicHomeMovie/%@",[self getMusicHomeCachePath],kMovieFile];
    return  [self deleteFile:filePath];
}
-(BOOL)deleteUserFoundSmallMovieFile
{
    NSString *filePath=[NSString stringWithFormat:@"%@/MusicHomeSmallMovie/",[self getMusicHomeCachePath]];
    filePath=[filePath stringByAppendingPathComponent:kSmallMovieFile];
    return [self deleteFile:filePath];
}
-(BOOL)deleteIpodCachesFiles {
    return [self deleteFile:[self getIpodFilePath]];
}
-(void)clearWebCache
{
    
    if (@available(iOS 9.0, *)) {
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:[WKWebsiteDataStore allWebsiteDataTypes] modifiedSince:[NSDate dateWithTimeIntervalSince1970:0] completionHandler:^{
            
        }];
        
    } else {
        NSString *libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                                   NSUserDomainMask, YES)[0];
        NSString *bundleId  =  [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleIdentifier"];
        NSString *webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
        NSString *webKitFolderInCaches = [NSString
                                          stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];
        NSError *error;
        /* iOS8.0 WebView Cache的存放路径 */
        [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
        [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];
    }
}


@end
