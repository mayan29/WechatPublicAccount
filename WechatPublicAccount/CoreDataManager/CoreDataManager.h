//
//  CoreDataManager.h
//  WechatPublicAccount
//
//  Created by mayan on 2019/11/27.
//  Copyright © 2019 mayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^CoreDataManagerSaveCompletionHandler)(BOOL contextDidSave, NSError * __nullable error);

@interface CoreDataManager : NSObject

+ (instancetype)shareInstance;

- (void)setupCoreDataStack;
- (void)cleanUp;

- (void)updateAccountsWithDataArray:(NSArray *)dataArray completed:(CoreDataManagerSaveCompletionHandler)completedBlock;
- (NSArray<Account *> *)accounts;

@end

NS_ASSUME_NONNULL_END
