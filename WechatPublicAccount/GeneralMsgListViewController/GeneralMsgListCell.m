//
//  GeneralMsgListCell.m
//  WechatPublicAccount
//
//  Created by mayan on 2019/11/27.
//  Copyright © 2019 mayan. All rights reserved.
//

#import "GeneralMsgListCell.h"
#import "AppMsg+CoreDataClass.h"

@interface GeneralMsgListCell ()

@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) AppMsg *appMsg;

@end

@implementation GeneralMsgListCell

#pragma mark - Init

+ (instancetype)cellWithTableView:(UITableView *)tableView appMsg:(AppMsg *)appMsg {
    static NSString *identifier = @"GeneralMsgListCell";
    GeneralMsgListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GeneralMsgListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.appMsg = appMsg;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.numberOfLines = 0;
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.textColor = UIColor.darkGrayColor;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [touches.anyObject locationInView:self];
    if (CGRectContainsPoint(self.imageView.frame, point)) {
        if (self.imageViewClickBlock) {
            self.imageViewClickBlock(self.appMsg.cover);
        }
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}


#pragma mark - Setter

- (void)setAppMsg:(AppMsg *)appMsg {
    _appMsg = appMsg;
    
    self.imageView.hidden = !appMsg.cover;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:appMsg.cover] placeholderImage:self.placeholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        CGSize imageSize = image ? self.placeholderImage.size : CGSizeZero;
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, UIScreen.mainScreen.scale);
        [self.imageView.image drawInRect:CGRectMake(0.f, 0.f, imageSize.width, imageSize.height)];
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }];
    self.textLabel.text = appMsg.title ?: appMsg.content;
    self.detailTextLabel.text = appMsg.digest;    
}


#pragma mark - Lazy Load

- (UIImage *)placeholderImage {
    if (!_placeholderImage) {
        _placeholderImage = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(40, 40)];
    }
    return _placeholderImage;
}


@end
