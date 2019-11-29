//
//  CoreDataManager.m
//  WechatPublicAccount
//
//  Created by mayan on 2019/11/27.
//  Copyright © 2019 mayan. All rights reserved.
//

#import "CoreDataManager.h"
#import <MagicalRecord/MagicalRecord.h>

@implementation CoreDataManager

#pragma mark - Init

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)setupCoreDataStack {
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"WechatPublicAccount"];
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelWarn];
    
    NSLog(@"%@", NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject);
}

- (void)cleanUp {
    [MagicalRecord cleanUp];
}


#pragma mark - Public Methods

- (void)updateAccountsWithDataArray:(NSArray *)dataArray completed:(nonnull CoreDataManagerSaveCompletionHandler)completedBlock {
    [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        for (NSDictionary *data in dataArray) {
            Account *account = [Account MR_findFirstByAttribute:@"id" withValue:data[@"id"] inContext:localContext] ?: [Account MR_createEntityInContext:localContext];
            account.id             = data[@"id"];
            account.nick_name      = data[@"nick_name"];
            account.desc           = data[@"desc"];
            account.head_img_url   = data[@"head_img_url"];
            account.zip_url        = data[@"zip_url"];
            account.last_date_time = data[@"last_date_time"];
        }
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (completedBlock) {
            completedBlock(contextDidSave, error);
        }
    }];
}

- (NSArray<Account *> *)accounts {
    return [Account MR_findAll];
}

- (void)updateGeneralMsgsWithDataArray:(NSArray *)dataArray completed:(CoreDataManagerSaveCompletionHandler)completedBlock {
    
}

- (NSArray<GeneralMsg *> *)generalMsgs {
    return @[];
}


@end
