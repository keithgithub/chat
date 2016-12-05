//
//  Ma_2ViewController.m
//  xin_chat
//
//  Created by ibokan on 15/12/2.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import "Ma_2ViewController.h"
#import "QRCodeGenerator.h"
#import "UserInfo.h"
#import "XMPPHelp.h"
#import "XMPPvCardTemp.h"
#import "QRCScanner.h"
#import "AddFriendsTableViewController.h"
#import "QRViewController.h"

#define kScreen_size [UIScreen mainScreen].bounds.size

@interface Ma_2ViewController ()<QRCodeScanneDelegate>

@end

@implementation Ma_2ViewController

- (void)didFinshedScanningQRCode:(NSString *)result
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的二维码";

    self.imgVHead.layer.cornerRadius = self.imgVHead.frame.size.width/2;
    self.imgVHead.layer.masksToBounds = YES;
    
    self.btnQR.layer.cornerRadius = 5;
    self.btnQR.layer.masksToBounds = YES;
    
    self.QRView.layer.cornerRadius = 5;
    self.QRView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.QRView.layer.borderWidth = 0.5;
    

    
    NSString *name = [UserInfo shareUser].loginName;
    
    self.imgVQR.image = [QRCodeGenerator qrImageForString:name imageSize:self.imgVQR.bounds.size.width];
    
    
    
    // 左侧按钮
    UIBarButtonItem *LeftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"topbar_menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.leftBarButtonItem = LeftItem;
    
    [self loadData];
}

/**
 *  本地数据库获取用户信息
 */
-(void)loadData
{
    //xmpp提供了一个方法，直接获取个人信息
    XMPPvCardTemp *myVCard =[XMPPHelp shareXmpp].vCard.myvCardTemp;
    // 设置头像
    if(myVCard.photo)
    {
        UIImage  *img=[UIImage imageWithData:myVCard.photo];
        
        self.imgVHead.image = img;
    }
    else
    {
        
    }
    
    if (myVCard.nickname)
    {
        self.lblName.text = myVCard.nickname;
    }
    else
    {
        
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

- (IBAction)btnQRAction:(UIButton *)sender
{
    QRViewController *vc = [QRViewController new];
  
    [self.navigationController pushViewController:vc animated:YES];

}

@end
