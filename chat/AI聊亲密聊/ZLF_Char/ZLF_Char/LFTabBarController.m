//
//  LFTabBarController.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/25.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFTabBarController.h"
#import "LFConstant.h"
@interface LFTabBarController ()

@end

@implementation LFTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建一个视图
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    //设置视图的背景颜色图片
    [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"标签栏3"]]];
    //将视图添加到标签栏控制器上
    [self.tabBar insertSubview:view atIndex:1];
    
    // 替换掉原本的背景图片
//    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"标签栏3"]];
////    // 替换掉原本的投影图片
//    self.tabBar.shadowImage =[UIImage imageNamed:@"透明"];
//    [self.tabBar setShadowImage:[UIImage imageNamed:@"透明"]];
//    self.tabBar.translucent = YES;
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
