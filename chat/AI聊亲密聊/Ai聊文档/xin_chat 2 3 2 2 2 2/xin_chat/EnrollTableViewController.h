//
//  EnrollTableViewController.h
//  xin_chat
//
//  Created by ibokan on 15/11/27.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPHelp.h"
#import "UserInfo.h"

@protocol EnrollTableViewControllerDelegate <NSObject>

- (void)loginName:(NSString *)name andPwd:(NSString *)pwd;

@end

@interface EnrollTableViewController : UITableViewController

// 传递注册成功的账号密码
@property (nonatomic,assign) id<EnrollTableViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtPwd;
@property (weak, nonatomic) IBOutlet UITextField *txtPwd_q;
- (IBAction)btnAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn;


@end
