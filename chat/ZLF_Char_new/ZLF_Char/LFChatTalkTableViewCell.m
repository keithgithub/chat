//
//  LFChatTalkTableViewCell.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/26.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFChatTalkTableViewCell.h"
#import "XMPPMessageArchiving_Message_CoreDataObject.h"
#import "NSDate+LFExtension.h"
#import "XMPPvCardTemp.h"
#import "LFUserInfo.h"
#import "EnlargeImage.h"

@interface LFChatTalkTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageV;
@property (weak, nonatomic) IBOutlet UILabel *talkLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *talkBgImage;
@property (weak, nonatomic) IBOutlet UIImageView *transparentImageView;

@end

@implementation LFChatTalkTableViewCell

- (void)setCell:(XMPPMessageArchiving_Message_CoreDataObject *)message {
    // 亲密度
    NSString *intimacy = nil;
    // 如果有姓名
    if (message.bareJid.user) {
        // 获取亲密度
        intimacy = [LFUserInfo getFriendIntimacy:message.bareJid.user];
    }
    
    // 设置透明层的透明度
    self.transparentImageView.alpha = 0.9 - [intimacy intValue] / 100.0;
    
    // 设置说话内容
    self.talkLabel.text = message.body;
    // 设置时间
    self.timeLabel.text = [NSDate getMsgDate:message.timestamp];
    // 如果用户有头像
    if (self.temp.photo) {
        self.iconView.image = [UIImage imageWithData:self.temp.photo];
    }
    // 如果性别为女
    if ([self.temp.role isEqualToString:@"女"]) {
        // 更换背景光晕
        self.bgImageV.image = [UIImage imageNamed:@"halo1"];
    } else {
        self.bgImageV.image = [UIImage imageNamed:@"halo2"];

    }
}

- (void)awakeFromNib {
    // 设置头像圆角
    self.iconView.layer.cornerRadius = self.iconView.frame.size.width * 0.5;
    self.iconView.layer.masksToBounds = YES;
    // 设置白色圆圈
    self.iconView.layer.borderWidth = 2;
    self.iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    // 设置头像背景圆角
    self.bgImageV.layer.cornerRadius = self.bgImageV.frame.size.width * 0.5;
    self.bgImageV.layer.masksToBounds = YES;
    
    // 设置透明层圆角
    self.transparentImageView.layer.cornerRadius = self.transparentImageView.frame.size.width * 0.5;
    self.transparentImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
