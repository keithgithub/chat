//
//  MyCenterViewController.m
//  xin_chat
//
//  Created by ibokan on 15/11/25.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import "MyCenterViewController.h"
#import "MyAlertClass.h"
#import "PhotoTweaksViewController.h"
#import <sqlite3.h>
#import "XMPPHelp.h"
#import "XMPPvCardTemp.h"
#import "MBProgressHUD+MJ.h"
#import "NSString+LabelHight.h"

#define kScreen_size [UIScreen mainScreen].bounds.size

@interface MyCenterViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PhotoTweaksViewControllerDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    // 操作数据库的对象
    sqlite3 *db;
}
// 生日 picker
@property (nonatomic,strong) UIDatePicker *datePicker;
// 地址 picker
@property (nonatomic,strong) UIPickerView *addressPicker;
// 性别 picker
@property (nonatomic,strong) UIPickerView *sexPicker;

// 地址数组
@property (nonatomic,strong) NSMutableArray *arr_address;
// 省
@property (nonatomic, strong) NSMutableArray *mArrProvince;
// 市
@property (nonatomic, strong) NSMutableArray *mArrCity;
// 表视图
@property (nonatomic,strong) MBTwitterScroll *myTableView;

// 文字文本框
@property (nonatomic,strong) UITextField *txt_name;
// 签名
@property (nonatomic,strong) UILabel *txt_say;
// 日期
@property (nonatomic,strong) UITextField *txt_date;
// 地址
@property (nonatomic,strong) UITextField *txt_address;
// 性别
@property (nonatomic,strong) UITextField *txt_sex;
@property (nonatomic,strong) UILabel *lblUserName;


// 照片管理器
@property (nonatomic,strong)  UIImagePickerController *imagePickerController;
// 头像
@property (nonatomic,strong) UIImage *imgHead;

@property (nonatomic,strong) NSMutableDictionary *mDic_data;

@end

@implementation MyCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    self.view.backgroundColor = [UIColor whiteColor];
   
    self.arr_address = [NSMutableArray new];
    self.mArrProvince = [NSMutableArray new];
    self.mArrCity = [NSMutableArray new];
    self.mDic_data = [NSMutableDictionary new];
    self.imgHead = [UIImage imageNamed:@"avtar_120_default"];
    [self loadData];
    
    // 初始化对象
    self.txt_name = [[UITextField alloc] initWithFrame:CGRectMake(70, 5,kScreen_size.width-80, 30)];
    self.txt_name.delegate = self;
    // 初始化对象
    self.txt_say = [[UILabel alloc] initWithFrame:CGRectMake(70, 5,kScreen_size.width-80, 30)];
    // 初始化对象
    
    self.txt_date = [[UITextField alloc] initWithFrame:CGRectMake(70, 5,kScreen_size.width-80, 30)];
    self.txt_date.delegate = self;
    // 初始化对象
    self.txt_address = [[UITextField alloc] initWithFrame:CGRectMake(70, 5,kScreen_size.width-80, 30)];
    self.txt_address.delegate = self;
    // 初始化对象
    self.txt_sex = [[UITextField alloc] initWithFrame:CGRectMake(70, 5,kScreen_size.width-80, 30)];
    self.txt_sex.delegate = self;
    
    // 初始化  地址picker
    self.addressPicker = [[UIPickerView alloc] init];
    self.addressPicker.delegate = self;
    self.addressPicker.dataSource = self;
    self.addressPicker.showsSelectionIndicator = YES;
    self.addressPicker.backgroundColor = [UIColor whiteColor];
    
    // 初始化  地址picker
    self.sexPicker = [[UIPickerView alloc] init];
    self.sexPicker.delegate = self;
    self.sexPicker.dataSource = self;
    self.sexPicker.showsSelectionIndicator = YES;
    self.sexPicker.backgroundColor = [UIColor whiteColor];
    
    // 生日文本框使用的picker
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    
    // 设置响应值
    self.txt_sex.inputView = self.sexPicker;
    self.txt_date.inputView = self.datePicker;
    self.txt_address.inputView = self.addressPicker;
    
    // 左侧按钮
    UIBarButtonItem *LeftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"topbar_menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    // 添加
    self.navigationItem.leftBarButtonItem = LeftItem;
    
    self.myTableView = [[MBTwitterScroll alloc]
                                    initTableViewWithBackgound:[UIImage imageNamed:@"17"]
                                    avatarImage:self.imgHead
                                    titleString:@"个人信息"
                                    subtitleString:nil
                                    buttonTitle:@"修改头像"];
   // self.myTableView.frame = CGRectMake(0, 0, kScreen_size.width,kScreen_size.height);
    
    self.myTableView.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.tableView.delegate = self;
    self.myTableView.tableView.dataSource = self;
    self.myTableView.delegate = self;
    
    // 获取地址信息
    [self getAddressData];
    
    // 初始化数据为北京
    // 省
    for (int i = 0; i < self.arr_address.count; i++)
    {
        if ([self.arr_address[i][@"pid"] intValue] == 1)
        {
            [self.mArrProvince addObject:self.arr_address[i]];
        }
    }
    // 北京市
    for (int i = 0; i < self.arr_address.count; i++)
    {
        if ([self.arr_address[i][@"pid"] intValue] == 2)
        {
            [self.mArrCity addObject:self.arr_address[i]];
        }
    }
    
    [self creactToolBar];
    [self.view addSubview:self.myTableView];
    [self creactImagePickerController];
    [self creacteRightItem];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadData];
    [self.myTableView.tableView reloadData];
}

// 创建右侧按钮
- (void)creacteRightItem
{
    UIBarButtonItem *RightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = RightItem;
}

- (void)save
{
    [MBProgressHUD showSuccess:@"保存成功"];
    [self updateUserInfo:self.imgHead andNickName:self.txt_name.text andPhoto:@"13159201415"];
}


#pragma mark 上传头像
-(void)updateUserInfo:(UIImage *)imgH andNickName:(NSString *)nickname andPhoto:(NSString *)phone
{
    //一定要压缩，图片太大会更新失败
    NSData *dataFromImage = UIImageJPEGRepresentation(imgH, 0.0001f);
    
    //获取当前的电子名片信息
    XMPPvCardTemp *myvCard = [XMPPHelp shareXmpp].vCard.myvCardTemp;
    // 头像
    myvCard.photo = dataFromImage;
    // 昵称
    myvCard.nickname = nickname;
    // 性别
    myvCard.prefix = self.txt_sex.text;
    // 生日
    myvCard.formattedName = self.txt_date.text;
    // 地址
    myvCard.familyName = self.txt_address.text;
    // 签名
    myvCard.givenName = self.txt_say.text;
    
    NSLog(@"%@",myvCard.givenName);
    
    //更新 这个方法内部会实现数据上传到服务，无需程序自己操作
    [[XMPPHelp shareXmpp].vCard updateMyvCardTemp:myvCard];
    
    [self  loadData];
    
}
/**
 *  本地数据库获取用户信息
 */
-(void)loadData
{
     self.mDic_data = [NSMutableDictionary new];
    //xmpp提供了一个方法，直接获取个人信息
    XMPPvCardTemp *myVCard =[XMPPHelp shareXmpp].vCard.myvCardTemp;
    NSLog(@"-------------%@",myVCard.formattedName);
    
    // 设置头像
    if(myVCard.photo)
    {
        
        self.imgHead=[UIImage imageWithData:myVCard.photo];
       [self.myTableView.avatarImage setBackgroundImage:self.imgHead forState:UIControlStateNormal];
        
    }
    else
    {
        self.imgHead =[UIImage  imageNamed:@"avtar_120_default"];
        
    }
    
    if (myVCard.nickname)
    {
        // 设置昵称
        self.txt_name.text = myVCard.nickname;
        [self.myTableView.tableView reloadData];
        
    }
    else
    {
        self.txt_name.text=@"未命名";
    }
    
    if (myVCard.prefix != nil)
    {
        [self.mDic_data setObject:myVCard.prefix forKey:@"sex"];
        
    }
    if (myVCard.formattedName != nil)
    {
        [self.mDic_data setObject:myVCard.formattedName forKey:@"date"];
        
    }
    if (myVCard.familyName != nil)
    {
        [self.mDic_data setObject:myVCard.familyName forKey:@"address"];
        
    }
    if (myVCard.givenName != nil)
    {
        
        [self.mDic_data setObject:myVCard.givenName forKey:@"say"];
        
    }
    if (myVCard.nickname != nil)
    {
        [self.mDic_data setObject:myVCard.nickname forKey:@"name"];
    }

    
    // 设置微信号[用户名]
    self.lblUserName.text = [UserInfo shareUser].loginName;
    
}



#pragma mark -

// 设置键盘
- (void)creactToolBar
{
    // 建立UIToolbar
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreen_size.width, 44)];
    UIToolbar *toolBar1 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreen_size.width, 44)];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(addressCancelPicker:)];
    right.tag = 500;
    
    UIBarButtonItem *right1 = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(changeAddress:)];
    right1.tag = 300;
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(addressCancelPicker:)];
    left.tag = 600;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(changeAddress:)];
    left.tag = 600;
    
    toolBar.items = [NSArray arrayWithObjects:spaceItem,right,nil];
    toolBar1.items = [NSArray arrayWithObjects:left1,spaceItem, right1,nil];
    
    self.txt_sex.inputAccessoryView = toolBar1;
    self.txt_address.inputAccessoryView = toolBar1;
    self.txt_date.inputAccessoryView = toolBar;
}
// 取消
- (void)addressCancelPicker:(UIToolbar*)sender
{
    // 取消文本框响应者
    [self.txt_name resignFirstResponder];
    [self.txt_date resignFirstResponder];
    [self.txt_address resignFirstResponder];
    [self.txt_say resignFirstResponder];
    [self.txt_sex resignFirstResponder];
    
}

// 完成
- (void)changeAddress:(UIToolbar *)sender
{
    if (sender.tag == 300)
    {
        // 获得省
        NSInteger provinceRow = [self.addressPicker selectedRowInComponent:0];
        NSString *strProvince = self.mArrProvince[provinceRow][@"name"];
        // 获得市
        NSInteger cityRow = [self.addressPicker selectedRowInComponent:1];
        NSString *strCity = self.mArrCity[cityRow][@"name"];
        // 显示
        self.txt_address.text = [NSString stringWithFormat:@"%@-%@",strProvince,strCity];
        
        
        // 获得性别
        NSInteger integer = [self.sexPicker selectedRowInComponent:0];
        if (integer == 0)
        {
            self.txt_sex.text = @"男";
        }
        else
        {
            self.txt_sex.text = @"女";
        }
        
        [self.txt_sex resignFirstResponder];
        [self.txt_address resignFirstResponder];
        
    }
    else
    {
        [self.txt_address resignFirstResponder];
    }
}


// picker 选中时调用的方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // 更改省份
    if (component == 0)
    {
        // 清空城市数组
        [self.mArrCity removeAllObjects];
        for (int i = 0; i <self.arr_address.count; i++)
        {
            if ([self.arr_address[i][@"pid"] isEqualToString:self.mArrProvince[row][@"id"]])
            {
                [self.mArrCity addObject:self.arr_address[i]];
            }
            // 刷新
            [self.addressPicker reloadAllComponents];
        }
     
        [self.addressPicker selectRow:0 inComponent:1 animated:YES];
        
    }

}
#pragma mark picker代理方法
// 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == self.sexPicker)
    {
        return 1;
    }
    else
    {
        return 2;
    }
}
// 行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.sexPicker)
    {
        return 2;
    }
    else
    {
        if (component == 0)
        {
            return self.mArrProvince.count;
        }
        else
        {
            return self.mArrCity.count;
        }
    }
}

// 内容
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.sexPicker)
    {
        if (row == 0)
        {
            return @"男";
        }
        else
        {
            return @"女";
        }
        
    }
    else
    {
        if (component == 0)
        {
            if (self.mArrProvince.count > 0)
            {
                return [self.mArrProvince objectAtIndex:row][@"name"];
            }
        }
        else
        {
            if (self.mArrCity.count > 0)
            {
                return [self.mArrCity objectAtIndex:row][@"name"];
            }
        }
    }
    
    return nil;
    
}

#pragma mark  获取地址数据库数据的方法
- (void)getAddressData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"region" ofType:@"sqlite"];
    if (path != nil)
    {
        sqlite3_open([path UTF8String], &db);
        NSString *sql = @"select *from 'region_conf';";
        sqlite3_stmt *statu_stmt;
        sqlite3_prepare_v2(db, [sql UTF8String], -1, &statu_stmt, nil);
        while (sqlite3_step(statu_stmt) == SQLITE_ROW)
        {
            int id_int = sqlite3_column_int(statu_stmt, 0);
            char *name_text = (char *)sqlite3_column_text(statu_stmt, 1);
            int pid_int = sqlite3_column_int(statu_stmt, 2);
            
            NSString *add_id = [NSString stringWithFormat:@"%d", id_int];
            NSString *add_name = [NSString stringWithUTF8String:name_text];
            NSString *add_pid = [NSString stringWithFormat:@"%d", pid_int];
            
            NSDictionary *dic = @{@"id":add_id, @"name":add_name, @"pid":add_pid};
            
            [self.arr_address addObject:dic];
        }
    }
    
}

#pragma mark textField 代理
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if (textField == self.txt_say)
//    {
//        CGRect rect = self.myTableView.frame;
//        
//        rect.origin.y -= 150;
//        
//        self.myTableView.frame = rect;
//    }

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.txt_date)
    {
        NSString *str = [NSString stringWithFormat:@"%@",self.datePicker.date];
        NSString *strDate  = [str substringToIndex:10];
        
        self.txt_date.text = strDate;
    }
//    if (textField == self.txt_say)
//    {
//        CGRect rect = self.myTableView.frame;
//        
//        rect.origin.y += 100;
//        
//        self.myTableView.frame = rect;
//    }
  
}

#pragma mark -

#pragma mark 相机 相册 按钮点击事件
// 初始化照片选择器
- (void)creactImagePickerController
{
    self.imagePickerController = [UIImagePickerController new];
    self.imagePickerController.delegate = self;
}

#pragma mark 照片控制器代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    PhotoTweaksViewController *photoTweaksViewController = [[PhotoTweaksViewController alloc] initWithImage:image];
    photoTweaksViewController.delegate = self;
    [picker pushViewController:photoTweaksViewController animated:YES];
    
}
#pragma mark 照片编辑代理
// 取消按钮
- (void)photoTweaksControllerDidCancel:(PhotoTweaksViewController *)controller
{
    // 退出照片选择器
    [self.imagePickerController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

// 确定按钮
- (void)photoTweaksController:(PhotoTweaksViewController *)controller didFinishWithCroppedImage:(UIImage *)croppedImage
{
    
    // 退出照片选择器
    [self.imagePickerController dismissViewControllerAnimated:YES completion:^{
        
        self.imgHead = croppedImage;
        [self.myTableView.avatarImage setBackgroundImage:croppedImage forState:UIControlStateNormal];
    }];
    

}



#pragma mark MBTwitterScrollDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4)
    {
        [self updateUserInfo:self.imgHead andNickName:self.txt_name.text andPhoto:@"13159201415"];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UITableViewController *sayVC = [sb instantiateViewControllerWithIdentifier:@"sayVC"];
        
        [self.navigationController pushViewController:sayVC animated:YES];
    }
    
    
}

-(void) recievedMBTwitterScrollEvent
{

}
// 修改头像
- (void) recievedMBTwitterScrollButtonClicked
{
    // 推出提示框
    [self presentViewController:
     
     [MyAlertClass alertControllerWithTitle:@"拍照" andTitle2:@"相册选取" andHander1:^{
        
        // 如果用户允许相机弹出
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            // 设置相片选择控制器的来源
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        }

        // 弹出相片选择控制器
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    } andHander2:^{
        
        // 如果用户允许相册弹出
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            // 设置相片选择控制器的来源
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        // 弹出相片选择控制器
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
        
    }] animated:YES completion:^{
        
     
    }];
    
 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [UITableViewCell new];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.row < 6 ) {
        // 线
        UIView *View = [[UIView alloc] initWithFrame:CGRectMake(10, 43, kScreen_size.width-20, 0.3)];
        View.backgroundColor = [UIColor grayColor];
        View.alpha = 0.7;
        [cell addSubview:View];
    }
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 60, 30)];
    [cell addSubview:lblTitle];
    
    if (indexPath.row == 0)
    {
        lblTitle.text = @"昵称:";
        self.txt_name.text = self.mDic_data[@"name"];
        [cell addSubview:self.txt_name];

    }
    if (indexPath.row == 1)
    {
        lblTitle.text = @"性别:";
        self.txt_sex.text = self.mDic_data[@"sex"];
        [cell addSubview:self.txt_sex];
    }
    if (indexPath.row == 2)
    {
        lblTitle.text = @"生日:";
        self.txt_date.text = self.mDic_data[@"date"];
        [cell addSubview:self.txt_date];
    }
    if (indexPath.row == 3)
    {
        lblTitle.text = @"城市:";
        self.txt_address.text = self.mDic_data[@"address"];
        [cell addSubview:self.txt_address];

    }
    if (indexPath.row == 4)
    {
        lblTitle.text = @"签名:";
        self.txt_say.text = self.mDic_data[@"say"];
        self.txt_say.numberOfLines = 0;
        self.txt_say.userInteractionEnabled = NO;
        [cell addSubview:self.txt_say];

    }
    if (indexPath.row == 5)
    {
        NSString *str = [UserInfo shareUser].loginName;
        NSString *str_title = [NSString stringWithFormat:@"我的账号：%@",str];
        
        lblTitle.frame = CGRectMake(10, 5, self.view.bounds.size.width, 30);
        lblTitle.text = str_title;
    }
   
    return cell;
}




#pragma mark -

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
