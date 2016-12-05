//
//  LeftVoiceTableViewCell.h
//  WeiXinChar
//
//  Created by guan song on 15/11/26.
//  Copyright (c) 2015年 guan song. All rights reserved.
//


#import "CommonTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
@interface LeftVoiceTableViewCell : CommonTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblTranlingLayout;//右侧约束
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;

@property (weak, nonatomic) IBOutlet UILabel *lblVoiceTime;
@property(nonatomic,strong)AVAudioPlayer *player;
@property (weak, nonatomic) IBOutlet UIButton *btnTime;



@end
