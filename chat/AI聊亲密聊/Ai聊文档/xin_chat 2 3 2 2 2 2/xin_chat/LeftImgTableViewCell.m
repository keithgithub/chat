//
//  LeftImgTableViewCell.m
//  PengLaiYoujv
//
//  Created by guan song on 15/8/13.
//  Copyright (c) 2015年 guan song. All rights reserved.
//

#import "LeftImgTableViewCell.h"

@implementation LeftImgTableViewCell
-(void)setCell:(XMPPMessageArchiving_Message_CoreDataObject *)messageObj
{
  
    NSData *imgData=[[NSData  alloc]initWithBase64EncodedString:messageObj.body options:NSDataBase64DecodingIgnoreUnknownCharacters];
    self.imgMsg.image=[UIImage  imageWithData:imgData];
    self.imgMsg.layer.cornerRadius = 5;
    self.imgMsg.layer.masksToBounds = YES;
    
    
    // 自适应 宽高
  //  self.imgMsg.contentMode = UIViewContentModeScaleToFill;
   // self.imgMsg.autoresizesSubviews = YES;
 
    
    
    
#pragma mark  时间背景
    [self.btnTime setTitle: [TimeModel  getMsgDate:messageObj.timestamp]forState:UIControlStateNormal];

}

- (void)awakeFromNib {
    self.imgHead.layer.cornerRadius= self.imgHead.frame.size.height/2;
    self.imgHead.layer.masksToBounds=YES;
    
    self.btnTime.layer.cornerRadius = 5;
    self.btnTime.layer.masksToBounds = YES;
    self.btnTime.alpha = 0.6;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    
    [self addGestureRecognizer:longPress];
    
}

- (void)longPressAction:(UILongPressGestureRecognizer*)sender
{
    
    
    if (sender.state==UIGestureRecognizerStateEnded)
    {
        [self.delegate sendLeftImg:self.imgMsg.image];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
