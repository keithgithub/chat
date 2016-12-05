//
//  RightImgTableViewCell.m
//  PengLaiYoujv
//
//  Created by guan song on 15/8/13.
//  Copyright (c) 2015年 guan song. All rights reserved.
//

#import "RightImgTableViewCell.h"

@implementation RightImgTableViewCell

-(void)setCell:(XMPPMessageArchiving_Message_CoreDataObject *)messageObj
{
    
    NSData *imgData=[[NSData  alloc]initWithBase64EncodedString:messageObj.body options:NSDataBase64DecodingIgnoreUnknownCharacters];
    self.imgMsg.image=[UIImage  imageWithData:imgData];

//    // 自适应 宽高
//    self.imgMsg.contentMode = UIViewContentModeScaleAspectFit;
//    self.imgMsg.autoresizesSubviews = YES;
//    self.imgMsg.autoresizingMask =
//    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    
    
   [self.btnTime setTitle: [TimeModel  getMsgDate:messageObj.timestamp]forState:UIControlStateNormal];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    
    [self addGestureRecognizer:longPress];

}

- (void)longPressAction:(UILongPressGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self.delegate sendRightImg:self.imgMsg.image];
    }
}

- (void)awakeFromNib {
    // Initialization code
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
