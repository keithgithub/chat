//
//  FriendMsgTableViewCell.m
//  WeiXinChar
//
//  Created by guan song on 15/11/28.
//  Copyright (c) 2015年 guan song. All rights reserved.
//

#import "FriendMsgTableViewCell.h"
#import "TimeModel.h"
#import "XMPPHelp+Friend.h"
#import "XMPPvCardTemp.h"
@implementation FriendMsgTableViewCell


-(void)setCellMsg:(XMPPMessage *)message andCount:(NSString*)count
{
    self.lblMsgCount.hidden=NO;//不隐藏
    // 判断是不是 加载的历史记录  是就隐藏角标
    if ([count intValue] == 0)
    {
        self.lblMsgCount.hidden = YES;
    }
    else
    {
       self.lblMsgCount.text = count;//消息条数
    }
    NSString *msgType = [message attributeStringValueForName:@"bodyType"];
    // 根据消息类型进行提示
    if ([msgType isEqualToString:@"text"]) {
        self.lblMsg.text = message.body;
    } else if ([msgType isEqualToString:@"image"]) {
        self.lblMsg.text = @"[图片]";
    } else if ([msgType isEqualToString:@"audio"]) {
        self.lblMsg.text = @"[语音]";
    }
    self.lblTime.text=[TimeModel  getMonthDate];//现在的时间
   
    //用户详细信息
    XMPPvCardTemp *vCad=[XMPPHelp  searchFriendDetailInfo:message.from];
    
    self.imgHead.image = [UIImage imageNamed:@"avtar_120_default"];
    if (vCad.photo)
    {
         self.imgHead.image=[UIImage  imageWithData:vCad.photo];//头像
    }
    // 设置名字
    if ([vCad.nickname isEqualToString:@"未命名"] || [vCad.nickname isEqualToString:@""])//电话号码
    {
        self.lblFriendName.text = message.from.user;//好友账户名
    }
    else
    {
        self.lblFriendName.text = vCad.nickname;
    }


    
    
}

-(void)setCellMsg:(NSDictionary *)dic
{
    self.lblMsgCount.hidden=NO;//不隐藏
   // 判断是不是 加载的历史记录  是就隐藏角标
    if ([dic[@"count"] intValue] == 0)
    {
        self.lblMsgCount.hidden = YES;
    }
    else
    {
        self.lblMsgCount.text = dic[@"count"];//消息条数
    }
  
    self.lblTime.text=[TimeModel  getMonthDate];//现在的时间
    //NSLog(@"%@",[dic objectForKey:@"jid"]);

    XMPPJID *jid =
    [XMPPJID jidWithString:dic[@"jid"]];
    
    XMPPvCardTemp *vCad = [XMPPHelp searchFriendDetailInfo:jid];
    
    self.lblMsg.text = dic[@"msg"];
    //用户详细信息
   
    if (vCad.photo)
    {
        self.imgHead.image=[UIImage  imageWithData:vCad.photo];//头像
    }
    
    // 获取本地沙盒保存的备注名称  如果没有设置为nickNaem  如果没有就设置为账号
    NSString *str = [UserInfo getFriendInforFromSanBoxAndKey:jid.user][@"name"];
    if (str == nil)//姓名
    {
        
        if (vCad.nickname == nil)
        {
            self.lblFriendName.text = jid.user;
        }
        else
        {
            NSLog(@"---------------9%@",vCad.nickname);
            self.lblFriendName.text = vCad.nickname;//好友账户名
        }
    }
    else
    {
        self.lblFriendName.text = str;
    }

    // 通过jid获取头像   设置头像
    UIImage *img = [UIImage  imageWithData:[XMPPHelp  searchFriendDetailInfo:jid].photo];
    
    if (img == nil)// 如果好友没有上传头像 就给默认的
    {
        img = [UIImage imageNamed:@"ioco_head1.jpg"];
    }
    self.imgHead.image = img;
    
}



- (void)awakeFromNib {
    
    self.lblMsgCount.layer.cornerRadius=self.lblMsgCount.frame.size.width/2;
    self.lblMsgCount.layer.masksToBounds=YES;
    self.imgHead.layer.cornerRadius= self.imgHead.frame.size.height/2;
    self.imgHead.layer.masksToBounds=YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
