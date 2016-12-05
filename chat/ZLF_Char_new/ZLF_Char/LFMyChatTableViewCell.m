//
//  LFMyChatTableViewCell.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/26.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFMyChatTableViewCell.h"
#import "NSDate+LFExtension.h"
#import "XMPPMessageArchiving_Message_CoreDataObject.h"
#import "XMPPvCardTemp.h"

@interface LFMyChatTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *bgChatImage;
@property (weak, nonatomic) IBOutlet UILabel *talkLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation LFMyChatTableViewCell

- (void)setCell:(XMPPMessageArchiving_Message_CoreDataObject *)message {
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
        self.bgImageView.image = [UIImage imageNamed:@"halo1"];
    } else {
        self.bgImageView.image = [UIImage imageNamed:@"halo2"];
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
    self.bgImageView.layer.cornerRadius = self.bgImageView.frame.size.width * 0.5;
    self.bgImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
