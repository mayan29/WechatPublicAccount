//
//  AccountListViewController.m
//  WechatPublicAccount
//
//  Created by mayan on 2019/11/27.
//  Copyright © 2019 mayan. All rights reserved.
//

#import "AccountListViewController.h"
#import "AccountListCell.h"
#import "GeneralMsgListViewController.h"

@interface AccountListViewController ()

@end

@implementation AccountListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountListCell *cell = [AccountListCell cellWithTableView:tableView];
    cell.textLabel.text = @"aaa";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GeneralMsgListViewController *vc = [[GeneralMsgListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
