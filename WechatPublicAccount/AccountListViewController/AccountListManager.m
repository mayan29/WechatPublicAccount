//
//  AccountListManager.m
//  WechatPublicAccount
//
//  Created by mayan on 2019/11/27.
//  Copyright © 2019 mayan. All rights reserved.
//

#import "AccountListManager.h"
#import <AFNetworking.h>
#import "CoreDataManager.h"

@implementation AccountListManager

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

- (void)fetchAccountsWithIds:(NSArray<NSString *> *)accountIds isFromNetwork:(BOOL)isFromNetwork completed:(void (^)(NSArray<Account *> * _Nonnull))completedBlock {
    if (isFromNetwork) {
        dispatch_group_t group = dispatch_group_create();
        
        NSMutableArray *responseObjects = [NSMutableArray arrayWithCapacity:accountIds.count];
        for (NSString *accountId in accountIds) {
            dispatch_group_enter(group);
            
            NSString *url = [NSString stringWithFormat:@"https://mayan29.oss-cn-beijing.aliyuncs.com/wechat-public-account/info/%@.json", accountId];
            [[AFHTTPSessionManager manager] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [responseObjects addObject:responseObject];
                dispatch_group_leave(group);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                dispatch_group_leave(group);
            }];
        }

        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [[CoreDataManager shareInstance] updateAccountsWithDataArray:responseObjects completed:^(BOOL contextDidSave, NSError * _Nullable error) {
                if (completedBlock) {
                    completedBlock([[CoreDataManager shareInstance] accounts]);
                }
            }];
        });
    } else {
        if (completedBlock) {
            completedBlock([[CoreDataManager shareInstance] accounts]);
        }
    }
}


@end
