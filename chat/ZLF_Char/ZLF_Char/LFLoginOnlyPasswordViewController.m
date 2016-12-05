//
//  LFLoginOnlyPasswordViewController.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/25.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFLoginOnlyPasswordViewController.h"
#import "LFLoginOnlyPasswordTableViewCell.h"
#import "LFConstant.h"
#import "MyAlertClass.h"
#import "LFRegisterViewController.h"
#import "LFLoginViewController.h"

@interface LFLoginOnlyPasswordViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation LFLoginOnlyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)moreButtonClick:(UIButton *)sender {
    // 获取故事板
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    UIAlertController *ac = [MyAlertClass alertControllerWithTitle:@"请选择" message:@"请登陆方式" preferredStyle:UIAlertControllerStyleActionSheet alertActionSubmitTitle:@"切换账号..." alertAtionOtherTitle:@"注册" alertAtionCancleTitle:@"取消" andHander:^{
        // 创建登陆视图对象
        LFLoginViewController *loginVc = [sb instantiateViewControllerWithIdentifier:@"LFLoginViewController"];
        // 跳出视图
        [self presentViewController:loginVc animated:YES completion:nil];
    } andOther:^{
        // 创建注册对象
        LFRegisterViewController *registerVc = [sb instantiateViewControllerWithIdentifier:@"LFRegisterViewController"];
        // 跳出视图
        [self presentViewController:registerVc animated:YES completion:nil];
    }];
    
    // 弹出提示框
    [self presentViewController:ac animated:YES completion:nil];
}

#pragma mark - 表格代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 从队列中获取单元格
    LFLoginOnlyPasswordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFLoginOnlyPasswordTableViewCell" forIndexPath:indexPath];
    [cell setCell:@""];
    
    return cell;
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
