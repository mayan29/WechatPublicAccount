//
//  GeneralMsgListViewController.m
//  WechatPublicAccount
//
//  Created by mayan on 2019/11/27.
//  Copyright © 2019 mayan. All rights reserved.
//

#import "GeneralMsgListViewController.h"
#import "GeneralMsgListCell.h"
#import "GeneralMsgListManager.h"
#import "Account+CoreDataClass.h"
#import <MJRefresh.h>

@interface GeneralMsgListViewController ()

@property (nonatomic, strong) NSArray<GeneralMsg *> *generalMsgArray;

@end

@implementation GeneralMsgListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.account.nick_name;
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80.f;
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [self fetchGeneralMsgArrayWithIsFromNetwork:YES];
    }];
    
    [self fetchGeneralMsgArrayWithIsFromNetwork:NO];
}


#pragma mark - Pravite Methods

- (void)fetchGeneralMsgArrayWithIsFromNetwork:(BOOL)isFromNetwork {
    [[GeneralMsgListManager shareInstance] fetchGeneralMsgListWithId:self.account.id isFromNetwork:isFromNetwork completed:^(NSArray<GeneralMsg *> * _Nonnull generalMsgs, NSError * _Nonnull error) {
        self.generalMsgArray = generalMsgs;
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.generalMsgArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.generalMsgArray[section].app_msg_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GeneralMsgListCell *cell = [GeneralMsgListCell cellWithTableView:tableView];
    cell.textLabel.text = @"bbb";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
