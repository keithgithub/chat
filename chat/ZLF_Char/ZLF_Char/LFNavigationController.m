//
//  LFNavigationController.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/25.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFNavigationController.h"

@interface LFNavigationController ()

@end

@implementation LFNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建字体属性字典
    NSMutableDictionary *fontDict = [NSMutableDictionary new];
    fontDict[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.267 green:0.765 blue:0.929 alpha:1.000];
    // 设置字体颜色
    [self.tabBarItem setTitleTextAttributes:fontDict forState:UIControlStateSelected];
    // 设置背景图片
//    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"bottleMaskBkg"] forBarMetrics:UIBarMetricsDefault];
    // 设置字体颜色
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    // 设置标题颜色
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    // 设置透明背景
//    [self.navigationBar setBackgroundColor:[UIColor clearColor]];
//    self.navigationBar.alpha = 0.0;
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏1"] forBarMetrics:UIBarMetricsDefault];
//    self.navigationBar.shadowImage =[UIImage imageNamed:@"导航栏背景"];
//    self.navigationBar.shadowImage =[UIImage imageNamed:@"launch_bj"];
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
