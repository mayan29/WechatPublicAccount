//
//  GeneralMsgListImageViewController.m
//  WechatPublicAccount
//
//  Created by 马岩 on 2019/12/1.
//  Copyright © 2019 mayan. All rights reserved.
//

#import "GeneralMsgListImageViewController.h"

@interface GeneralMsgListImageViewController ()

@end

@implementation GeneralMsgListImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.blackColor;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.cover]];
    [self.view addSubview:imageView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:NO completion:nil];
}


@end
