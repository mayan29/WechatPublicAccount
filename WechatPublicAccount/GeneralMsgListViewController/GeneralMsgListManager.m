//
//  GeneralMsgListManager.m
//  WechatPublicAccount
//
//  Created by mayan on 2019/11/28.
//  Copyright © 2019 mayan. All rights reserved.
//

#import "GeneralMsgListManager.h"
#import <AFNetworking.h>
#import <SSZipArchive.h>
#import "CoreDataManager.h"

@implementation GeneralMsgListManager

#pragma mark - Init

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


#pragma mark - Public Methods

- (void)fetchGeneralMsgListWithId:(NSString *)accountId isFromNetwork:(BOOL)isFromNetwork completed:(void (^)(NSArray<GeneralMsg *> * _Nonnull, NSError * _Nonnull))completedBlock {
    if (isFromNetwork) {
        [self downloadZipWithId:accountId completed:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
            
            if (error && completedBlock) {
              completedBlock(@[], error);
            }
            
            NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
            NSString *zipPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip", accountId]];
            NSString *unzipPath = [documentsPath stringByAppendingPathComponent:accountId];
            
            [SSZipArchive unzipFileAtPath:zipPath toDestination:documentsPath progressHandler:nil completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
                
                if (error && completedBlock) {
                  completedBlock(@[], error);
                }
                
                NSArray *dir = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:unzipPath error:nil];
                
                NSMutableArray *responseObjects = [NSMutableArray array];
                for (NSString *path in dir) {
                    NSData *data = [NSData dataWithContentsOfFile:[unzipPath stringByAppendingPathComponent:path]];
                    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    if (responseObject) {
                        data = [responseObject[@"general_msg_list"] dataUsingEncoding:NSUTF8StringEncoding];
                        responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                        [responseObjects addObjectsFromArray:responseObject[@"list"]];
                    }
                }
                
                [[CoreDataManager shareInstance] updateGeneralMsgsWithDataArray:responseObjects completed:^(BOOL contextDidSave, NSError * _Nullable error) {
                    if (completedBlock) {
                        completedBlock([[CoreDataManager shareInstance] generalMsgs], error);
                    }
                }];
            }];
        }];
    }
}


#pragma mark - Pravite Methods

// 下载压缩包，并保存到 Documents 中
- (void)downloadZipWithId:(NSString *)accountId completed:(nonnull void (^)(NSURLResponse * _Nonnull, NSURL * _Nonnull, NSError * _Nonnull))completedBlock {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://mayan29.oss-cn-beijing.aliyuncs.com/wechat-public-account/zip/%@.zip", accountId]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];

    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (completedBlock) {
            completedBlock(response, filePath, error);
        }
    }];
    [downloadTask resume];
}


@end
