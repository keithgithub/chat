//
//  LFUserSideViewController.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/26.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFUserSideViewController.h"
#import "LFSideTableViewCell.h"
#import "LFConstant.h"
#import "LFUserInfoTableViewController.h"
#import "MBProgressHUD+MJ.h"
#import "LFNavigationController.h"
#import "LFXMPPHelp.h"
#import "SDImageCache.h"
#import "LFQcodeViewController.h"

@interface LFUserSideViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LFUserSideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.view.backgroundColor = [UIColor clearColor];
    // 设置表格颜色透明
    self.tableView.backgroundColor = [UIColor clearColor];
    // 取消分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 创建nib
    UINib *nib = [UINib nibWithNibName:@"LFSideTableViewCell" bundle:[NSBundle mainBundle]];
    // 注册nib
    [self.tableView registerNib:nib forCellReuseIdentifier:@"LFSideTableViewCell"];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    // 如果点击的是view
    if ([touch.view isKindOfClass:[UIView class]]) {
        // 调用代理
        [self.delegate userSideViewControllerDidClickOtherView:self];
    }
}

#pragma mark - 表格代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 从队列中获取单元格
    LFSideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFSideTableViewCell" forIndexPath:indexPath];
    // 设置单元格背景颜色透明
    cell.backgroundColor = [UIColor clearColor];
    // 设置单元格选中样式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        [cell setCellWithTitle:@"个人资料" andClickBlock:nil];
    } else if (indexPath.row == 1) {
        [cell setCellWithTitle:@"我的二维码" andClickBlock:nil];
    } else if (indexPath.row == 2) {
        [cell setCellWithTitle:@"清理缓存" andClickBlock:nil];
    } else if (indexPath.row == 3) {
        [cell setCellWithTitle:@"注销" andClickBlock:nil];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        [self.delegate userSideViewControllerDidClickUserInfo:self];
    } else if (indexPath.row == 1) {
        //self.imgVQR.image = [QRCodeGenerator qrImageForString:name imageSize:self.imgVQR.bounds.size.width];
        [self.delegate userSideViewControllerDidClickQcodeView:self];
    } else if (indexPath.row == 2) {
        // 计算缓存大小
        float cal = [self calLblCacheValue];
        // 删除沙盒目录所有文件
        [self clearTmpPics];
        
        // 判断够不够1M
        NSString *clearCacheName = cal >= 1 ? [NSString stringWithFormat:@"%.2fM",cal] : [NSString stringWithFormat:@"%.2fK",cal * 1024];
        // 弹出提示
        [MBProgressHUD showSuccess:[NSString stringWithFormat:@"成功清除%@缓存", clearCacheName]];
    } else if (indexPath.row == 3) {
        // 注销
        [[LFXMPPHelp shareXMPPHelp] xmppUserLogout];
        // 弹出提示
        [MBProgressHUD showSuccess:@"注销成功"];
        
        // 获取故事板
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //    // 获取标签栏视图
        //    LFTabBarController *tabBarVc = [sb instantiateViewControllerWithIdentifier:@"LFTabBarController"];
        
        LFNavigationController *naVc = [sb instantiateViewControllerWithIdentifier:@"loginNav"];
        
        // 获取window
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        // 设置跟视图
        window.rootViewController = naVc;
    }
}

/**
 *  清除缓存
 */
- (void)clearTmpPics {
    // sd清除缓存
    [[SDImageCache sharedImageCache] clearDisk];
    // 清除document目录的文件缓存
    [self clearDocument];
}

/**
 *  清除document目录的文件缓存
 */
- (void)clearDocument {
    // 获取沙盒路径
    NSString *diskCachePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    // 获取文件枚举器
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:diskCachePath];
    // 遍历
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [diskCachePath stringByAppendingPathComponent:fileName];
        NSFileManager *manager = [NSFileManager defaultManager];
        NSError *err = nil;
        [manager removeItemAtPath:filePath error:&err];
    }
}

/**
 *  计算缓存大小
 */
- (float)calLblCacheValue {
    float totalSize = 0;
    // 获取缓存沙盒路径
    NSString *diskCachePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    // 获取文件枚举器
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:diskCachePath];
    // 遍历
    for (NSString *fileName in fileEnumerator) {
        // 获取目录下每一个缓存名字
        NSString *filePath = [diskCachePath stringByAppendingPathComponent:fileName];
        // 获取文件属性
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        // 累加计算文件大小
        unsigned long long length = [attrs fileSize];
        // 用M为单位
        totalSize += length / 1024.0 / 1024.0;
    }
    
    return totalSize;
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
