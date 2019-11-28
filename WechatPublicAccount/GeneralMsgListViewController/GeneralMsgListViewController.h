//
//  GeneralMsgListViewController.h
//  WechatPublicAccount
//
//  Created by mayan on 2019/11/27.
//  Copyright © 2019 mayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Account;
@interface GeneralMsgListViewController : UITableViewController

@property (nonatomic, strong) Account *account;

@end

NS_ASSUME_NONNULL_END
