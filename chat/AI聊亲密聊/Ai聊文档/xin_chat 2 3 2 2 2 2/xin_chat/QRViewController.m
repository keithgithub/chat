//
//  QRViewController.m
//  xin_chat
//
//  Created by xiao on 15/12/16.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import "QRViewController.h"
#import "QRCScanner.h"
#import "AddFriendsTableViewController.h"

@interface QRViewController ()<QRCodeScanneDelegate>

@end

@implementation QRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    QRCScanner *scanner = [[QRCScanner alloc]initQRCScannerWithView:self.view]; scanner.delegate = self;
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = @"扫一扫";
    
    [self.view addSubview:scanner];
    
}

#pragma mark - 扫描二维码完成后的代理方法
- (void)didFinshedScanningQRCode:(NSString *)result
{
    AddFriendsTableViewController *addVC = [AddFriendsTableViewController new];
    addVC.friendName = result;
    addVC.lbl = [UILabel new];
    addVC.lbl.text = result;
    [self.navigationController pushViewController:addVC animated:YES];
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

@end
