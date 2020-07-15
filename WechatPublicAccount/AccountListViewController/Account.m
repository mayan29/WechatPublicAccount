//
//  Account.m
//  WechatPublicAccount
//
//  Created by mayan on 2020/7/13.
//  Copyright © 2020 mayan. All rights reserved.
//

#import "Account.h"
#import "MJExtension.h"

@implementation Account

+ (NSArray<Account *> *)fetchAccountArray {
    NSArray *dictArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AccountList" ofType:@"plist"]];
    return [Account mj_objectArrayWithKeyValuesArray:dictArray];
}

@end
