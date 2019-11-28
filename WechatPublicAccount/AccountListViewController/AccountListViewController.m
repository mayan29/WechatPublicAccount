//
//  AccountListViewController.m
//  WechatPublicAccount
//
//  Created by mayan on 2019/11/27.
//  Copyright © 2019 mayan. All rights reserved.
//

#import "AccountListViewController.h"
#import "AccountListCell.h"
#import "AccountListManager.h"
#import "GeneralMsgListViewController.h"
#import <MJRefresh.h>

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
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [self fetchAccountsWithIsFromNetwork:YES];
    }];
    
    [self fetchAccountsWithIsFromNetwork:NO];
}


#pragma mark - Pravite Methods

- (void)fetchAccountsWithIsFromNetwork:(BOOL)isFromNetwork {
    [[AccountListManager shareInstance] fetchAccountsWithIds:@[@"wow36kr"] isFromNetwork:isFromNetwork completed:^(NSArray<Account *> *accounts) {
        self.accountArray = accounts;
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
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


@end
