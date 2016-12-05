//
//  FriendesListTableViewCell.m
//  xin_chat
//
//  Created by ibokan on 15/11/26.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import "FriendesListTableViewCell.h"
#import "XMPPvCardTemp.h"
#import "UserInfo.h"

@implementation FriendesListTableViewCell

-(void)setCell:(XMPPUserCoreDataStorageObject *)obj  andFriendvCad:(XMPPvCardTemp *)vCad andCountDic:(NSMutableDictionary*)dic;
{
    // 设置圆角
    self.imgVHead.layer.cornerRadius = self.imgVHead.frame.size.height/2;
    self.imgVHead.layer.masksToBounds = YES;
    self.lblCount.layer.cornerRadius = self.lblCount.frame.size.width/2;
    self.lblCount.layer.masksToBounds = YES;
    
    self.lblState.textColor = [UIColor grayColor];
    switch ([obj.sectionNum intValue]) {//好友状态
        case 0:
        {
            //  @"在线";
            self.lblState.text = @"[在线]";
            self.imgVHead.alpha = 1;
            break;
        }
        case 1:
            // @"离开";
        {
            self.lblState.text = @"[离开]";
            self.imgVHead.alpha = 0.5;

        }
            break;
        case 2:
            //@"离线";
        {
            self.lblState.text = @"[离线请留言]";
            self.imgVHead.alpha = 0.5;

        }
            break;

        default:
            break;
    }
    if (vCad.photo)//若好友有头像
    {
        self.imgVHead.image = [UIImage  imageWithData:vCad.photo];
    }
    else
    {
        self.imgVHead.image = [UIImage  imageNamed:@"ioco_head1.jpg"];
    }
   
    // 获取本地沙盒保存的备注名称  如果没有设置为nickNaem  如果没有就设置为账号
    NSString *str = [UserInfo getFriendInforFromSanBoxAndKey:obj.jid.user][@"name"];
    if (str == nil)//姓名
    {
        
        if (vCad.nickname == nil)
        {
            self.lblName.text = obj.jid.user;
        }
        else
        {
            if ([vCad.nickname isEqualToString:@""])
            {
                self.lblName.text = obj.jid.user; 
            }
            else
            {
                self.lblName.text = vCad.nickname;//好友账户名
            }
        
            
        }
    }
    else
    {
       self.lblName.text = str;
    }
    
    
    // 设置消息数
    if (dic == nil)
    {
        self.lblCount.hidden = YES;
    }
    else
    {
        int count = [dic[@"count"] intValue];
        if (count == 0)
        {
            self.lblCount.hidden = YES;
        }
        else
        {
            self.lblCount.hidden = NO;
            self.lblCount.text = dic[@"count"];
        }
        
    }
    
}


- (void)awakeFromNib
{
    NSLog(@"sassdfsdfdsfsdgdsgds");
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
