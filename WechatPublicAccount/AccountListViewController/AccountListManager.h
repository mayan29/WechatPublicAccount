//
//  AccountListManager.h
//  WechatPublicAccount
//
//  Created by mayan on 2019/11/27.
//  Copyright © 2019 mayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccountListManager : NSObject

+ (instancetype)shareInstance;

- (void)fetchAccountsWithIds:(NSArray<NSString *> *)accountIds isFromNetwork:(BOOL)isFromNetwork completed:(void (^)(NSArray<Account *> *))completedBlock;

@end

NS_ASSUME_NONNULL_END
