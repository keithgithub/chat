//
//  RightMessageTableViewCell.m
//  PengLaiYoujv
//
//  Created by guan song on 15/8/13.
//  Copyright (c) 2015年 guan song. All rights reserved.
//

#import "RightMessageTableViewCell.h"

@implementation RightMessageTableViewCell
-(void)setCell:(XMPPMessageArchiving_Message_CoreDataObject *)messageObj
{
    self.lblContent.text=messageObj.body;//消息
    [self.btnTime setTitle: [TimeModel  getMsgDate:messageObj.timestamp]forState:UIControlStateNormal];
}
- (void)awakeFromNib {
    // Initialization code
    self.imgHead.layer.cornerRadius=self.imgHead.frame.size.height/2;
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
        [self.delegate sendRightText:self.lblContent.text];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
