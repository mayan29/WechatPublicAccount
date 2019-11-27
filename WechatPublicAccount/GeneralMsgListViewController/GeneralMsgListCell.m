//
//  GeneralMsgListCell.m
//  WechatPublicAccount
//
//  Created by mayan on 2019/11/27.
//  Copyright © 2019 mayan. All rights reserved.
//

#import "GeneralMsgListCell.h"

@implementation GeneralMsgListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"GeneralMsgListCell";
    GeneralMsgListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GeneralMsgListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}


@end
