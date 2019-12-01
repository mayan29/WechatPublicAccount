//
//  GeneralMsgListHeaderView.h
//  WechatPublicAccount
//
//  Created by 马岩 on 2019/12/1.
//  Copyright © 2019 mayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GeneralMsgListHeaderView : UITableViewHeaderFooterView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView datetime:(NSString *)datetime;

@end

NS_ASSUME_NONNULL_END
