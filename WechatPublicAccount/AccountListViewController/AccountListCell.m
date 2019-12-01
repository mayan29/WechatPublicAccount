//
//  AccountListCell.m
//  WechatPublicAccount
//
//  Created by mayan on 2019/11/27.
//  Copyright © 2019 mayan. All rights reserved.
//

#import "AccountListCell.h"
#import "Account+CoreDataClass.h"
#import <YYCategories.h>
#import <SDWebImage.h>

@interface AccountListCell ()

@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) Account *account;

@end

@implementation AccountListCell

#pragma mark - Init

+ (instancetype)cellWithTableView:(UITableView *)tableView account:(nonnull Account *)account {
    static NSString *identifier = @"AccountListCell";
    AccountListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AccountListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.account = account;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.textColor = UIColor.darkGrayColor;
    }
    return self;
}

- (void)layoutSubviews {
    UIImage *image = self.imageView.image;
    self.imageView.image = self.placeholderImage;
    [super layoutSubviews];
    self.imageView.image = image;
}


#pragma mark - Setter

- (void)setAccount:(Account *)account {
    _account = account;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:account.head_img_url] placeholderImage:self.placeholderImage];
    self.textLabel.text = account.nick_name;
    self.detailTextLabel.text = account.desc;
}


#pragma mark - Lazy Load

- (UIImage *)placeholderImage {
    if (!_placeholderImage) {
        _placeholderImage = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(40, 40)];
    }
    return _placeholderImage;
}


@end
