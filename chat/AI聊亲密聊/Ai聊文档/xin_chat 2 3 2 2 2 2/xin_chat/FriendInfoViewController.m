//
//  FriendInfoViewController.m
//  xin_chat
//
//  Created by xiao on 15/12/16.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import "FriendInfoViewController.h"
#import "XMPPHelp+Friend.h"
#import "MBProgressHUD+MJ.h"

@interface FriendInfoViewController ()

@end

@implementation FriendInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"好友信息";
   
    self.btnAdd.layer.cornerRadius = 5;
    self.btnAdd.layer.masksToBounds = YES;
    
    self.imgV.layer.cornerRadius = self.imgV.layer.frame.size.height/2;
    self.imgV.layer.masksToBounds = YES;

    if (self.vCard.photo)//头像
    {
        self.imgV.image = [UIImage  imageWithData:self.vCard.photo];
    }
    else
    {
            self.imgV.image = [UIImage imageNamed:@"hi"];
    }
    
   
    if (self.vCard.nickname == nil)
    {
         self.lblName.text = [NSString stringWithFormat:@"未命名"];
    }
    else
    {
        // 昵称
        if ([self.vCard.nickname isEqualToString:@""])
        {
            self.lblName.text = [NSString stringWithFormat:@"未命名"];
        }
        else
        {
            self.lblName.text = [NSString stringWithFormat:@"%@",self.vCard.nickname];
        }
 
    }
        // 账号
    self.lblLoginName.text = [NSString stringWithFormat:@"账号信息：%@",self.name];
    if (self.vCard.prefix == nil)
    {
       self.lblSex.text = [NSString stringWithFormat:@"性别"];
    }
    else
    {
        // 性别
        if ([self.vCard.prefix isEqualToString:@""])
        {
            self.lblSex.text = [NSString stringWithFormat:@"性别"];
        }
        else
        {
            self.lblSex.text = [NSString stringWithFormat:@"%@", self.vCard.prefix];
        }

    }
    
    if (self.vCard.givenName == nil)
    {
        self.lblSay.text = [NSString stringWithFormat:@"个性签名：Ai让你爱上聊"];
    }
    else
    {
        // 签名
        if ([self.vCard.givenName isEqualToString:@""])
        {
            self.lblSay.text = [NSString stringWithFormat:@"个性签名：Ai让你爱上聊"];
        }
        else
        {
            self.lblSay.text =[NSString stringWithFormat:@"个性签名：%@",self.vCard.givenName];
        }

    }
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnAddAction:(UIButton *)sender
{
    XMPPHelp *xmppH=[XMPPHelp  shareXmpp];
    
    BOOL  result= [xmppH  addFriend:self.name];

    if (result)
        
    {
        [MBProgressHUD showSuccess:@"请求已发送"];
    
    [self.navigationController  popViewControllerAnimated:YES];
    }
    
    }
@end
