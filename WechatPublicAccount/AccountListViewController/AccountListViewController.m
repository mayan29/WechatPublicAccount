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
    
    self.tableView.refreshControl = [[UIRefreshControl alloc] init];
    self.tableView.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [self.tableView.refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    
    [self fetchAccountsWithIsFromNetwork:NO];
}


#pragma mark - Pravite Methods

- (void)refreshAction {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"是否从远端获取数据？" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self fetchAccountsWithIsFromNetwork:NO];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self fetchAccountsWithIsFromNetwork:YES];
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)fetchAccountsWithIsFromNetwork:(BOOL)isFromNetwork {
    [[AccountListManager shareInstance] fetchAccountsWithIds:@[@"wow36kr"] isFromNetwork:isFromNetwork completed:^(NSArray<Account *> *accounts) {
        self.accountArray = accounts;
        [self.tableView.refreshControl endRefreshing];
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
