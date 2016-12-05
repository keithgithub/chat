//
//  LFLoginViewController.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/25.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFLoginViewController.h"
#import "LFLoginTableViewCell.h"
#import "LFConstant.h"
#import "LFRegisterViewController.h"
#import "LFUserInfo.h"
#import "LFXMPPHelp.h"
#import "MBProgressHUD+MJ.h"
#import "LFTabBarController.h"


@interface LFLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@end

@implementation LFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 修改提示文本
    [self changePlaceholderFont];
#warning 临时，到时需删除
    self.txtUsername.text = @"13159260385";
    self.txtPassword.text = @"a00000";
}

/**
 *  修改提示文本
 */
- (void)changePlaceholderFont {
    // 设置提示文本
    self.txtUsername.placeholder = @"请输入账号";
    self.txtPassword.placeholder = @"输入密码";
    
    // KVC修改提示文本颜色
    [self.txtUsername setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtUsername setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    
    [self.txtPassword setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtPassword setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    
    // 修改键盘风格
    self.txtUsername.keyboardAppearance=UIKeyboardAppearanceDark;
    self.txtPassword.keyboardAppearance=UIKeyboardAppearanceDark;
    
    // 设置clearButton
    self.txtUsername.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.txtPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    // 开始编辑时清空文本
    self.txtUsername.clearsOnBeginEditing = YES;
    self.txtPassword.clearsOnBeginEditing = YES;
}

#pragma mark - 按钮点击事件
/**
 *  登陆按钮点击
 */
- (IBAction)loginButtonClick:(id)sender {
    if ([self.txtUsername.text isEqualToString:@""]) { // 如果用户名为空
        [MBProgressHUD showError:@"用户名不能为空"];
        return;
    }
    
    if ([self.txtPassword.text isEqualToString:@""]) { // 如果密码为空
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    
    // 获取用户信息单例
    LFUserInfo *userInfo = [LFUserInfo shareUserInfo];
    // 存储账号密码
    userInfo.loginName = self.txtUsername.text;
    userInfo.loginPwd = self.txtPassword.text;
    
    // 获取XMPP单例对象
    LFXMPPHelp *xmppHelp = [LFXMPPHelp shareXMPPHelp];
    // 是登陆
    xmppHelp.isRegisterOpeation = NO;
    // 弹出蒙版
    [MBProgressHUD showMessage:@"陛下稍后"];
    
    // 调用方法
    [xmppHelp xmppUserRegisterOrLoginResultBlock:^(XMPPResultType type) {
        switch (type) {
            case XMPPResultTypeLoginSuccess: {
                // 回到主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 获取故事板
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    // 获取标签栏视图
                    LFTabBarController *tabBarVc = [sb instantiateViewControllerWithIdentifier:@"LFTabBarController"];
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    // 更换根控制器
                    window.rootViewController = tabBarVc;
                    // 移除视图
                    [self.view removeFromSuperview];
                    // 隐藏蒙版
                    [MBProgressHUD hideHUD];
                    // 弹出提示
                    [MBProgressHUD showSuccess:@"登陆成功"];
                });
                
                
                break;
            }
            case XMPPResultTypeLoginFailure: // 登录失败
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 隐藏蒙版
                    [MBProgressHUD hideHUD];
                    // 弹出提示
                    [MBProgressHUD showError:@"账号名或密码错误"];
                });
                
                break;
                
            default:
                break;
        }
    }];
}

/**
 *  注册按钮点击
 */
- (IBAction)registerButtonClick:(UIButton *)sender {
    // 获取故事板
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // 从故事板获取控制器
    LFRegisterViewController *registerVc = [sb instantiateViewControllerWithIdentifier:@"LFRegisterViewController"];
    // 跳转
    [self.navigationController pushViewController:registerVc animated:YES];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
