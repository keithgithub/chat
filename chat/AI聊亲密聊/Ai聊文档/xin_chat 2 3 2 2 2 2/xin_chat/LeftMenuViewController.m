//
//  LeftMenuViewController.m
//  xin_chat
//
//  Created by ibokan on 15/11/25.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "MyCenterViewController.h"
#import "HomeViewController.h"
#import "FriendesListViewController.h"
#import "SettingViewController.h"
#import "UserInfo.h"
#import "AppDelegate.h"
#import "XMPPHelp.h"
#import "XMPPvCardTemp.h"
#import "Ma_2ViewController.h"
#import "LoginTableViewController.h"

#define kScreen_size [UIScreen mainScreen].bounds.size


@interface LeftMenuViewController ()<UITableViewDelegate,UITableViewDataSource,LoginTableViewControllerDelegate>






@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // 初始化tableView
    [self creactTableView];
    
}

// 初始化tableView
- (void)creactTableView
{
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 7-20) / 2.0f, self.view.frame.size.width, 54 * 9-10) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];

}

#pragma mark 表格代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 跳转页面
    switch (indexPath.row) {
        case 0:// 个人中心
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[MyCenterViewController alloc] init]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 1:// 个人中心
            
            
            
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[MyCenterViewController alloc] init]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;

            
        case 2:// 首页
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 3:// 好友
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[FriendesListViewController alloc] init]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
            
        case 4:// 设置
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[SettingViewController alloc] init]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 6:// 注销
            
            [self logout];
           
            break;
    }
}

// 注销
-(void)logout
{
    // 注销
    [[XMPPHelp shareXmpp] xmppUserlogout];
    // 弹出提示
    //[MBProgressHUD showSuccess:@"注销成功"];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    UINavigationController *loginVC = [sb instantiateViewControllerWithIdentifier:@"LoginView"];
   
    // 获取window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // 设置跟视图
    window.rootViewController = loginVC;

}

#pragma mark 登录页代理
- (void)loginSucceed
{
    
//    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]]
//                                                 animated:NO];
//    [self.sideMenuViewController hideMenuViewController];
    
}


#pragma mark 跳转二维码视图
- (void)tapAction
{
    UIStoryboard *stroyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    Ma_2ViewController *QRVC = [stroyboard instantiateViewControllerWithIdentifier:@"QRVC"];
    
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:QRVC]
                                                 animated:YES];
    [self.sideMenuViewController hideMenuViewController];

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    cell.backgroundColor = [UIColor clearColor];
    // 取消选中样式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0)
    {
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_size.width/2-100-30, 0, 70, 70)];
        
        if (self.img_isyes)
        {
            imgV.image = self.imgHead;
            
        }
        else
        {
            imgV.image = [UIImage imageNamed:@"avtar_120_default"];
        }
        imgV.layer.cornerRadius = 35;
        imgV.layer.masksToBounds = YES;
        imgV.layer.borderColor = [[UIColor whiteColor] CGColor];
        imgV.layer.borderWidth = 2;
        
        UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_size.width/2-50, 38, 125, 30)];
        lblName.text = self.lblName.text;
        lblName.textColor = [UIColor whiteColor];
        lblName.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
        if (self.name_isyes)
        {
            lblName.text = self.lblName.text;
        }
        else
        {
            lblName.text = @"未命名";
        }
        
   

        
        // 二维码视图 profile_icon_qrcode
        UIImageView *imgV_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_icon_qrcode"]];
        imgV_2 .frame = CGRectMake(lblName.frame.origin.x+50+10, 5, 32, 32);
        imgV_2.userInteractionEnabled = YES;
        
        // 添加单击手势到图片视图
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [imgV_2 addGestureRecognizer:tap];
        
        [cell addSubview:imgV_2];
        [cell addSubview:lblName];
        [cell addSubview:imgV];
    }
    if (indexPath.row == 1)
    {
        UILabel *lblSay = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_size.width/2-100-30, 0, 180, 30)];
        lblSay.text = self.lblSay.text;
        lblSay .textColor = [UIColor whiteColor];
        lblSay .font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        if (self.say_isyes)
        {
            lblSay.text = self.lblSay.text;
        }
        else
        {
            lblSay.text = @"Ai让你爱上聊!";
        }
        
        // 线
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(kScreen_size.width/2-100-30, 29, 190, 1)];
        lineV.backgroundColor = [UIColor whiteColor];
        
        [cell addSubview:lblSay ];
        [cell addSubview:lineV];
    
    }
    if (indexPath.row == 2)
    {
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_icon_feeds"]];
        imgV.frame = CGRectMake(kScreen_size.width/2-100-30, 10, 30, 30);
        
        UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(imgV.frame.origin.x + imgV.frame.size.width + 10, 10, 60, 30)];
        lblName.text = @"消息";
        lblName.textColor = [UIColor whiteColor];
        lblName.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        
     
        
        [cell addSubview:lblName];
        [cell addSubview:imgV];
    }
    if (indexPath.row == 3)
    {
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_icon_event"]];
        imgV.frame = CGRectMake(kScreen_size.width/2-100-30, 10, 30, 30);
        
        UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(imgV.frame.origin.x + imgV.frame.size.width+10, 10, 60, 30)];
        lblName.text = @"好友";
        lblName.textColor = [UIColor whiteColor];
        lblName.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        
      
        
        [cell addSubview:lblName];
        [cell addSubview:imgV];
    }
    if (indexPath.row == 4)
    {
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_icon_suggest"]];
        imgV.frame = CGRectMake(kScreen_size.width/2-100-30, 10, 30, 30);
        
        UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(imgV.frame.origin.x + imgV.frame.size.width+10, 10, 60, 30)];
        lblName.text = @"设置";
        lblName.textColor = [UIColor whiteColor];
        lblName.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        
    
        
        [cell addSubview:lblName];
        [cell addSubview:imgV];
    }
    if (indexPath.row == 6)
    {
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_tip_exit"]];
        imgV.frame = CGRectMake(kScreen_size.width/2-100-30, 10, 30, 30);
        
        UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(imgV.frame.origin.x + imgV.frame.size.width+10, 10, 60, 30)];
        lblName.text = @"注销";
        lblName.textColor = [UIColor whiteColor];
        lblName.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        
        [cell addSubview:lblName];
        [cell addSubview:imgV];
    }
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 80;
    }
    else if (indexPath.row == 1)
    {
        return 30;
    }
    else
    {
        return 60;
    }

}


#pragma mark -



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

@end
