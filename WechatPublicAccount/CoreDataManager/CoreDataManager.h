//
//  CoreDataManager.h
//  WechatPublicAccount
//
//  Created by mayan on 2019/11/27.
//  Copyright © 2019 mayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"
#import "GeneralMsg+CoreDataClass.h"
#import "AppMsg+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^CoreDataManagerSaveCompletionHandler)(BOOL contextDidSave, NSError * __nullable error);

@interface CoreDataManager : NSObject

+ (instancetype)shareInstance;

- (void)setupCoreDataStack;
- (void)cleanUp;

- (void)updateGeneralMsgsWithDataArray:(NSArray *)dataArray accountId:(NSString *)accountId completed:(CoreDataManagerSaveCompletionHandler)completedBlock;
- (NSArray<GeneralMsg *> *)generalMsgsWithAccountId:(NSString *)accountId;
- (void)deleteAppMsg:(AppMsg *)appMsg withGeneralMsg:(GeneralMsg *)generalMsg completed:(void (^)(GeneralMsg * _Nullable))completedBlock;

@end

NS_ASSUME_NONNULL_END
