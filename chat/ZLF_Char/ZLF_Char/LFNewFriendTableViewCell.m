//
//  LFNewFriendTableViewCell.m
//  ZLF_Char
//
//  Created by ibokan on 15/12/1.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFNewFriendTableViewCell.h"

@interface LFNewFriendTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation LFNewFriendTableViewCell

- (void)setCell:(NSString *)name {
    self.nameLabel.text = name;
}

- (void)awakeFromNib {
    // 设置头像圆角
    self.iconView.layer.cornerRadius = self.iconView.frame.size.width * 0.5;
    self.iconView.layer.masksToBounds = YES;
    // 设置白色圆圈
    self.iconView.layer.borderWidth = 2;
    self.iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    // 设置头像背景圆角
    self.bgImageView.layer.cornerRadius = self.bgImageView.frame.size.width * 0.5;
    self.bgImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
