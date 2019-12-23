//
//  GeneralMsgContentViewController.m
//  WechatPublicAccount
//
//  Created by mayan on 2019/12/23.
//  Copyright © 2019 mayan. All rights reserved.
//

#import "GeneralMsgContentViewController.h"
#import "AppMsg+CoreDataClass.h"
#import <YYCategories.h>
#import <WebKit/WebKit.h>

@interface GeneralMsgContentViewController ()

@end

@implementation GeneralMsgContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share)];
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.appMsg.content_url]]];
    [self.view addSubview:webView];
}

- (void)share {
    NSString *shareTitle = self.appMsg.title;
    UIImage  *shareImage = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(40, 40)];
    NSURL    *shareUrl   = [NSURL URLWithString:self.appMsg.content_url];
    
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


@end
