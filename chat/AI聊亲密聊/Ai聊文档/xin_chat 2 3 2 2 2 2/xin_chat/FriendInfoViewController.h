//
//  FriendInfoViewController.h
//  xin_chat
//
//  Created by xiao on 15/12/16.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPvCardTemp.h"
#import "RESideMenu.h"

@interface FriendInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *lblSex;
@property (weak, nonatomic) IBOutlet UILabel *lblLoginName;
@property (weak, nonatomic) IBOutlet UILabel *lblSay;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
- (IBAction)btnAddAction:(UIButton *)sender;

@property (nonatomic, copy) NSString *name;
// 好友名片
@property (nonatomic, strong) XMPPvCardTemp *vCard;


@end
