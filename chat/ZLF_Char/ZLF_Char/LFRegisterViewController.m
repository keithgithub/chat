//
//  LFRegisterViewController.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/25.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFRegisterViewController.h"
#import "LFRegisterTableViewCell.h"
#import "LFXMPPHelp.h"
#import "LFUserInfo.h"
#import "LFConstant.h"
#import "MBProgressHUD+MJ.h"

@interface LFRegisterViewController ()
- (IBAction)registerButtonClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@end

@implementation LFRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self changePlaceholderFont];
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

/**
 *  注册按钮点击
 */
- (IBAction)registerButtonClick:(UIButton *)sender {
    
    if ([self.txtUsername.text isEqualToString:@""] || [self.txtUsername.text isEqualToString:@"请输入账号"]) {
        LFLog(@"账号不能为空");
        return;
    }
    
    if ([self.txtPassword.text isEqualToString:@""] || [self.txtPassword.text isEqualToString:@"输入密码"]) {
        LFLog(@"密码不能为空");
        return;
    }
    
    if (![LFUserInfo isTelphoneNum:self.txtUsername.text]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        
        return;
    }
    
    // 从单例类获取注册账号和密码
    LFUserInfo *userInfo = [LFUserInfo shareUserInfo];
    userInfo.registerName = self.txtUsername.text;
    userInfo.registerPwd = self.txtPassword.text;
    
    // 创建xmpp单例类对象
    LFXMPPHelp *xmppHelp = [LFXMPPHelp shareXMPPHelp];
    // 是注册
    xmppHelp.isRegisterOpeation = YES;
    // 开始注册
    [xmppHelp xmppUserRegisterOrLoginResultBlock:^(XMPPResultType type) {
        switch (type) {
            case XMPPResultTypeRegisterSuccess: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 提示
                    [MBProgressHUD showSuccess:@"注册成功"];
                    // 返回上个界面
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
                break;
            }
            case XMPPResultTypeRegisterFailure: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showError:@"注册失败"];
                });
                
                break;
            }
            default:
                break;
        }
        
        
    }];
}

@end








