//
//  LFProfileTableViewController.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/25.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFProfileViewController.h"
#import "LFProfileTableViewCell.h"
#import "LFUserSideViewController.h"
#import "MyAlertClass.h"
#import "MBProgressHUD+MJ.h"
#import "LFConstant.h"
#import "XMPPvCardTemp.h"
#import "LFXMPPHelp.h"
#import "LFSideView.h"
#import "LFUserInfoTableViewController.h"
#import "LFQcodeViewController.h"

@interface LFProfileViewController () <UITableViewDataSource, UITableViewDelegate, UserSideViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView; // 表格
@property (nonatomic, strong) LFUserSideViewController *sideVc; // 侧拉视图
@property (nonatomic, assign) BOOL isClickSideView; // 侧拉视图状态
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImagePickerController *imagePicker; // 相片选择
@property (nonatomic, strong) LFProfileTableViewCell *cell; // cell对象
@property (weak, nonatomic) IBOutlet UIImageView *lamplightImageView;
@property (nonatomic, strong) LFSideView *sideView;
@end

@implementation LFProfileViewController

#pragma mark - 懒加载
- (UIImagePickerController *)imagePicker {
    if (_imagePicker == nil) {
        // 创建对象
        _imagePicker = [[UIImagePickerController alloc] init];
        // 设置代理
        _imagePicker.delegate = self;
        // 允许编辑
        _imagePicker.allowsEditing = YES;
    }
    
    return _imagePicker;
}

#pragma mark - 初始化方法
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        // 设置未被选中图片
        self.navigationController.tabBarItem.image = [[UIImage imageNamed:@"personal01"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        // 设置被选中图片
        self.navigationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"personal02"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置表格透明
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 我的明信片
    XMPPvCardTemp *myvCard = [LFXMPPHelp shareXMPPHelp].xmppvCardTempModule.myvCardTemp;
    if (myvCard.role) { // 如果是女
        if ([myvCard.role isEqualToString:@"女"]) {
            // 更改灯光
            self.lamplightImageView.image = [UIImage imageNamed:@"mood_nine1"];
        }
    }
    
    // 创建导航栏右侧按钮icon_personal_press
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"MoreSetting2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    // 设置为右侧按钮
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // 创建Nib
    UINib *nib = [UINib nibWithNibName:@"LFProfileTableViewCell" bundle:nil];
    // 注册nib
    [self.tableView registerNib:nib forCellReuseIdentifier:@"LFProfileTableViewCell"];
    
    // 创建侧拉视图
    [self createSideView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)createSideView {
    // 创建对象
    self.sideVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LFUserSideViewController"];
    
    // 设置位置
    self.sideVc.view.frame = CGRectMake(kScreenW, 64 - kSideViewChangeY, kScreenW, kScreenH);
    // 设置代理
    self.sideVc.delegate = self;
//    [self addChildViewController:self.sideVc];
    // 加入视图
    [self.view addSubview:self.sideVc.view];
//    [[UIApplication sharedApplication].keyWindow addSubview:self.sideVc.view];
//    self.sideView = [[LFSideView alloc] initWithFrame:CGRectMake(kScreenW, 64 - kSideViewChangeY, kScreenW - 64 - 64, kScreenH)];
//    
//    [self.view addSubview:self.sideView];
}

/**
 *  右侧导航栏按钮点击
 */
- (void)rightItemClick {
    
    if (self.isClickSideView) {
        // 侧拉视图回退
        [self sideVcBack];
    } else {
        // 动画效果
        [UIView animateWithDuration:0.5 animations:^{
            // 表格缩小
//            self.tableView.transform = CGAffineTransformScale(self.tableView.transform, 0.8, 0.8);
            self.tableView.transform = CGAffineTransformMakeScale(0.8, 0.8);
            
            // 表格位移
            CGRect temp = self.tableView.frame;
            temp.origin.x -= 120;
            self.tableView.frame = temp;
            
            // 侧拉视图位移
            // 表格位移
            temp = self.sideVc.view.frame;
            temp.origin.x -= kScreenW;
            temp.origin.y += kSideViewChangeY;
            self.sideVc.view.frame = temp;
        }];
        
        // 状态取反
        self.isClickSideView = !self.isClickSideView;
    }
}

- (void)sideVcBack {
    // 动画效果
    [UIView animateWithDuration:0.5 animations:^{
        // 表格缩小
        self.tableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
        // 表格位移
        CGRect temp = self.tableView.frame;
        temp.origin.x += 120;
        self.tableView.frame = temp;
        
        // 侧拉视图位移
        // 表格位移
        temp = self.sideVc.view.frame;
        temp.origin.x += kScreenW;
        temp.origin.y -= kSideViewChangeY;
        self.sideVc.view.frame = temp;
    }];
    // 状态取反
    self.isClickSideView = !self.isClickSideView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建单元格
    self.cell = [tableView dequeueReusableCellWithIdentifier:@"LFProfileTableViewCell" forIndexPath:indexPath];
    // 设置单元格透明
    self.cell.backgroundColor = [UIColor clearColor];
    // 设置选中样式
    self.cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 设置单元格信息
    [self.cell setCell];
    // 弱指针self
    __weak typeof(self) vc = self;
    // 设置回调代码块
    self.cell.iconViewClckBlock = ^(LFProfileTableViewCell *cell) {
        UIAlertController *ac = [MyAlertClass alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet alertActionSubmitTitle:@"相机" alertAtionOtherTitle:@"相册" alertAtionCancleTitle:@"取消" andHander:^{
            // 如果用户允许访问相机
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                // 设置弹出源
                vc.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                // 弹出视图
                [vc presentViewController:vc.imagePicker animated:YES completion:nil];
            } else {
                [MBProgressHUD showError:@"您未允许访问相机"];
            }
        } andOther:^{
            // 如果用户允许访问相机
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                // 设置弹出源
                vc.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                // 弹出视图
                [vc presentViewController:vc.imagePicker animated:YES completion:nil];
            } else {
                [MBProgressHUD showError:@"您未允许访问相册"];
            }
        }];
        
        [vc presentViewController:ac animated:YES completion:nil];
    };
    
    return self.cell;
}

#pragma mark - imagePicker代理
/**
 *  选中图片后
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // 设置图片
    self.cell.iconView.image = info[UIImagePickerControllerEditedImage];
    // 退出图片选择
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    
    // 上传头像
    XMPPvCardTemp *myCard = [LFXMPPHelp shareXMPPHelp].xmppvCardTempModule.myvCardTemp;
    // 转二进制存储
    myCard.photo = UIImageJPEGRepresentation(self.cell.iconView.image, 0.7f);
    // 通知服务器更新
    [[LFXMPPHelp shareXMPPHelp].xmppvCardTempModule updateMyvCardTemp:myCard];
}


#pragma mark - 自定义代理
- (void)userSideViewControllerDidClickOtherView:(LFUserSideViewController *)sender {
    [self sideVcBack];
}

- (void)userSideViewControllerDidClickUserInfo:(LFUserSideViewController *)sender {
    // 侧拉回归
    [self sideVcBack];
    // 创建对象
    LFUserInfoTableViewController *userInfo = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LFUserInfoTableViewController"];
    // 跳转
    [self.navigationController pushViewController:userInfo animated:YES];
}

- (void)userSideViewControllerDidClickQcodeView:(LFUserSideViewController *)sender {
    // 侧拉回归
    [self sideVcBack];
    // 从故事板获取对象
    LFQcodeViewController *qcodeVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LFQcodeViewController"];
    // 跳转
    [self.navigationController pushViewController:qcodeVc animated:YES];
}

@end










