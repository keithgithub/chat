//
//  LoginTableViewController.m
//  xin_chat
//
//  Created by ibokan on 15/11/25.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import "LoginTableViewController.h"
#import "AppDelegate.h"
#import "MyAlertClass.h"
#import "UserInfo.h"
#import "EnrollTableViewController.h"
#import "MBProgressHUD+MJ.h"
#import "RootViewController.h"

@interface LoginTableViewController ()<UIApplicationDelegate,UITextFieldDelegate,EnrollTableViewControllerDelegate>

@end

@implementation LoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelf];
  
    // 沙盒获取用户
    [[UserInfo shareUser] loadUserInfoFromSenbox];
    self.txtName.text = [UserInfo shareUser].loginName;
    self.txtPsd.text = [UserInfo shareUser].loginPwd;
}

// 初始化
- (void)initSelf
{
    // 初始化
    self.imgVHead.layer.cornerRadius = self.imgVHead.bounds.size.height/2;
    self.imgVHead.layer.masksToBounds = YES;
    self.imgVHead.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.imgVHead.layer.borderWidth = 2;
    
    self.btnLongin.layer.cornerRadius = 5;
    self.btnLongin.layer.masksToBounds = YES;
    self.btnEnroll.layer.cornerRadius = 5;
    self.btnEnroll.layer.masksToBounds = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}

#pragma mark 文本框代理方法

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.txtName)
    {
        [self.txtName resignFirstResponder];
        [self.txtPsd becomeFirstResponder];
    }
    else
    {
        [self btnLoginAction:nil];
    }
    
    return YES;
}


#pragma mark 登录
- (IBAction)btnLoginAction:(UIButton *)sender
{
    if ([self.txtName .text  isEqualToString:@""])
    {
        [self presentViewController:[MyAlertClass alertControllerWithTitle:nil message:@"用户名不能为空" preferredStyle:UIAlertControllerStyleAlert] animated:YES completion:nil];
        return;
    }
    else if ([self.txtPsd.text  isEqualToString:@""])
    {
        [self presentViewController:[MyAlertClass alertControllerWithTitle:nil message:@"密码不能为空" preferredStyle:UIAlertControllerStyleAlert] animated:YES completion:nil];
        return;
    }
    else
    {
        [MBProgressHUD showMessage:@"正在登陆"];
        [self loginToHome];
    }
    
}

-(void)loginName:(NSString *)name andPwd:(NSString *)pwd
{
    self.txtName.text = name;
    self.txtPsd.text = pwd;
    [self btnLoginAction:nil];
}

- (IBAction)btnRegAction:(UIButton *)sender
{
    // 跳转注册页
    EnrollTableViewController *enr = [self.storyboard instantiateViewControllerWithIdentifier:@"regVC"];
    enr.delegate = self;
    
    [self.navigationController pushViewController:enr animated:YES];
    
}

/**
 *  登录
 */
-(void)loginToHome
{
    //获取用户名
    UserInfo *user = [UserInfo shareUser];
    user.loginName=self.txtName.text;
    user.loginPwd=self.txtPsd.text;
    //单例对象
    XMPPHelp *xmppHelp=[XMPPHelp  shareXmpp];
    //不是注册
    xmppHelp.isRegisterOperation=NO;
    //调用登录方法
    [xmppHelp  xmppUserRegisterOrLoginResultBlock:^(XMPPResultType type) {
        
        switch (type)//连接状态
        {
            case XMPPResultTypeLoginSuccess:
            {
                user.SaveStatus = YES;
                user.loginStatus = NO;
                [user  saveUserInfoToSanbox];//保存数据
                [self goHomeView];
            }
                break;
            case XMPPResultTypeLoginFailure:
            {
                
                // 主线程刷新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    // 隐藏蒙版
                    [MBProgressHUD hideHUD];
                    [self presentViewController:[MyAlertClass alertControllerWithTitle:nil message:@"用户名或密码错误" preferredStyle:UIAlertControllerStyleAlert] animated:YES completion:nil];
                });
            }
                break;
            case XMPPResultTypeNetWorkError:
            {
                // 主线程刷新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    // 隐藏蒙版
                    [MBProgressHUD hideHUD];
                    [self presentViewController:[MyAlertClass alertControllerWithTitle:nil message:@"请检查网络状态" preferredStyle:UIAlertControllerStyleAlert] animated:YES completion:nil];
                });
            }
                break;
            default:
                break;
        }
        
    }];
    
}

- (void)goHomeView
{
    // 主线程刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // 隐藏蒙版
        [MBProgressHUD hideHUD];
      
        // 从沙盒里加载用户的数据到单例
        UserInfo *user = [UserInfo shareUser];
        user.SaveStatus = YES;
        user.loginStatus = NO;
        [[UserInfo shareUser]  saveUserInfoToSanbox];//保存数据
               
        // 登录页控制器
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        RootViewController *rootVC = [storyboard instantiateViewControllerWithIdentifier:@"rootController"];

        // 获取window
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        window.rootViewController = rootVC;
        
    });
    
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
