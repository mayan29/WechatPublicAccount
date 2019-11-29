//
//  GeneralMsgListManager.h
//  WechatPublicAccount
//
//  Created by mayan on 2019/11/28.
//  Copyright © 2019 mayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeneralMsg+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface GeneralMsgListManager : NSObject

+ (instancetype)shareInstance;

- (void)fetchGeneralMsgListWithId:(NSString *)accountId isFromNetwork:(BOOL)isFromNetwork completed:(void (^)(NSArray<GeneralMsg *> *, NSError *))completedBlock;

@end

NS_ASSUME_NONNULL_END
