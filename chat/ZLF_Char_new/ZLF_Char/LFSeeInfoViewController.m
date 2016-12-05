//
//  LFSeeInfoViewController.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/27.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFSeeInfoViewController.h"
#import "LFSeeInfoTableViewCell.h"
#import "MyAlertClass.h"
#import "UIImage+Extension.h"
#import "LFConstant.h"
#import "LFXMPPHelp.h"
#import "XMPPvCardTemp.h"
#import "MBProgressHUD+MJ.h"

@interface LFSeeInfoViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *lightingBgImage;

@end

@implementation LFSeeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 隐藏返回文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-100, -60) forBarMetrics:UIBarMetricsDefault];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置表格背景透明
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 创建背景视图
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.tableView.bounds];
    bgImageView.image = [UIImage imageNamed:@"main_bg7"];
    // 设置为表格背景视图
    self.tableView.backgroundView = bgImageView;
    
    // 创建Nib
    UINib *nib = [UINib nibWithNibName:@"LFSeeInfoTableViewCell" bundle:nil];
    // 注册nib
    [self.tableView registerNib:nib forCellReuseIdentifier:@"LFSeeInfoTableViewCell"];
    
    [self createBackItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 隐藏tabbar
    self.tabBarController.tabBar.hidden = YES;
    
    // 刷新表格
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

/**
 *  创建后退按钮
 */
- (void)createBackItem {
    // 创建item
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"透明返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backItemClick)];
    //    item.imageInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    // 设置item
    self.navigationItem.leftBarButtonItem = item;
}

- (void)backItemClick {
    // 跳回
    [self.navigationController popViewControllerAnimated:YES];
    //    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)setTalkButton {
    // 创建对象
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 设置frame
    CGFloat x = 0;
    CGFloat width = kScreenW;
    CGFloat height = 44;
    CGFloat y = kScreenH - height;
    button.frame = CGRectMake(x, y, width, height);
    
    // 设置背景颜色
    button.backgroundColor = [UIColor colorWithRed:0.004 green:0.016 blue:0.051 alpha:0.410];
    [button setTitle:@"聊一聊" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // 添加点击事件
    [button addTarget:self action:@selector(takeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 加入视图
    [self.view addSubview:button];
}

- (void)takeButtonClick {
    self.talkBlock(self);
}

#pragma mark - 表格代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建单元格
    LFSeeInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFSeeInfoTableViewCell" forIndexPath:indexPath];
    // 传递用户基本信息
    cell.obj = self.obj;
    // 设置单元格数据
    [cell setCell:self.temp];
    // 如果是女
    if ([self.temp.role isEqualToString:@"女"]) {
        // 改变灯光
        self.lightingBgImage.image = [UIImage imageNamed:@"mood_nine1"];
    }
    
    __weak typeof(cell) tempCell = cell;
    // 设置代码块
    cell.tapBlock = ^(LFSeeInfoTableViewCell *infoCell) {
        UIAlertController *ac = [MyAlertClass alertControllerWithTitle:@"偷看真容" message:nil preferredStyle:UIAlertControllerStyleActionSheet alertActionSubmitTitle:@"花30钻石偷看" alertAtionCancleTitle:@"算了" andHander:^{
            // 获取我的明信片
            XMPPvCardTemp *myvCardTemp = [LFXMPPHelp shareXMPPHelp].xmppvCardTempModule.myvCardTemp;
            // 获取钻石数量
            NSString *money = myvCardTemp.givenName;
            // 判断钻石是否足够
            if ([money intValue] > 30) {
                // 显示真身
                [tempCell transparentImageViewOver];
                // 计算扣除后钻石数量
                myvCardTemp.givenName = [NSString stringWithFormat:@"%d", [money intValue] - 30];
                // 通知服务器更新
                [[LFXMPPHelp shareXMPPHelp].xmppvCardTempModule updateMyvCardTemp:myvCardTemp];
                [MBProgressHUD showSuccess:@"成功扣除30钻石,开始偷窥!"];
                // 已经付费
                tempCell.isPay = YES;
            } else {
                [MBProgressHUD showError:@"抱歉,您的钻石不足"];
            }
        }];
                // 弹出选项
        [self presentViewController:ac animated:YES completion:nil];
    };
    
    // 详细页拨打电话回调代码块
    cell.callBlock = ^(LFSeeInfoTableViewCell *cell, NSString *number) {
        if ([LFUserInfo isTelphoneNum:number]) { // 如果是电话号码
            NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@", number];
            UIWebView *callWebView = [[UIWebView alloc] init];
            [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebView];
        } else {
            [MBProgressHUD showError:@"(⊙o⊙)…您的好友电话号码是错误的"];
        }
    };

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 350;
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
