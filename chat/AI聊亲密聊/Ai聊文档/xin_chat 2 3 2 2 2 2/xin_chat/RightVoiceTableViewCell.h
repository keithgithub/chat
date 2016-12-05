//
//  RightVoiceTableViewCell.h
//  WeiXinChar
//
//  Created by guan song on 15/11/22.
//  Copyright (c) 2015年 guan song. All rights reserved.
//


#import <AVFoundation/AVFoundation.h>
#import "CommonTableViewCell.h"
@interface RightVoiceTableViewCell : CommonTableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingLayout;//泡泡左边约束
@property (weak, nonatomic) IBOutlet UIImageView *imgVHead;//头像

@property (weak, nonatomic) IBOutlet UIButton *btnTime;


@property (weak, nonatomic) IBOutlet UILabel *lblVoiceTime;//语音时长
@property(nonatomic,strong)AVAudioPlayer *player;

//-(void)setCell:(NSDictionary *)dic;
@end
