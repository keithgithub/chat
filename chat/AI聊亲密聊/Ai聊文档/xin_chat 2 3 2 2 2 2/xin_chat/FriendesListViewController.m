//
//  FriendesListViewController.m
//  xin_chat
//
//  Created by ibokan on 15/11/25.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import "FriendesListViewController.h"
#import "FriendesListTableViewCell.h"
#import "ChatViewController.h"
#import "AddFriendsTableViewController.h"
#import "XMPPHelp+Friend.h"
#import "UserInfo.h"
#import "Ma_2ViewController.h"
#import "QRViewController.h"

#define kScreen_size [UIScreen mainScreen].bounds.size


@interface FriendesListViewController ()<NSFetchedResultsControllerDelegate,ChatViewControllerDelegate>
{
    NSFetchedResultsController *_resultsContrl;
}


// 右侧视图
@property (nonatomic,strong) UIView *rightView;
// 添加好友按钮
@property (nonatomic,strong) UIButton *btnAddFriend;
// 二维码按钮
@property (nonatomic, strong) UIButton *btnQR;



// 右侧按钮
@property (nonatomic,strong) UIBarButtonItem *rightItem1;
// 右侧按钮1
@property (nonatomic,strong) UIBarButtonItem *rightItem2;

@property(nonatomic,strong)NSMutableArray *arrFriends;//好友
// 在线好友
@property(nonatomic,strong) NSMutableArray *arrOnline;
// 离线好友
@property(nonatomic,strong) NSMutableArray *arrUnOnline;

@property (nonatomic, strong) UILabel *lbl_msgnil;


@end

@implementation FriendesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.arrFriends=[NSMutableArray  new];
    self.arrOnline=[NSMutableArray  new];
    self.arrUnOnline=[NSMutableArray  new];

    self.title = @"好友";
    
    self.lbl_msgnil = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 140, 50)];
    self.lbl_msgnil.text = @"右上角添加好友";
    self.lbl_msgnil.font = [UIFont systemFontOfSize:20];
    self.lbl_msgnil.textColor = [UIColor grayColor];
    self.lbl_msgnil.center = CGPointMake(kScreen_size.width/2, 200);
    self.lbl_msgnil.hidden = YES;
    [self.view addSubview:self.lbl_msgnil];
    
    
    [self creacteTableView];
    [self creacetNavigationItem];
    [self creacteRightView];
    [self  loadFriends2];
    
    //注册通知，好友发来的消息
    [[NSNotificationCenter  defaultCenter]addObserver:self selector:@selector(changeMessageCount:) name:FRIENDMESSAGENOTIFICATION object:nil];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

#pragma mark 好友消息通知
-(void)changeMessageCount:(NSNotification *)info
{
   __block NSMutableDictionary *dic_data = [NSMutableDictionary new];
    dispatch_async(dispatch_get_main_queue(), ^{
        //拿出发来的消息对象
        NSDictionary *dic=[info  userInfo];
        //类型转换
        XMPPMessage  *infoObj=dic[@"message"];
        
        
        
        for ( int i = 0;i<self.arrOnline.count;i++)
        {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.arrOnline[i]];
            XMPPUserCoreDataStorageObject *obj = dic[@"obj"];
            NSString *str_jid_f = [NSString stringWithFormat:@"%@/iPhone",obj.jidStr];
            dic_data = dic;
            [dic_data removeObjectForKey:@"count"];
            
            if ([str_jid_f isEqualToString:infoObj.fromStr])
            {
                 //NSLog(@"找到---------%@",self.arrOnline[i][@"count"]);
                
                int count = [self.arrOnline[i][@"count"] intValue]+1;
                NSString *str_count = [NSString stringWithFormat:@"%d",count];
                 //NSLog(@"找到---------%@",str_count);
                [dic_data setObject:str_count forKey:@"count"];
               
                [self.arrOnline replaceObjectAtIndex:i withObject:dic_data];
                //NSLog(@"写入---------%@",self.arrOnline[i][@"count"]);
                break;
            }
        }

        [self.tableView reloadData];
    });
    
}

#pragma mark -

-(void)getFriendList
{
    XMPPHelp *xmppH=[XMPPHelp  shareXmpp];
    
    _resultsContrl= [xmppH  getFriends];
    
    xmppH.fetFriend.delegate=self;
    
}

-(void)loadFriends2{
    //使用CoreData获取数据
    // 1.上下文【关联到数据库XMPPRoster.sqlite】
    XMPPHelp  *xmppH=[XMPPHelp shareXmpp];
    
    NSManagedObjectContext *context = xmppH.rosterStorage.mainThreadManagedObjectContext;
    
    
    // 2.FetchRequest【查哪张表】
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    // 3.设置过滤和排序
    UserInfo *user=[UserInfo  shareUser];
    // 过滤当前登录用户的好友
    NSString *jid = [NSString  stringWithFormat:@"%@@%@",user.loginName,domain];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@",jid];
    request.predicate = pre;
    
    //排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    
    // 4.执行请求获取数据
    _resultsContrl = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    _resultsContrl.delegate = self;
 
    NSError *err = nil;
    [_resultsContrl performFetch:&err];
    if (err) {
    }
    
    [self dealData];
}

#pragma mark 当数据的内容发生改变后，会调用 这个方法
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    // 过滤好友  （有下线的好友  放入离线数组）
    [self dealData];
    //刷新表格
    [self.tableView reloadData];
    
}

/**
 *  好友信息过滤，只显示互为好友
 */
-(void)dealData
{
    // 取出原来的数组
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.arrOnline];

    if (self.arrFriends != nil)
    {
        [self.arrFriends  removeAllObjects];
        [self.arrOnline removeAllObjects];
        [self.arrUnOnline removeAllObjects];
    }
    
    for (XMPPUserCoreDataStorageObject *obj in _resultsContrl.fetchedObjects)
    {
        if ([obj.subscription  isEqualToString:@"both"])
        {
            [self.arrFriends  addObject:obj];
        }
    }
    for (XMPPUserCoreDataStorageObject *obj in self.arrFriends)
    {
        if ([obj.sectionNum intValue] == 0)
        {
            NSMutableDictionary *dic = [NSMutableDictionary new];
            [dic setObject:obj forKey:@"obj"];
            [dic setObject:@"0" forKey:@"count"];
            [self.arrOnline  addObject:dic];
        }
        if ([obj.sectionNum intValue] == 2)
        {
            [self.arrUnOnline addObject:obj];
        }
    }
    
    // 循环比对  拿出原来的消息个数  加到新的数组
    for (int i = 0; i<arr.count; i++)
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:arr[i]];
        XMPPUserCoreDataStorageObject *obj = dic[@"obj"];
        
        NSString *count = dic[@"count"];
        NSString *jid = obj.jidStr;
        
        for (int j = 0;j <self.arrOnline.count;j++ )
        {
            NSMutableDictionary *dic_new = [NSMutableDictionary dictionaryWithDictionary:self.arrOnline[j]];
            XMPPUserCoreDataStorageObject *obj_new = dic_new[@"obj"];
        
            NSString *jid_new = obj_new.jidStr;
            if ([jid isEqualToString:jid_new])
            {
                [self.arrOnline[j] removeObjectForKey:@"count"];
                [self.arrOnline[j] setObject:count forKey:@"count"];
            }
        }
        
        
    }
}

// 创建导航栏按钮
- (void)creacetNavigationItem
{
    // 左侧按钮
    UIBarButtonItem *LeftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"topbar_menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    // 右侧按钮
    self.rightItem1 = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"topbar_more"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(RightMenu:)];
    // 右侧按钮
    self.rightItem2 = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"topbar_more_x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(RightMenu:)];
    
    // 添加
    self.navigationItem.leftBarButtonItem = LeftItem;
    self.navigationItem.rightBarButtonItem = self.rightItem1;
    
}

#pragma mark 单击手势
- (void)tapAction:(UITapGestureRecognizer *)sender
{
    // 动画隐藏视图
    [UIView animateWithDuration:0.3 animations:^{
        
        self.btnAddFriend.frame = CGRectMake(kScreen_size.width/2-10, 150, 20,20);
        self.btnQR.frame = CGRectMake(kScreen_size.width/2-10, 210, 20,20);

    } completion:^(BOOL finished) {
        
        self.rightView.hidden = YES;
        self.navigationItem.rightBarButtonItem = self.rightItem1;
        
    }];
    
}

// 跳转二维码页面
- (void)goToQRVC
{
    QRViewController *vc = [QRViewController new];
   
    [self.navigationController pushViewController:vc animated:YES];
   
}

// 按钮点击 添加好友
- (void)btnActionAddFriends:(UIButton *)sender
{
    
    [self.sideMenuViewController hideMenuViewController];
    
    // 设置右侧按钮 隐藏右侧视图
    self.navigationItem.rightBarButtonItem = self.rightItem1;
    self.rightView.hidden = YES;
    
    // 推出添加好友页
    AddFriendsTableViewController *addVC = [AddFriendsTableViewController new];
    [self.navigationController pushViewController:addVC animated:YES];
    
}


// 初始化tableView
- (void)creacteTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreen_size.width, kScreen_size.height-64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 注册nib
    UINib *nib = [UINib nibWithNibName:@"FriendesListTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"friendCell"];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // 添加
    [self.view addSubview:self.tableView];
}

// 创建添加好友View
- (void)creacteRightView
{
    // 视图
    self.rightView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.rightView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.870];
    self.rightView.hidden = YES;
    
    // 按钮
    self.btnAddFriend = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnAddFriend.frame = CGRectMake(kScreen_size.width/2-10, 100, 20,20);
    [self.btnAddFriend setImage:[UIImage imageNamed:@"more_icon_friends"] forState:UIControlStateNormal];
    [self.btnAddFriend setBackgroundImage:[UIImage imageNamed:@"more_green"] forState:UIControlStateNormal];
    [self.btnAddFriend addTarget:self action:@selector(btnActionAddFriends:) forControlEvents:UIControlEventTouchUpInside];
    
   
    UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAdd setTitle:@"添加好友" forState:UIControlStateNormal];
    btnAdd.frame = CGRectMake(kScreen_size.width/2-40, 190, 80, 30);
    [btnAdd setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnAdd  addTarget:self action:@selector(btnActionAddFriends:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightView addSubview:btnAdd];
    
    //more_green
    // 按钮
    self.btnQR = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnQR.frame = CGRectMake(kScreen_size.width/2-10, 210, 20,20);
    [self.btnQR setImage:[UIImage imageNamed:@"more_icon_scan-2"] forState:UIControlStateNormal];
    [self.btnQR setBackgroundImage:[UIImage imageNamed:@"more_blue"] forState:UIControlStateNormal];
    [self.btnQR addTarget:self action:@selector(goToQRVC) forControlEvents:UIControlEventTouchUpInside];
    [self.rightView addSubview:self.btnQR];
    
    UIButton *btnMa = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnMa setTitle:@"扫一扫" forState:UIControlStateNormal];
    btnMa.frame = CGRectMake(kScreen_size.width/2-40, 340, 80, 30);
    [btnMa setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnMa  addTarget:self action:@selector(goToQRVC) forControlEvents:UIControlEventTouchUpInside];
    [self.rightView addSubview:btnMa];
    
    

    // 创建单击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    // 添加到视图
    [self.rightView addGestureRecognizer:tap];
    
    
    // 添加
    [self.rightView addSubview:self.btnAddFriend];
    [self.view addSubview:self.rightView];
}

#pragma mark 右侧按钮点击事件
- (void)RightMenu:(UIBarButtonItem*)sender
{
    
    if (self.rightView.hidden)
    {
        self.navigationItem.rightBarButtonItem = self.rightItem2;
        // 显示
        self.rightView.hidden = NO;
        // 执行动画放大
        [UIView animateWithDuration:0.3 animations:^{
            
            self.btnAddFriend.frame = CGRectMake(kScreen_size.width/2-50, 100, 110,110);
            self.btnQR.frame = CGRectMake(kScreen_size.width/2-50, 250, 110,110);
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.1 animations:^{
                self.btnAddFriend.frame = CGRectMake(kScreen_size.width/2-40, 100, 80,80);
                self.btnQR.frame = CGRectMake(kScreen_size.width/2-40, 250, 80,80);
            }];
            
        }];
    }
    else
    {
        // 动画隐藏视图
        [UIView animateWithDuration:0.3 animations:^{
            
            self.btnAddFriend.frame = CGRectMake(kScreen_size.width/2-10, 150, 20,20);
            self.btnQR.frame = CGRectMake(kScreen_size.width/2-10, 250, 20,20);
            
        } completion:^(BOOL finished) {
            
            self.rightView.hidden = YES;
            self.navigationItem.rightBarButtonItem = self.rightItem1;
            
        }];
        
    }
    
}
#pragma mark chatViewDelegate

- (void)removeCount:(XMPPJID *)jid
{   //iPhone
    NSString *Fjid = [NSString stringWithFormat:@"%@@%@",jid.user,jid.domain];
    
    
   // NSLog(@"***********------------%@",Fjid);
    
    for (int j = 0;j <self.arrOnline.count;j++ )
    {
        NSMutableDictionary *dic_new = [NSMutableDictionary dictionaryWithDictionary:self.arrOnline[j]];
        XMPPUserCoreDataStorageObject *obj_new = dic_new[@"obj"];
        // NSLog(@"***********------------%@",obj_new.jidStr);
        NSString *jid_new = obj_new.jidStr;
        if ([Fjid isEqualToString:jid_new])
        {
            
            [self.arrOnline[j] removeObjectForKey:@"count"];
            [self.arrOnline[j] setObject:@"0" forKey:@"count"];
        }
    }
    [self.tableView reloadData];
}

#pragma mark 表格代理

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatViewController *chatVC = [ChatViewController new];
    chatVC.delegate = self;
    
    if (indexPath.section == 0)
    {
         XMPPUserCoreDataStorageObject *obj=self.arrOnline[indexPath.row][@"obj"];
        chatVC.strJid = [NSString stringWithFormat:@"%@/iPhone",obj.jid];
        
        chatVC.arrJid = [NSMutableArray new];
        [chatVC.arrJid addObject:[NSString stringWithFormat:@"%@/iPhone",obj.jid]];
        chatVC.fridendJid = obj.jid;
        
        
        // 清楚角标
        [self.arrOnline[indexPath.row] removeObjectForKey:@"count"];
        [self.arrOnline[indexPath.row] setObject:@"0" forKey:@"count"];
        [self.tableView reloadData];
        
    }
    else
    {
        XMPPUserCoreDataStorageObject *obj=self.arrUnOnline
        [indexPath.row];
        
        chatVC.strJid = [NSString stringWithFormat:@"%@/iPhone",obj.jid];
        
        chatVC.fridendJid = obj.jid;
    }
    
    [self.navigationController  pushViewController:chatVC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendesListTableViewCell  *cell=[tableView  dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
    // 取消选择样式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //线
    UIView *View = [[UIView alloc] initWithFrame:CGRectMake(62, cell.frame.size.height-1, kScreen_size.width, 0.3)];
    View.backgroundColor = [UIColor grayColor];
    View.alpha = 0.5;
    [cell addSubview:View];
    
    // 设置cell
    if (indexPath.section == 0)// 在线
    {
      XMPPUserCoreDataStorageObject  *obj=self.arrOnline[indexPath.row][@"obj"];
        [cell setCell:obj andFriendvCad: [XMPPHelp  searchFriendDetailInfo:obj.jid]andCountDic:self.arrOnline[indexPath.row]];
        
       
        
    }
    else// 离线
    {
       XMPPUserCoreDataStorageObject  *obj=self.arrUnOnline[indexPath.row];
        
        cell.isOnLine = YES;
        
         [cell setCell:obj andFriendvCad: [XMPPHelp  searchFriendDetailInfo:obj.jid]andCountDic:nil];
        
        }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    if (self.arrOnline.count == 0 && self.arrUnOnline.count == 0)
    {
        self.lbl_msgnil.hidden = NO;
    }
    else
    {
        self.lbl_msgnil.hidden = YES;
    }
    
    if (section == 0)
    {
        return self.arrOnline.count;
    }
    else
    {
        return self.arrUnOnline.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

//实现这个方法，cell往左滑就会有个delete(一定要写，不然不能左滑）
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    UITableViewRowAction *deleteAction=[UITableViewRowAction  rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
    {
        if (indexPath.section == 0)
        {
            XMPPUserCoreDataStorageObject  *obj=self.arrOnline[indexPath.row][@"obj"];
            //删除好友
            [[XMPPHelp  shareXmpp].rosterModule  removeUser:obj.jid];
        }
        else
        {
             XMPPUserCoreDataStorageObject  *obj=self.arrUnOnline[indexPath.row];
            //删除好友
            [[XMPPHelp  shareXmpp].rosterModule  removeUser:obj.jid];
        }
            //删除好友
    //[[XMPPHelp  shareXmpp].rosterModule  removeUser:obj.jid];
        
    }];
    deleteAction.backgroundColor=[UIColor  blueColor];
    return @[deleteAction];
}


#pragma mark -
- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:@"message" name:nil object:self];
    
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
