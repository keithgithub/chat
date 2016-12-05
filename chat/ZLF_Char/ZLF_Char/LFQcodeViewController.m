//
//  LFQcodeViewController.m
//  ZLF_Char
//
//  Created by ibokan on 15/12/3.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFQcodeViewController.h"
#import "QRCodeGenerator.h"
#import "LFXMPPHelp+Message.h"
#import "XMPPvCardTemp.h"
#import "LFConstant.h"

@interface LFQcodeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qcodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation LFQcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 隐藏返回文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-100, -60) forBarMetrics:UIBarMetricsDefault];
    
    // 设置标题
    self.title = @"我的二维码";
    
    // 获取我的明信片
    XMPPvCardTemp *myvCard = [LFXMPPHelp shareXMPPHelp].xmppvCardTempModule.myvCardTemp;
    
    if (myvCard.familyName) { // 如果城市有设置
        self.cityLabel.text = myvCard.familyName;
    }
    
    if (myvCard.nickname) { // 如果昵称存在
        self.nameLabel.text = myvCard.nickname;
    }
    
    if (myvCard.photo) { // 如果头像存在
        self.iconView.image = [UIImage imageWithData:myvCard.photo];
    }
    
#warning 此处仅为测试
    self.qcodeImageView.image = [QRCodeGenerator qrImageForString:@"15160002593" imageSize:self.qcodeImageView.bounds.size.width];
    
    if ([myvCard.role isEqualToString:@"女"]) { // 如果是女
        //        self.sexLabel.image = [UIImage imageNamed:@"button_female_big02"];
        // 更改性别图片
        self.sexLabel.image = [UIImage imageNamed:@"girl"];
        // 更改名字颜色
        self.nameLabel.textColor = kGirlColor;
        // 更改描述颜色
        self.descriptionLabel.textColor = kGirlColor;
    }
    
    // 创建后退按钮
    [self createBackItem];
}

#pragma mark - 导航栏后退按钮
/**
 *  创建后退按钮
 */
- (void)createBackItem {
    // 创建item
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"透明返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backItemClick)];
    // 设置item
    self.navigationItem.leftBarButtonItem = item;
}

- (void)backItemClick {
    // 跳回
    [self.navigationController popViewControllerAnimated:YES];
    //    [self.navigationController popToRootViewControllerAnimated:YES];
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
