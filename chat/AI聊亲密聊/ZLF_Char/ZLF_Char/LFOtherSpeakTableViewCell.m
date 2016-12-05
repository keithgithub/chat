//
//  LFOtherSpeakTableViewCell.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/26.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFOtherSpeakTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "LFConstant.h"
#import "XMPPvCardTemp.h"
#import "XMPPMessageArchiving_Message_CoreDataObject.h"
#import "LFUserInfo.h"

@interface LFOtherSpeakTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *speakBgImage;
@property (weak, nonatomic) IBOutlet UILabel *speakTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLalbel;
@property (weak, nonatomic) IBOutlet UIImageView *transparentImageView;
@property (nonatomic, strong) AVAudioPlayer *player;
@end

@implementation LFOtherSpeakTableViewCell

- (void)setCell:(AVAudioPlayer *)player andTime:(NSString *)time {
    // 存储音频
    self.player = player;
    // 修改时间文本
    self.speakTimeLabel.text = [NSString stringWithFormat:@"%0.1f'", player.duration];
    // 修改发布时间
    self.timeLalbel.text = time;
    
    if (self.temp.photo) { // 如果用户有头像
        self.iconView.image = [UIImage imageWithData:self.temp.photo];
    }
    
    // 亲密度
    NSString *intimacy = nil;
    // 如果有姓名
    if (self.obj.bareJidStr) {
        // 获取亲密度
        intimacy = [LFUserInfo getFriendIntimacy:self.obj.bareJidStr];
    }
    
    // 设置透明层的透明度
    self.transparentImageView.alpha = 0.9 - [intimacy intValue] / 100.0;
    
    // 如果性别为女
    if ([self.temp.role isEqualToString:@"女"]) {
        // 更换背景光晕
        self.bgImageView.image = [UIImage imageNamed:@"halo1"];
    } else {
        self.bgImageView.image = [UIImage imageNamed:@"halo2"];
    }
}

- (void)playAudio {
    // 准备播放
    if ([self.player prepareToPlay]) {
        // 播放
        [self.player play];
    } else {
        LFLog(@"出错了");
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
    
    // 创建轻拍手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playAudio)];
    // 开启图片用户交互
    self.speakBgImage.userInteractionEnabled = YES;
    // 给图片添加手势
    [self.speakBgImage addGestureRecognizer:tap];
    
    // 设置透明层圆角
    self.transparentImageView.layer.cornerRadius = self.transparentImageView.frame.size.width * 0.5;
    self.transparentImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
