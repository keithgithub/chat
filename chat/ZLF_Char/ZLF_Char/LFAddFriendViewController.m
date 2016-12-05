//
//  LFAddFriendViewController.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/28.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFAddFriendViewController.h"
#import "XMPPFramework.h"
#import "MBProgressHUD+MJ.h"
#import "LFXMPPHelp.h"

@interface LFAddFriendViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumberFind;

@end

@implementation LFAddFriendViewController
#pragma mark - 系统初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置标题
    self.title = @"添加好友";
    
    // 创建后退按钮
    [self createBackItem];
    
    // KVC修改提示文本颜色
    [self.txtPhoneNumberFind setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtPhoneNumberFind setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    
    // 修改键盘风格
    self.txtPhoneNumberFind.keyboardAppearance=UIKeyboardAppearanceDark;
    
    // 设置clearButton
    self.txtPhoneNumberFind.clearButtonMode = UITextFieldViewModeWhileEditing;
    // 开始编辑时清空文本
    self.txtPhoneNumberFind.clearsOnBeginEditing = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 隐藏tabbar
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - 导航栏后退按钮
/**
 *  创建后退按钮
 */
- (void)createBackItem {
    // 创建item
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"透明返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backItemClick)];
    // 设置item
    self.navigationItem.leftBarButtonItem = item;
}

- (void)backItemClick {
    // 跳回
    [self.navigationController popViewControllerAnimated:YES];
    //    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 本类方法
- (IBAction)addFriendButtonClick:(UIButton *)sender {
    if ([self.txtPhoneNumberFind.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"号码不能为空"];
        return;
    }
    [[LFXMPPHelp shareXMPPHelp] xmppAddNewFriendWithName:self.txtPhoneNumberFind.text];
//    XMPPJID *jib = [LFXMPPHelp xmppAppendString:self.txtPhoneNumberFind.text];
//    // 返回好友是否存在
//    BOOL isContains = [[LFXMPPHelp shareXMPPHelp].xmppRosterCoredataStorage userExistsWithJID:jib xmppStream:[LFXMPPHelp shareXMPPHelp].xmppStream];
//    if (isContains) { // 如果好友已经存在
//        [MBProgressHUD showError:@"好友已经存在"];
//        return;
//    }
//    
//    // 添加好友
//    [[LFXMPPHelp shareXMPPHelp].xmppRoster subscribePresenceToUser:jib];
//    [MBProgressHUD showSuccess:@"好友申请已发送"];
}
//L contains = [[SXXMPPTools sharedXMPPTools].xmppRosterCoreDataStorage userExistsWithJID:jid xmppStream:[SXXMPPTools sharedXMPPTools].xmppStream];


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
