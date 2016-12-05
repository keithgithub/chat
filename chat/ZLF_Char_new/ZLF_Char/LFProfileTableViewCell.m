//
//  LFProfileTableViewCell.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/26.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFProfileTableViewCell.h"
#import "LFXMPPHelp.h"
#import "XMPPvCardTemp.h"
#import "LFConstant.h"

@interface LFProfileTableViewCell()

/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

/**
 *  姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/**
 *  城市
 */
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

/**
 *  钻石数
 */
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end


@implementation LFProfileTableViewCell

- (void)awakeFromNib {
    // 设置头像圆角
    self.iconView.layer.cornerRadius = self.iconView.frame.size.width * 0.5;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.iconView.layer.borderWidth = 2;
    
    // 设置头像背景圆角
    self.bgImageView.layer.cornerRadius = self.bgImageView.frame.size.width * 0.5;
    self.bgImageView.layer.masksToBounds = YES;
    
    // 创建轻拍手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconViewClick)];
    // 开启头像用户交互
    self.iconView.userInteractionEnabled = YES;
    // 添加手势
    [self.iconView addGestureRecognizer:tap];
    
    // 设置单元格信息
    [self setCell];
}

/**
 *  设置单元格信息
 */
- (void)setCell {
    // 从服务器获取个人信息
    XMPPvCardTemp *myCard = [LFXMPPHelp shareXMPPHelp].xmppvCardTempModule.myvCardTemp;
    if (myCard.nickname) {
        // 设置名字
        self.nameLabel.text = myCard.nickname;
    }
    
    
    if (myCard.photo) {
        // 设置头像
        self.iconView.image = [UIImage imageWithData:myCard.photo];
    }
    
    // 设置地区
    if (myCard.familyName) {
        self.cityLabel.text = myCard.familyName;
    }
    
    // 设置钻石数量
    if (myCard.givenName) {
        self.moneyLabel.text = myCard.givenName;
    }
    
    // 如果性别为女
    if ([myCard.role isEqualToString:@"女"]) {
        self.bgImageView.image = [UIImage imageNamed:@"halo1"];
        self.nameLabel.textColor = kGirlColor;
    }
    
    self.usernameLabel.text = [LFUserInfo shareUserInfo].loginName;
}

/**
 *  头像轻拍事件
 */
- (void)iconViewClick {
    self.iconViewClckBlock(self);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
