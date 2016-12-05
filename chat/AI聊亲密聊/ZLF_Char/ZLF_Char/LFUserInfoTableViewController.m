//
//  LFUserInfoTableViewController.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/28.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFUserInfoTableViewController.h"
#import "LFXMPPHelp.h"
#import "XMPPvCardTemp.h"
#import "MBProgressHUD+MJ.h"
#import "MyAlertClass.h"
#import "LFSQLTool.h"
#import "LFUserInfo.h"

@interface LFUserInfoTableViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *NickNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *sexButton;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *provinceMarray; // 省信息的数组
@property (nonatomic, assign) long provinceIndex; // 省的当前下标
@property (nonatomic, strong) NSMutableArray *cityMarray; // 市信息的数组
@property (nonatomic, assign) long cityIndex; // 市的当前下标
@property (nonatomic, strong) NSMutableArray *areaMarray; // 区信息的数组
@property (nonatomic, strong) UIToolbar *addressToolbar; // 地址工具条
@property (nonatomic, copy) NSString *provinceStr, *cityStr, *areaStr; // 地址字符串
@end

@implementation LFUserInfoTableViewController

- (UIPickerView *)pickerView {
    if (_pickerView == nil) {
        // 创建对象
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
        // 设置代理
        _pickerView.delegate = self;
    }
    
    return _pickerView;
}

/**
 *  工具条
 */
- (UIToolbar *)addressToolbar {
    if (_addressToolbar == nil) {
        // 创建对象
        _addressToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        // 设置按钮颜色
        UIColor *itemColor = [UIColor colorWithWhite:0.413 alpha:1.000];
        
        // 创建取消item
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(addressCancelItemClick)];
        // 设置字体颜色
        [cancelItem setTintColor:itemColor];
        
        // 创建弹簧item
        UIBarButtonItem *bouncesItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        // 创建确认item
        UIBarButtonItem *sureItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(addressSureItemClick)];
        // 设置字体颜色
        [sureItem setTintColor:itemColor];
        
        // 设置为工具条的item
        _addressToolbar.items = @[cancelItem, bouncesItem, sureItem];
    }
    
    return _addressToolbar;
}

- (void)addressCancelItemClick {
    // 关闭键盘
    [self.addressTextField resignFirstResponder];
}

- (void)addressSureItemClick {
    self.addressTextField.text = [NSString stringWithFormat:@"%@%@%@", self.provinceStr, self.cityStr, self.areaStr];
    // 关闭键盘
    [self.addressTextField resignFirstResponder];
}

- (NSMutableArray *)provinceMarray {
    if (_provinceMarray == nil) {
        _provinceMarray = [NSMutableArray new];
        _provinceMarray = [LFSQLTool infos:@"select * from 'region_conf' where pid = 1;"];
    }
    
    return _provinceMarray;
}

#pragma mark 系统初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置标题
    self.title = @"个人资料";
    
    // 设置背景颜色
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    // 创建背景视图
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.tableView.bounds];
    bgImageView.image = [UIImage imageNamed:@"main_bg7"];
    // 设置为表格背景视图
    self.tableView.backgroundView = bgImageView;
    
    // 初始化数组
    self.cityMarray = [NSMutableArray new];
    self.areaMarray = [NSMutableArray new];
    
    // 打开数据库
    [LFSQLTool open:@"region.sqlite"];
    
    // 设置地址输入框弹出的view
    self.addressTextField.inputView = self.pickerView;
    // 设置地址文本框弹出view的配置条
    self.addressTextField.inputAccessoryView = self.addressToolbar;
    
    // 默认选择第00的选择器
    [self pickerView:self.pickerView didSelectRow:0 inComponent:0];
    
    // 添加后退按钮
    [self createBackItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 隐藏tabbar
    self.tabBarController.tabBar.hidden = YES;
    
    // 获取自己的明信片
    XMPPvCardTemp *myvCardTemp = [LFXMPPHelp shareXMPPHelp].xmppvCardTempModule.myvCardTemp;
    if (myvCardTemp.nickname) {
        // 设置昵称
        self.NickNameLabel.text = myvCardTemp.nickname;
    }
    if (myvCardTemp.role) {
        // 设置性别
        [self.sexButton setTitle:myvCardTemp.role forState:UIControlStateNormal];
    }
    
    if (myvCardTemp.familyName) {
        // 设置地址
        self.addressTextField.text = myvCardTemp.familyName;
    }
    
    // 设置电话
    if (myvCardTemp.note) {
        self.txtPhone.text = myvCardTemp.note;
    }
    
    // 改变昵称文本框风格
    [self changeTextFieldStyle:self.NickNameLabel];
    // 改变昵称文本框风格
    [self changeTextFieldStyle:self.txtPhone];
    // 改变昵称文本框风格
    [self changeTextFieldStyle:self.addressTextField];
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


/**
 *  改变文本框风格
 */
- (void)changeTextFieldStyle:(UITextField *)txt {
    // KVC修改提示文本颜色
    [txt setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [txt setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    
    // 修改键盘风格
    txt.keyboardAppearance=UIKeyboardAppearanceDark;
    
    // 设置clearButton
    txt.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}


- (IBAction)sureButtonClick:(UIButton *)sender {
    // 获取自己的资源库
    XMPPvCardTemp *myvCardTemp = [LFXMPPHelp shareXMPPHelp].xmppvCardTempModule.myvCardTemp;
    if (![self.NickNameLabel.text isEqualToString:@""] && ![self.NickNameLabel.text isEqualToString:@"请输入您的昵称"]) {
        // 存储昵称
        myvCardTemp.nickname = self.NickNameLabel.text;
    }
    
    // 存储性别
    myvCardTemp.role = self.sexButton.titleLabel.text;
    // 存储城市地址
//    myvCardTemp.addresses = @[self.addressTextField.text];
    
//    myvCardTemp.formattedName = self.addressTextField.text;
    
    // 注:givenName作为钻石使用
//    myvCardTemp.givenName = @"1845";
    
    // 地址
    if (![self.addressTextField.text isEqualToString:@""] && ![self.addressTextField.text isEqualToString:@"请选择您的城市"]) {
        myvCardTemp.familyName = self.addressTextField.text;
    }
    
    if (![self.txtPhone.text isEqualToString:@""] && self.txtPhone.text != nil) {
        // 如果电话号码格式正确
        if ([LFUserInfo isTelphoneNum:self.txtPhone.text]) {
            myvCardTemp.note = self.txtPhone.text;
        } else {
            // 弹出提示并离开
            [MBProgressHUD showError:@"电话填写格式不正确"];
            return;
        }
    }
    
    // 如果有值为空
    if ([self.txtPhone.text isEqualToString:@""] || [self.sexButton.titleLabel.text isEqualToString:@""] || [self.txtPhone.text isEqualToString:@""] || [self.addressTextField.text isEqualToString:@""] || [self.NickNameLabel.text isEqualToString:@""]) {
        
    } else {
        if (myvCardTemp.prefix == nil) {
            if (myvCardTemp.givenName) {
                int num = [myvCardTemp.givenName intValue];
                num += 100;
                
                myvCardTemp.givenName = [NSString stringWithFormat:@"%d", num];
            } else {
                myvCardTemp.givenName = @"100";
            }
            myvCardTemp.prefix = @"是";
            [MBProgressHUD showSuccess:@"首次填写完整信息，赠送一百钻石"];
            // 通知服务器更新
            [[LFXMPPHelp shareXMPPHelp].xmppvCardTempModule updateMyvCardTemp:myvCardTemp];
            [self.navigationController popViewControllerAnimated:YES];
            
            return;
        }
    }
    
    // 通知服务器更新
    [[LFXMPPHelp shareXMPPHelp].xmppvCardTempModule updateMyvCardTemp:myvCardTemp];
    
    // 提示
    [MBProgressHUD showSuccess:@"更新成功"];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

/**
 *  性别按钮点击
 */
- (IBAction)sexButtonClick:(UIButton *)sender {
    UIAlertController *ac = [MyAlertClass alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet alertActionSubmitTitle:@"男" alertAtionOtherTitle:@"女" alertAtionCancleTitle:@"取消" andHander:^{
        // 修改文本为男
        [self.sexButton setTitle:@"男" forState:UIControlStateNormal];
    } andOther:^{
        // 修改文本为男
        [self.sexButton setTitle:@"女" forState:UIControlStateNormal];
    }];
    [self presentViewController:ac animated:YES completion:nil];
}

#pragma mark - pickView代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) { // 如果是第一组
        
        return self.provinceMarray.count;
    } else if (component == 1) { // 如果是第二组
        // 取出对应的省信息字典
        NSDictionary *dict = self.provinceMarray[self.provinceIndex];
        // 删除市数组原本信息
        [self.cityMarray removeAllObjects];
        // 从数据库查询对应的市信息
        self.cityMarray = [LFSQLTool infos:[NSString stringWithFormat:@"select * from 'region_conf' where pid = %@;", dict[@"id"]]];
        
        return self.cityMarray.count;
    } else {
        // 去除对应的市信息字典
        NSDictionary *dict = self.cityMarray[self.cityIndex];
        // 删除区数组原本信息
        [self.areaMarray removeAllObjects];
        // 从数据库查询对应的区信息
        self.areaMarray = [LFSQLTool infos:[NSString stringWithFormat:@"select * from 'region_conf' where pid = %@;", dict[@"id"]]];
        
        return self.areaMarray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        // 获取对应省信息
        NSDictionary *dict = self.provinceMarray[row];
        //        self.provinceStr = dict[@"name"];
        //        NSLog(@"%@", dict[@"name"]);
        return dict[@"name"];
    } else if (component == 1) {
        // 获取对应市信息
        NSDictionary *dict = self.cityMarray[row];
        //        self.cityStr = dict[@"name"];
        //        NSLog(@"%@", dict[@"name"]);
        return dict[@"name"];
    } else {
        NSDictionary *dict = self.areaMarray[row];
        //        self.areaStr = dict[@"name"];
        //        NSLog(@"%@", dict[@"name"]);
        return dict[@"name"];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        // 存储下标
        self.provinceIndex = row;
        // 刷新第2组
        [self.pickerView reloadComponent:1];
        // 将光标移到第一个
        [self pickerView:self.pickerView didSelectRow:0 inComponent:1];
        // 模拟选中 对应上方移动
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
        
        // 当第二组的光标移动第三组的值也要对应变化
        [self.pickerView reloadComponent:2];
        // 将光标移到第一个
        [self.pickerView selectRow:0 inComponent:2 animated:YES];
        // 模拟选中 对应上方移动
        [self pickerView:self.pickerView didSelectRow:0 inComponent:2];
        
        NSDictionary *dict = self.provinceMarray[row];
        self.provinceStr = dict[@"name"];
        
    } else if (component == 1) {
        // 存储市下标
        self.cityIndex = row;
        // 刷新第三组
        [self.pickerView reloadComponent:2];
        // 将光标移到第一个
        [self.pickerView selectRow:0 inComponent:2 animated:YES];
        // 模拟选中 对应上方移动
        [self pickerView:self.pickerView didSelectRow:0 inComponent:2];
        
        // 取出对应的值
        NSDictionary *dict = self.cityMarray[row];
        // 复制字符串
        self.cityStr = dict[@"name"];
    } else {
        // 取出对应的值
        NSDictionary *dict = self.areaMarray[row];
        self.areaStr = dict[@"name"];
    }
}


//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//    return 5;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
