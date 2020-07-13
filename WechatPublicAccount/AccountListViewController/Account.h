//
//  Account.h
//  WechatPublicAccount
//
//  Created by mayan on 2020/7/13.
//  Copyright © 2020 mayan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Account : NSObject

@property (nonatomic, readonly, copy) NSString *id;
@property (nonatomic, readonly, copy) NSString *nick_name;
@property (nonatomic, readonly, copy) NSString *desc;
@property (nonatomic, readonly, copy) NSString *head_img_url;
@property (nonatomic, readonly, copy) NSString *zip_url;
@property (nonatomic, readonly, copy) NSString *last_date_time;

+ (NSArray<Account *> *)fetchAccountArray;

@end

NS_ASSUME_NONNULL_END
