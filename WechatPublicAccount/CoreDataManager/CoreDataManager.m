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

- (void)updateGeneralMsgsWithDataArray:(NSArray *)dataArray accountId:(NSString *)accountId completed:(CoreDataManagerSaveCompletionHandler)completedBlock {
    [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        for (NSDictionary *data in dataArray) {
            if (![GeneralMsg MR_findFirstByAttribute:@"id" withValue:data[@"comm_msg_info"][@"id"]]) {
                
                NSDictionary *comm_msg_info      = data[@"comm_msg_info"];
                NSDictionary *image_msg_ext_info = data[@"image_msg_ext_info"];
                NSDictionary *app_msg_ext_info   = data[@"app_msg_ext_info"];
                
                GeneralMsg *generalMsg = [GeneralMsg MR_createEntityInContext:localContext];
                generalMsg.id       = [NSString stringWithFormat:@"%@", comm_msg_info[@"id"]];
                generalMsg.datetime = [NSString stringWithFormat:@"%@", comm_msg_info[@"datetime"]];
                generalMsg.type     = [NSString stringWithFormat:@"%@", comm_msg_info[@"type"]];
                generalMsg.p_wxId   = accountId;
                
                if ([comm_msg_info[@"content"] length] > 0) {
                    AppMsg *appMsg = [AppMsg MR_createEntityInContext:localContext];
                    appMsg.content        = comm_msg_info[@"content"];
                    appMsg.p_generalMsgId = generalMsg.id;
                    appMsg.p_orderNo      = 0;
                    
                    [generalMsg addApp_msg_listObject:appMsg];
                }
                
                if (image_msg_ext_info) {
                    AppMsg *appMsg = [AppMsg MR_createEntityInContext:localContext];
                    appMsg.content_url    = image_msg_ext_info[@"cdn_url"];
                    appMsg.cover          = image_msg_ext_info[@"cdn_url"];
                    appMsg.p_generalMsgId = generalMsg.id;
                    appMsg.p_orderNo      = 1;
                    
                    [generalMsg addApp_msg_listObject:appMsg];
                }
                
                if (app_msg_ext_info) {
                    // 可能 app_msg_ext_info 为空，但是 multi_app_msg_item_list 中有数据
                    if ([app_msg_ext_info[@"content_url"] length]) {
                        AppMsg *appMsg = [AppMsg MR_createEntityInContext:localContext];
                        appMsg.author         = app_msg_ext_info[@"author"];
                        appMsg.content        = app_msg_ext_info[@"content"];
                        appMsg.content_url    = app_msg_ext_info[@"content_url"];
                        appMsg.copyright_stat = [NSString stringWithFormat:@"%@", app_msg_ext_info[@"copyright_stat"]];
                        appMsg.cover          = app_msg_ext_info[@"cover"];
                        appMsg.digest         = app_msg_ext_info[@"digest"];
                        appMsg.title          = app_msg_ext_info[@"title"];
                        appMsg.p_generalMsgId = generalMsg.id;
                        appMsg.p_orderNo      = 2;
                        
                        [generalMsg addApp_msg_listObject:appMsg];
                    }
                    
                    NSArray *multi_app_msg_item_list = app_msg_ext_info[@"multi_app_msg_item_list"];
                    if (multi_app_msg_item_list) {
                        for (int i = 0; i < multi_app_msg_item_list.count; i++) {
                            NSDictionary *multi_app_msg_item = multi_app_msg_item_list[i];
                            
                            AppMsg *appMsg = [AppMsg MR_createEntityInContext:localContext];
                            appMsg.author         = multi_app_msg_item[@"author"];
                            appMsg.content        = multi_app_msg_item[@"content"];
                            appMsg.content_url    = multi_app_msg_item[@"content_url"];
                            appMsg.copyright_stat = [NSString stringWithFormat:@"%@", app_msg_ext_info[@"copyright_stat"]];
                            appMsg.cover          = multi_app_msg_item[@"cover"];
                            appMsg.digest         = multi_app_msg_item[@"digest"];
                            appMsg.title          = multi_app_msg_item[@"title"];
                            appMsg.p_generalMsgId = generalMsg.id;
                            appMsg.p_orderNo      = 10 + i;
                            
                            [generalMsg addApp_msg_listObject:appMsg];
                        }
                    }
                }
            }
        }
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (completedBlock) {
            completedBlock(contextDidSave, error);
        }
    }];
}

- (NSArray<GeneralMsg *> *)generalMsgsWithAccountId:(NSString *)accountId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"p_wxId = %@", accountId];
    return [GeneralMsg MR_findAllSortedBy:@"datetime" ascending:YES withPredicate:predicate];
}

- (void)deleteAppMsg:(AppMsg *)appMsg withGeneralMsg:(GeneralMsg *)generalMsg completed:(void (^)(GeneralMsg * _Nullable))completedBlock {
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        if (generalMsg.app_msg_list.count == 1) {
            [generalMsg MR_deleteEntityInContext:localContext];
        } else {
            [generalMsg removeApp_msg_listObject:appMsg];
            [appMsg MR_deleteEntityInContext:localContext];
        }
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", generalMsg.id];
        GeneralMsg *newGeneralMsg = [GeneralMsg MR_findFirstWithPredicate:predicate];
        
        if (completedBlock) {
            completedBlock(newGeneralMsg);
        }
    }];

}


@end
