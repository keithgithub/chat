//
//  SetBgTableViewController.m
//  xin_chat
//
//  Created by ibokan on 15/11/26.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import "SetBgTableViewController.h"
#import "MyAlertClass.h"
#import "UserInfo.h"
#import "MBProgressHUD+MJ.h"

@interface SetBgTableViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

// 照片管理器
@property (nonatomic,strong)  UIImagePickerController *imagePickerController;

@property (nonatomic,strong) NSMutableDictionary *dic;


@end

@implementation SetBgTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.btn.layer.cornerRadius = 5;
    self.btn.layer.masksToBounds = YES;
    
    // 获取好友本地信息
    self.dic = [NSMutableDictionary dictionaryWithDictionary:[UserInfo getFriendInforFromSanBoxAndKey:self.friendName.text]];
    
    [self creactImagePickerController];
    [self creacetNavigationItem];
    
    
}

// 创建导航栏按钮
- (void)creacetNavigationItem
{
    
    UIBarButtonItem *RightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];

    // 添加
    self.navigationItem.rightBarButtonItem = RightItem;
    
}
// 保存昵称
- (void)save
{
    if (self.dic.count != 0)
    {
        NSLog(@"保存2");

        if (![self.txtName.text isEqualToString:@""])
        {
            [self.dic removeObjectForKey:@"name"];
            [self.dic setObject:self.txtName.text forKey:@"name"];
            
            // 保存到沙盒
            [UserInfo SaveFriendInforToSanBox:self.dic andName:self.friendName.text];
            
            [MBProgressHUD showSuccess:@"保存成功"];
            [self.txtName resignFirstResponder];
        
        }
        else
        {
            [MBProgressHUD showError:@"请输入备注"];
        }
        
    }
    else
    {
        if (![self.txtName.text isEqualToString:@""])
        {
            [self.dic setObject:self.txtName.text forKey:@"name"];
            // 保存到沙盒
            [UserInfo SaveFriendInforToSanBox:self.dic andName:self.friendName.text];
           
            [MBProgressHUD showSuccess:@"保存成功"];
            [self.txtName resignFirstResponder];

        }
        else
        {
            [MBProgressHUD showError:@"请输入备注"];
        }
        
    }
}

// 保存昵称
- (void)saveBG:(NSString *)name
{
    if (self.dic.count != 0)
    {
            [self.dic setObject:name forKey:@"bg"];
            // 保存到沙盒
            [UserInfo SaveFriendInforToSanBox:self.dic andName:self.friendName.text];
    }
    else
    {
        if (self.dic[@"bg"] == nil)
        {
            [self.dic setObject:name forKey:@"bg"];
            // 保存到沙盒
            [UserInfo SaveFriendInforToSanBox:self.dic andName:self.friendName.text];
        }
        else
        {
            [self.dic removeObjectForKey:@"bg"];
            [self.dic setObject:name forKey:@"bg"];
            // 保存到沙盒
            [UserInfo SaveFriendInforToSanBox:self.dic andName:self.friendName.text];
        }
        
    }
}


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
    
    // 退出照片选择器
    [self.imagePickerController dismissViewControllerAnimated:YES completion:^{
        
        // 返回 设置背景
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate setBG:image];
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row < 4)
    {
        return 44;
    }
    else
    {
        return 120;
    }
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Setcell" forIndexPath:indexPath];
//    
//    return cell;
//}


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

- (IBAction)btnSetBg:(UIButton *)sender
{
    if (sender.tag == 1)
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
    switch (sender.tag)// 设置系统背景
    {
        case 11:[self.delegate setBG:[UIImage imageNamed:@"bg_1"]];
            [self saveBG:@"bg_1"];
            // 返回
            [self.navigationController popViewControllerAnimated:YES];break;
            
            case 12:[self.delegate setBG:[UIImage imageNamed:@"bg_2"]];
            [self saveBG:@"bg_2"];
            // 返回
            [self.navigationController popViewControllerAnimated:YES];
            break;
            case 13:[self.delegate setBG:[UIImage imageNamed:@"bg_3"]];
            [self saveBG:@"bg_3"];
            // 返回
            [self.navigationController popViewControllerAnimated:YES];
            break;
            case 14:[self.delegate setBG:[UIImage imageNamed:@"bg_4"]];
            [self saveBG:@"bg_4"];
            // 返回
            [self.navigationController popViewControllerAnimated:YES];
            break;
            case 15:[self.delegate setBG:[UIImage imageNamed:@"bg_5"]];
            [self saveBG:@"bg_5"];
            // 返回
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 16:[self.delegate setBG:[UIImage imageNamed:@"bg_6"]];
            [self saveBG:@"bg_6"];
            // 返回
            [self.navigationController popViewControllerAnimated:YES];
            break;
            case 17:[self.delegate setBG:[UIImage imageNamed:@"bg_7"]];
            [self saveBG:@"bg_7"];
            // 返回
            [self.navigationController popViewControllerAnimated:YES];
            break;
            case 18:[self.delegate setBG:[UIImage imageNamed:@"bg_8"]];
            [self saveBG:@"bg_8"];
            // 返回
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        default:
            break;
    }
    
}
@end
