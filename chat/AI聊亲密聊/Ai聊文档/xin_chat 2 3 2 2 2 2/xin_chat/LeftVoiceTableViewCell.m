//
//  LeftVoiceTableViewCell.m
//  WeiXinChar
//
//  Created by guan song on 15/11/26.
//  Copyright (c) 2015年 guan song. All rights reserved.
//

#import "LeftVoiceTableViewCell.h"

@implementation LeftVoiceTableViewCell

-(void)setCell:(XMPPMessageArchiving_Message_CoreDataObject *)messageObj
{
    NSData *voiceData=[[NSData  alloc]initWithBase64EncodedString:messageObj.body options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    NSError *err=nil;
    self.player =[[AVAudioPlayer  alloc]initWithData:voiceData error:&err];
    
    NSLog(@"err:%@--------",err);
    self.lblVoiceTime.text=[NSString  stringWithFormat:@"%.0lf 's",self.player.duration];
    if (153-self.player.duration*10<=60)
    {
        self.lblTranlingLayout.constant=60;
    }
    else
    {
        self.lblTranlingLayout.constant=153- self.player.duration *10;
    }
    [self.btnTime setTitle: [TimeModel  getMsgDate:messageObj.timestamp]forState:UIControlStateNormal];

}

- (void)awakeFromNib {
    
    self.imgHead.layer.cornerRadius=self.imgHead.frame.size.height/2;
    self.imgHead.layer.masksToBounds=YES;
    
    self.btnTime.layer.cornerRadius = 5;
    self.btnTime.layer.masksToBounds = YES;
    self.btnTime.alpha = 0.6;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
