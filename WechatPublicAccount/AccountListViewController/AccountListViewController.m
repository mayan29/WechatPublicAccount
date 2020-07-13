//
//  AccountListViewController.m
//  WechatPublicAccount
//
//  Created by mayan on 2019/11/27.
//  Copyright © 2019 mayan. All rights reserved.
//

#import "AccountListViewController.h"
#import "AccountListCell.h"
#import "Account.h"
#import "GeneralMsgListViewController.h"

@interface AccountListViewController ()

@property (nonatomic, strong) NSArray<Account *> *accountArray;
 
@end

@implementation AccountListViewController

#pragma mark - Init

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80.f;
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.accountArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [AccountListCell cellWithTableView:tableView account:self.accountArray[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GeneralMsgListViewController *vc = [[GeneralMsgListViewController alloc] init];
    vc.account = self.accountArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Lazy Load

- (NSArray<Account *> *)accountArray {
    if (!_accountArray) {
        _accountArray = [Account fetchAccountArray];
    }
    return _accountArray;
}


@end
