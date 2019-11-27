//
//  GeneralMsgListViewController.m
//  WechatPublicAccount
//
//  Created by mayan on 2019/11/27.
//  Copyright © 2019 mayan. All rights reserved.
//

#import "GeneralMsgListViewController.h"
#import "GeneralMsgListCell.h"

@interface GeneralMsgListViewController ()

@end

@implementation GeneralMsgListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GeneralMsgListCell *cell = [GeneralMsgListCell cellWithTableView:tableView];
    cell.textLabel.text = @"bbb";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GeneralMsgListViewController *vc = [[GeneralMsgListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
