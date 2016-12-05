//
//  LFChatTableViewCell.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/25.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFChatTableViewCell.h"
#import "XMPPUserCoreDataStorageObject.h"
#import "XMPPvCardTemp.h"
#import "LFXMPPHelp+Message.h"
#import "NSDate+LFExtension.h"
#import "LFConstant.h"

@interface LFChatTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *talkLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *transparentImageView;
@property (weak, nonatomic) IBOutlet UILabel *intimacyLabel;
@property (weak, nonatomic) IBOutlet UIButton *badgeButton;

@end

@implementation LFChatTableViewCell

- (void)setCell:(XMPPvCardTemp *)user andName:(NSString *)name {
    
    if (self.myUser.section == 2) {
        // 隐藏光晕
        self.bgImageView.hidden = YES;
    } else {
        // 隐藏光晕
        self.bgImageView.hidden = NO;
    }
    
    // 设置名字文本
//    self.nameLabel.text = user.nickname;
    name = [[LFXMPPHelp shareXMPPHelp] xmppGetJibWithName:name].user;
    // 如果有昵称显示昵称
    if (user.nickname) {
        self.nameLabel.text = user.nickname;
    } else { // 否则显示账号
        self.nameLabel.text = name;
    }
    
    // 如果用户有存储头像
    if (user.photo) {
        self.iconView.image = [UIImage imageWithData:user.photo];
    }
    
    // 获取与这个好友的消息列表
    NSFetchedResultsController *fetched = [[LFXMPPHelp shareXMPPHelp] xmppGetMessageLocalWithFriendName:name];
    // 开始工作
    NSError *err = nil;
    [fetched performFetch:&err];
    // 获取最后一条消息
    XMPPMessageArchiving_Message_CoreDataObject *msg = [fetched.fetchedObjects lastObject];
    // 获得消息类型
    NSString *msgType = [msg.message attributeStringValueForName:@"bodyType"];
    // 根据消息类型进行提示
    if ([msgType isEqualToString:@"text"]) {
        self.talkLabel.text = msg.body;
    } else if ([msgType isEqualToString:@"image"]) {
        self.talkLabel.text = @"[图片]";
    } else if ([msgType isEqualToString:@"audio"]) {
        self.talkLabel.text = @"[声音]";
    }
    
    // 时间部分
    double nowTime = [[NSDate getNowTime] doubleValue];
    double sendTime = [[NSDate getMsgDateNotSeparate:msg.timestamp] doubleValue];
    double time = nowTime * 1.0 - sendTime;
    if (time < 60) { // 小于一分钟
        self.timeLabel.text = @"刚刚";
    } else if (time < 3600) { // 小于一小时
        self.timeLabel.text = [NSString stringWithFormat:@"%.0f分钟前", time / 60];
    } else if (time < 3600 * 24) { // 小于一天
        self.timeLabel.text = [NSString stringWithFormat:@"%.0f小时前", time / 3600];
    } else {
        self.timeLabel.text = @"一天前";
    }
    
    NSString *intimacy = nil; // 亲密度
    NSString *badge = nil; // 角标
    if (name) {
        intimacy = [LFUserInfo getFriendIntimacy:name];
        badge = [LFUserInfo getFriendBadge:name];
    }
    // 设置亲密度文本
    self.intimacyLabel.text = [NSString stringWithFormat:@"%@%%", intimacy];
    // 设置透明层的透明度
    self.transparentImageView.alpha = 0.9 - [intimacy intValue] / 100.0;
    
    // 如果没有消息
    if ([badge isEqualToString:@"0"]) {
        // 隐藏整个按钮
        self.badgeButton.hidden = YES;
    } else if ([badge isEqualToString:@"99+"]) {
        // 设置数字比较小的时候字体较大
        self.badgeButton.titleLabel.font = [UIFont systemFontOfSize:10.0f];
        // 显示按钮
        self.badgeButton.hidden = NO;
        // 设置角标
        [self.badgeButton setTitle:badge forState:UIControlStateNormal];
    } else {
        // 设置数字比较小的时候字体较大
        self.badgeButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        // 显示按钮
        self.badgeButton.hidden = NO;
        // 设置角标
        [self.badgeButton setTitle:badge forState:UIControlStateNormal];
    }
    
    // 如果性别为女
    if ([user.role isEqualToString:@"女"]) {
        // 设置光晕背景
        self.bgImageView.image = [UIImage imageNamed:@"halo1"];
        // 设置名字颜色
        self.nameLabel.textColor = kGirlColor;
    } else {
        self.bgImageView.image = [UIImage imageNamed:@"halo2"];
        // 设置名字颜色
        self.nameLabel.textColor = kBoyColor;
    }
}

- (void)setNewFriendCell:(NSString *)name {
    
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
    
    // 设置透明层圆角
    self.transparentImageView.layer.cornerRadius = self.transparentImageView.frame.size.width * 0.5;
    self.transparentImageView.layer.masksToBounds = YES;
    
    // 设置角标圆角
    self.badgeButton.layer.cornerRadius = self.badgeButton.frame.size.width * 0.5;
    self.badgeButton.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
