//
//  iNDSRomDownloadManager.h
//  iNDS
//
//  Created by Will Cobb on 11/17/15.
//  Copyright © 2015 iNDS. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RomDownload;

@interface RomDownloadManager : NSObject

@property (strong, readonly) NSMutableArray * activeDownloads;

+ (id)sharedManager;
- (void)addRequest:(NSURLRequest *)request;
- (void)removeDownload:(RomDownload *)download;
@end

@interface RomDownload : NSObject {
    NSURLConnection * _connection;
    
    long long expectedBytes;
    float progress;
    
    RomDownloadManager *_delegate;
    NSFileHandle *fileHandle;
    NSString * savePath;
    NSURL * escapedPath;
}

@property (weak, nonatomic)UILabel * progressLabel;
@property (weak, nonatomic)CALayer * progressLayer;

- (id)initWithRequest:(NSURLRequest *)request delegate:(RomDownloadManager *)delegate;
- (float)progress;
- (NSString *)name;

@end