//
//  LoginTableViewController.h
//  xin_chat
//
//  Created by ibokan on 15/11/25.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "XMPPHelp.h"

@protocol  LoginTableViewControllerDelegate<NSObject>

- (void)loginSucceed;

@end

@interface LoginTableViewController : UITableViewController

// 代理
@property (nonatomic, assign) id<LoginTableViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *imgVHead;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtPsd;
@property (weak, nonatomic) IBOutlet UIButton *btnLongin;
@property (weak, nonatomic) IBOutlet UIButton *btnEnroll;
- (IBAction)btnLoginAction:(UIButton *)sender;
- (IBAction)btnRegAction:(UIButton *)sender;


@end
