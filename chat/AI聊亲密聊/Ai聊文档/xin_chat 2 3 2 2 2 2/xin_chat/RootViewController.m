//
//  RootViewController.m
//  xin_chat
//
//  Created by ibokan on 15/12/7.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import "RootViewController.h"
#import "LeftMenuViewController.h"
#import "HomeViewController.h"
#import "XMPPHelp.h"
#import "XMPPvCardTemp.h"

@interface RootViewController ()

@property (nonatomic,strong) LeftMenuViewController *leftVC;

@end

@implementation RootViewController

- (void)awakeFromNib
{
    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    self.contentViewShadowColor = [UIColor blackColor];
    self.contentViewShadowOffset = CGSizeMake(0, 0);
    self.contentViewShadowOpacity = 0.6;
    self.contentViewShadowRadius = 12;
    self.contentViewShadowEnabled = YES;
    
    // 导航栏控制器
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    // 隐藏导航栏返回按钮的标题
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-100, -60) forBarMetrics:UIBarMetricsDefault];
    navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    // 设置字体颜色
    navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.leftVC = [LeftMenuViewController new];
    
    self.contentViewController = navigationController;
    self.leftMenuViewController = self.leftVC;
    self.backgroundImage = [UIImage imageNamed:@"bg_h"];
    self.delegate = self;
}
- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"将要出现: %@", NSStringFromClass([menuViewController class]));
    
    if (menuViewController == self.leftVC)
    {
        [self loadData];
    }
    
}

/**
 *  本地数据库获取用户信息
 */
-(void)loadData
{
    self.leftVC.imgHead = [UIImage new];
    self.leftVC.lblName = [UILabel new];
    self.leftVC.lblSay = [UILabel new];
    
    //xmpp提供了一个方法，直接获取个人信息
    XMPPvCardTemp *myVCard =[XMPPHelp shareXmpp].vCard.myvCardTemp;
    // 设置头像
    if(myVCard.photo)
    {
        UIImage  *img=[UIImage imageWithData:myVCard.photo];
        self.leftVC.imgHead = img;
        self.leftVC.img_isyes = YES;
    }
    
    if (myVCard.nickname)
    {
        self.leftVC.lblName.text = myVCard.nickname;
        self.leftVC.name_isyes = YES;
    }
    if (myVCard.givenName)
    {
        self.leftVC.lblSay.text = myVCard.givenName;
        self.leftVC.say_isyes = YES;
    }
    
    NSLog(@"-------------%@",self.leftVC.imgHead);
    
    // 主线程刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.leftVC.tableView reloadData];
        
    });
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
