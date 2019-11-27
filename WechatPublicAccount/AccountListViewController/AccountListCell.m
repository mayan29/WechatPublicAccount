//
//  AccountListCell.m
//  WechatPublicAccount
//
//  Created by mayan on 2019/11/27.
//  Copyright © 2019 mayan. All rights reserved.
//

#import "AccountListCell.h"

@implementation AccountListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"AccountListCell";
    AccountListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AccountListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}


@end
