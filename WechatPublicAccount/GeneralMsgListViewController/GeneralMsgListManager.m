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

- (void)fetchGeneralMsgListWithId:(NSString *)accountId isFromNetwork:(BOOL)isFromNetwork completed:(void (^)(NSArray<GeneralMsg *> * _Nonnull, NSError * __nullable))completedBlock {
    if (isFromNetwork) {
        NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *zipPath = [[NSBundle mainBundle] pathForResource:accountId ofType:@"zip"];
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
            
            [[CoreDataManager shareInstance] updateGeneralMsgsWithDataArray:responseObjects accountId:accountId completed:^(BOOL contextDidSave, NSError * _Nullable error) {
                if (completedBlock) {
                    completedBlock([[CoreDataManager shareInstance] generalMsgsWithAccountId:accountId], error);
                }
            }];
        }];
    } else {
        if (completedBlock) {
            completedBlock([[CoreDataManager shareInstance] generalMsgsWithAccountId:accountId], nil);
        }
    }
}

- (void)deleteAppMsg:(AppMsg *)appMsg withGeneralMsg:(GeneralMsg *)generalMsg completed:(void (^)(GeneralMsg * _Nullable))completedBlock {
    [[CoreDataManager shareInstance] deleteAppMsg:appMsg withGeneralMsg:generalMsg completed:^(GeneralMsg * _Nullable newGeneralMsg) {
        if (completedBlock) {
            completedBlock(newGeneralMsg);
        }
    }];
}


@end
