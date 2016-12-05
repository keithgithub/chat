//
//  EnrollTableViewController.m
//  xin_chat
//
//  Created by ibokan on 15/11/27.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import "EnrollTableViewController.h"
#import "MyAlertClass.h"
#import "MBProgressHUD+MJ.h"

@interface EnrollTableViewController ()<UITextFieldDelegate>

@end

@implementation EnrollTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.btn.layer.cornerRadius = 5;
    self.btn.layer.masksToBounds = YES;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 文本框代理方法

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.txtName)
    {
        [self.txtName resignFirstResponder];
        [self.txtPwd becomeFirstResponder];
    }
    else if (textField == self.txtPwd)
    {
        [self.txtPwd resignFirstResponder];
        [self.txtPwd_q becomeFirstResponder];
    }
    else
    {
        [self btnAction:nil];
    }
    
    return YES;
}


- (IBAction)btnAction:(UIButton *)sender
{
    if ([self registerStus])
    {
        UserInfo *user = [UserInfo shareUser];
        user.registerName = self.txtName.text;
        user.registerPwd = self.txtPwd.text;
        
        XMPPHelp *xmppHelp = [XMPPHelp shareXmpp];
        xmppHelp.isRegisterOperation = YES ; // 是注册
        
        [xmppHelp xmppUserRegisterOrLoginResultBlock:^(XMPPResultType type) {
            
            if (type == XMPPResultTypeRegisterSuccess)
            {
                
                // 主线程刷新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    // 保存用户信息到沙盒
                    [user saveUserInfoToSanbox];
                    
                    [self presentViewController:[MyAlertClass alertControllerWithTitle:nil message:@"注册成功" preferredStyle:UIAlertControllerStyleAlert] animated:YES completion:^{
                        
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        
                        // 传递用户名密码
                        [self.delegate loginName:self.txtName.text andPwd:self.txtPwd.text];
                    }];
        
                    
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showError:@"注册失败"];
                });
            }
            
        }];
        
    }
    
}

- (BOOL)registerStus
{
    if ([self.txtName.text isEqualToString:@""])
    {
        
        [MBProgressHUD showError:@"手机号不能为空"];
        
        return NO;
    }
    if (![XMPPHelp isTelphoneNum:self.txtName.text])
    {
        [MBProgressHUD showError:@"请填写正确的手机号码"];
        return NO;
    }
    if ([self.txtPwd.text isEqualToString:@""])
    {
        
        [MBProgressHUD showError:@"密码不能为空"];
        return NO;
    }
    if ([self.txtPwd_q.text isEqualToString:@""])
    {
        [MBProgressHUD showError:@"确认密码不能为空"];
        return NO;
    }
    if (![self.txtPwd.text  isEqualToString:self.txtPwd_q.text])
    {
         [MBProgressHUD showError:@"密码和确认密码不一致"];
        return NO;
    }
    
    if (self.txtPwd.text.length<6)
    {
        [MBProgressHUD showError:@"密码不得少于6位"];
        return NO;
    }
    return YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 7;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
