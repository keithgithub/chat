//
//  LFLoginNavigationControllerr.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/26.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFLoginNavigationControllerr.h"

@interface LFLoginNavigationControllerr ()

@end

@implementation LFLoginNavigationControllerr

- (void)viewDidLoad {
    [super viewDidLoad];// 设置字体颜色
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    // 设置标题颜色
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"透明"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationBar setShadowImage:[UIImage imageNamed:@"透明"]];
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
