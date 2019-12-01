//
//  GeneralMsgListViewController.m
//  WechatPublicAccount
//
//  Created by mayan on 2019/11/27.
//  Copyright © 2019 mayan. All rights reserved.
//

#import "GeneralMsgListViewController.h"
#import "GeneralMsgListCell.h"
#import "GeneralMsgListHeaderView.h"
#import "GeneralMsgListManager.h"
#import "Account+CoreDataClass.h"
#import <YYCategories.h>

@interface GeneralMsgListViewController ()

@property (nonatomic, strong) NSMutableArray<GeneralMsg *> *generalMsgArray;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSArray<AppMsg *> *> *appMsgListMap;

@end

@implementation GeneralMsgListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.account.nick_name;
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 150.f;
    self.tableView.sectionHeaderHeight = 40.f;

    self.tableView.refreshControl = [[UIRefreshControl alloc] init];
    self.tableView.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [self.tableView.refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    
    [self fetchGeneralMsgArrayWithIsFromNetwork:NO];
}


#pragma mark - Pravite Methods

- (void)refreshAction {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"是否从远端获取数据？" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self fetchGeneralMsgArrayWithIsFromNetwork:NO];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self fetchGeneralMsgArrayWithIsFromNetwork:YES];
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)fetchGeneralMsgArrayWithIsFromNetwork:(BOOL)isFromNetwork {
    [[GeneralMsgListManager shareInstance] fetchGeneralMsgListWithId:self.account.id isFromNetwork:isFromNetwork completed:^(NSArray<GeneralMsg *> * _Nonnull generalMsgs, NSError * _Nonnull error) {
        self.generalMsgArray = generalMsgs.mutableCopy;
        [self.tableView.refreshControl endRefreshing];
        [self.tableView reloadData];
    }];
}

- (NSArray<AppMsg *> *)appMsgArrayWithGeneralMsg:(GeneralMsg *)generalMsg {
    if (!self.appMsgListMap[generalMsg.id]) {
        NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"p_orderNo" ascending:YES];
        self.appMsgListMap[generalMsg.id] = [generalMsg.app_msg_list sortedArrayUsingDescriptors:@[sd]];
    }
    return self.appMsgListMap[generalMsg.id];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.generalMsgArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.generalMsgArray[section].app_msg_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GeneralMsg *generalMsg = self.generalMsgArray[indexPath.section];
    AppMsg *appMsg = [self appMsgArrayWithGeneralMsg:generalMsg][indexPath.row];
    GeneralMsgListCell *cell = [GeneralMsgListCell cellWithTableView:tableView appMsg:appMsg];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GeneralMsg *generalMsg = self.generalMsgArray[indexPath.section];
    AppMsg *appMsg = [self appMsgArrayWithGeneralMsg:generalMsg][indexPath.row];
    
    if (appMsg.content_url.length == 0) return;
    
    NSString *shareTitle = appMsg.title;
    UIImage *shareImage = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(40, 40)];
    NSURL *shareUrl = [NSURL URLWithString:appMsg.content_url];
    
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:@[shareTitle, shareImage, shareUrl] applicationActivities:nil];
    vc.excludedActivityTypes = @[
        UIActivityTypePostToFacebook,
        UIActivityTypePostToTwitter,
        UIActivityTypePostToWeibo,
        UIActivityTypeMessage,
        UIActivityTypeMail,
        UIActivityTypeAddToReadingList,
        UIActivityTypePostToFlickr,
        UIActivityTypePostToVimeo,
        UIActivityTypePostToTencentWeibo
    ];
    [self presentViewController:vc animated:YES completion:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GeneralMsg *generalMsg = self.generalMsgArray[section];
    return [GeneralMsgListHeaderView headerViewWithTableView:tableView datetime:generalMsg.datetime];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
        
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        GeneralMsg *generalMsg = self.generalMsgArray[indexPath.section];
        AppMsg *appMsg = [self appMsgArrayWithGeneralMsg:generalMsg][indexPath.row];
        
        NSString *generalMsgId = generalMsg.id;
        
        [[GeneralMsgListManager shareInstance] deleteAppMsg:appMsg withGeneralMsg:generalMsg completed:^(GeneralMsg * _Nullable newGeneralMsg) {
            
            if (newGeneralMsg) {
                [self.appMsgListMap removeObjectForKey:generalMsgId];
                [self.generalMsgArray replaceObjectAtIndex:[self.generalMsgArray indexOfObject:generalMsg] withObject:newGeneralMsg];
                [tableView reloadSection:indexPath.section withRowAnimation:UITableViewRowAnimationAutomatic];
            } else {
                [self.appMsgListMap removeObjectForKey:generalMsgId];
                [self.generalMsgArray removeObject:generalMsg];
                [tableView deleteSection:indexPath.section withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
    }
}


#pragma mark - Lazy Load

- (NSMutableDictionary<NSString *,NSArray<AppMsg *> *> *)appMsgListMap {
    if (!_appMsgListMap) {
        _appMsgListMap = [NSMutableDictionary dictionary];
    }
    return _appMsgListMap;
}


@end
