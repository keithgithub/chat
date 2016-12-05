//
//  SettingViewController.m
//  xin_chat
//
//  Created by ibokan on 15/11/26.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import "SettingViewController.h"
#import "SDImageCache.h"
#import "MBProgressHUD+MJ.h"
#import "HelpTableViewController.h"
#import "HelpDetailTableViewController.h"

#define kScreen_size [UIScreen mainScreen].bounds.size
@interface SettingViewController ()

@property (nonatomic,strong) UIButton *btnClean;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"设置";
    // 背景
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 左侧按钮
    UIBarButtonItem *LeftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"topbar_menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    // 添加
    self.navigationItem.leftBarButtonItem = LeftItem;
    
    [self creacteCleanMemoryView];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setLblCacheValue];
}


// 创建清理缓存view
- (void)creacteCleanMemoryView
{
    UIView *cleanView = [[UIView alloc] initWithFrame:self.view.bounds];
    
   // 清理缓存按钮
    self.btnClean = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnClean.frame = CGRectMake(60, 100, kScreen_size.width-120, 30);
    self.btnClean.layer.cornerRadius = 5;
    self.btnClean.layer.masksToBounds = YES;
    
    [self.btnClean setTitle:@"" forState:UIControlStateNormal];
    [self.btnClean setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnClean setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
   self.btnClean.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    
    [self.btnClean addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];

    // 使用帮助按钮
    UIButton *btnHelp = [UIButton buttonWithType:UIButtonTypeCustom];
    btnHelp.frame = CGRectMake(60, 170, kScreen_size.width-120, 30);
    btnHelp.layer.cornerRadius = 5;
    btnHelp.layer.masksToBounds = YES;
    [btnHelp setTitle:@"使用帮助" forState:UIControlStateNormal];
    [btnHelp setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
    [btnHelp  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     btnHelp .titleLabel.font = [UIFont boldSystemFontOfSize:17];
     [btnHelp addTarget:self action:@selector(btnHelp) forControlEvents:UIControlEventTouchUpInside];
    
    // 意见反馈按钮
    /*UIButton *btnEmail = [UIButton buttonWithType:UIButtonTypeCustom];
    btnEmail .frame = CGRectMake(60, 240, kScreen_size.width-120, 30);
    btnEmail .layer.cornerRadius = 5;
    btnEmail .layer.masksToBounds = YES;
    [btnEmail  setTitle:@"意见反馈" forState:UIControlStateNormal];
    [btnEmail  setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
    [btnEmail   setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnEmail.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [btnEmail  addTarget:self action:@selector(btnEmail) forControlEvents:UIControlEventTouchUpInside];*/
    
    // 隐私按钮
    UIButton *btnmm = [UIButton buttonWithType:UIButtonTypeCustom];
    btnmm.frame = CGRectMake(60, 240, kScreen_size.width-120, 30);
    btnmm.layer.cornerRadius = 5;
    btnmm.layer.masksToBounds = YES;
    [btnmm  setTitle:@"隐私政策" forState:UIControlStateNormal];
    [btnmm  setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
    [btnmm   setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnmm.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [btnmm  addTarget:self action:@selector(btnmm) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    // 添加
    [cleanView addSubview:btnmm];
    //[cleanView addSubview:btnEmail];
    [cleanView addSubview:self.btnClean];
    [cleanView addSubview:btnHelp];
    [self.view addSubview:cleanView];
}

// 隐私
- (void)btnmm
{
    HelpDetailTableViewController *vc = [HelpDetailTableViewController new];

    vc.title = @"隐私政策";
    
    vc.txt = @"Ai聊非常重视用户的隐私权，以下是我们对您信息收集，使用和保护的政策，请您认真阅读。\n1.信息的收集和使用、如果您已安装Ai聊移动客户端软件、则Ai聊可能会读取您的移动设备属性以及其存储信息，包括但不限您使用设备的品牌及型号、设备的识别码、电信运营商、所在国家或地区、以及您的所在地等信息\n2、信息的公开和分享在未经您同意之前，Ai聊不会向任何第三方提供，出售，出租，分享和交易您的个人资料，但以下情形除外\n2.1 为遵守法律法规之要求，包括在国家有关机关或其授权的单位查询时，向其提供有关资料\n2.2 为免除您再生命、身体或财产方面之急迫危险，或为防止他人权益之重大危害\n2.3 在您被他人投诉侵犯知识产权或其他合法权利时，需要向投诉人披露您的必要资料，以便进行投诉处理";
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


// 反馈
- (void)btnEmail
{
    
    
}

//帮助
- (void)btnHelp
{
    //NSLog(@"sfsdfdsf");
    UIStoryboard *stotyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HelpTableViewController *helpVC = [stotyboard instantiateViewControllerWithIdentifier:@"helpVC"];
    
    [self.navigationController pushViewController:helpVC animated:YES];
}
// 清理缓存
- (void)btnAction:(UIButton *)sender
{
    
    [MBProgressHUD showSuccess:@"清理成功！"];
    
    [self clearTmpPics];
    
}

- (void)clearTmpPics
{
    //SD清除缓存，主要是图片下载
    [[SDImageCache sharedImageCache] clearDisk];
    //清除document目录的文件缓存
    [self  clearDocument];
    
   //改变清除后的缓存大小
    [self  setLblCacheValue];
}

/**
 *  删除沙盒目录的说有文件
 */
-(void)clearDocument
{
    NSString *diskCachePath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:diskCachePath];
    
    for (NSString *fileName in fileEnumerator)
    {
        NSString *filePath = [diskCachePath stringByAppendingPathComponent:fileName];
        NSFileManager *manager = [NSFileManager defaultManager];
        NSError *err=nil;
        [manager  removeItemAtPath:filePath error:&err];
        //WCLog(@"清空沙盒%@",err);
        
    }
}

/**
 *  设置缓存值
 */
-(void)setLblCacheValue
{
    float tmpSize = [self  checkTmpSize];
    
    NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"%.2fM",tmpSize] : [NSString stringWithFormat:@"%.2fK",tmpSize * 1024];

    NSString *str = [NSString stringWithFormat:@"清理缓存（%@）",clearCacheName];
    
    [self.btnClean setTitle:str forState:UIControlStateNormal];
    
}

- (float)checkTmpSize
{
    float totalSize = 0;
    //获取document目录的文件（主要是发送语音存储的文件）
    NSString *diskCachePath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:diskCachePath];
    
    for (NSString *fileName in fileEnumerator)
    {
        //获取document目录下的每一个文件爱你名字
        NSString *filePath = [diskCachePath stringByAppendingPathComponent:fileName];
        //获取文件属性
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        //累加计算文件大小
        unsigned long long length = [attrs fileSize];
        
        totalSize += length / 1024.0 / 1024.0;//M(单位）
    }
    return totalSize;
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
