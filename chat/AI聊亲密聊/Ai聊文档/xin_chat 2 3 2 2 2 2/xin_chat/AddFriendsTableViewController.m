//
//  AddFriendsTableViewController.m
//  xin_chat
//
//  Created by ibokan on 15/11/25.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import "AddFriendsTableViewController.h"
#import "XMPPHelp.h"
#import "XMPPHelp+Friend.h"
#import "MBProgressHUD+MJ.h"
#import "FriendesListViewController.h"
#import "FriendInfoViewController.h"
#import "XMPPFramework.h"

#define kScreen_size [UIScreen mainScreen].bounds.size

@interface AddFriendsTableViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *txt_name;

@end

@implementation AddFriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加好友";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    // 取消线
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    // topbar_back
    UIBarButtonItem *leftItem= [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"topbar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

- (void)pop
{
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[FriendesListViewController alloc] init]]
                                                 animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 设置代理
    [[XMPPHelp shareXmpp].vCard addDelegate:self delegateQueue:dispatch_get_main_queue()];
    // 修改导航栏的标题字体颜色大小
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName ,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:19],NSFontAttributeName,nil]];
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 设置代理
    [[XMPPHelp shareXmpp].vCard removeDelegate:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    // 取消选中状态
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 1)
    {
       
        self.txt_name = [[UITextField alloc] initWithFrame:CGRectMake(20, 5, self.view.bounds.size.width-40, 30)];
        self.txt_name.borderStyle = UITextBorderStyleRoundedRect;
        self.txt_name.placeholder = @"好友账号";
        self.txt_name.delegate = self;
        self.txt_name.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        
        self.txt_name.text = self.friendName;
        [cell addSubview:self.txt_name];
        
    }
    if (indexPath.row == 2)
    {
        // 添加好友按钮
        UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeSystem];
        btnAdd.frame = CGRectMake(60, 5, kScreen_size.width - 120, 30);
        btnAdd.layer.cornerRadius = 5;
        btnAdd.layer.masksToBounds = YES;
       
        [btnAdd setTitle:@"搜索" forState:UIControlStateNormal];
        [btnAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnAdd setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
        btnAdd.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        
        [btnAdd addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [cell addSubview:btnAdd];
    }
  
    
    return cell;
}

#pragma mark  添加好友按钮点击事件
- (void)btnAction:(UIButton *)sender
{
    if ([self.txt_name.text  isEqualToString:@""])
    {
        [MBProgressHUD showError:@"好友名称不能为空！"];
        return;
    }
    if (![XMPPHelp isTelphoneNum:self.txt_name.text])
    {
        [MBProgressHUD showError:@"请填写正确的手机号码"];
        return;
    }
    UserInfo *user=[UserInfo  shareUser];
    if ([self.txt_name.text  isEqualToString:user.loginName])
    {
        [MBProgressHUD showError:@"不能添加自己为好友！"];
        return;
    }
    
    XMPPHelp *xmppH=[XMPPHelp  shareXmpp];
    
    XMPPJID *friendJid=[XMPPJID  jidWithUser:self.txt_name.text domain:domain resource:nil];
    //判断好友是否已经存在
    if([xmppH.rosterStorage userExistsWithJID:friendJid xmppStream:xmppH.xmppStream]){
        
        [MBProgressHUD showError:@"好友已存在"];
        
        return ;
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        FriendInfoViewController *friendVC = [storyboard instantiateViewControllerWithIdentifier:@"friendVC"];
        friendVC.name = self.txt_name.text;
        
        NSString *str_jid = [NSString stringWithFormat:@"%@@112.74.105.205",self.txt_name.text];
        XMPPJID *jid = [XMPPJID jidWithString:str_jid];
        
      XMPPvCardTemp *vC =  [[XMPPHelp shareXmpp].vCard vCardTempForJID:jid shouldFetch:YES];
        
        if (vC)
        {
            
                friendVC.vCard = vC;
                [self.navigationController pushViewController:friendVC animated:YES];
//                       
        }
        else
        {
            // 显示蒙版
            [MBProgressHUD showMessage:@"查询中请稍后"];
        }
    }
   
}
-(void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule didReceivevCardTemp:(XMPPvCardTemp *)vCardTemp forJID:(XMPPJID *)jid
{
    if (self.txt_name.text)
    {
        // 隐藏蒙版
        [MBProgressHUD hideHUD];
        
        [self btnAction:nil];
    }
}


//获取联系人的名片，如果数据库有就返回，没有返回空，并到服务器上抓取
//- (XMPPvCardTemp *)vCardTempForJID:(XMPPJID *)jid shouldFetch:(BOOL)shouldFetch;

#pragma mark 文本框代理方法

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 回收键盘
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark -

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
