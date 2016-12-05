//
//  HomeViewController.m
//  xin_chat
//
//  Created by ibokan on 15/11/25.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import "HomeViewController.h"
#import "ChatViewController.h"
#import "XMPPHelp+Friend.h"
#import "FriendRequestTableViewCell.h"
#import "FriendMsgTableViewCell.h"
#import "XMPPHelp.h"
#import "XMPPHelp+Message.h"
#import "XMPPvCardTemp.h"
#import "MoreTableViewController.h"



#define kScreen_size [UIScreen mainScreen].bounds.size

@interface HomeViewController ()<XMPPRosterDelegate,UITableViewDataSource,UITableViewDelegate,ChatViewControllerDelegate>
// 表视图
@property (nonatomic,strong) UITableView *tableView;
// 好友消息数组
@property(nonatomic,strong)NSMutableArray *arrData;
// 好友请求数组
@property(nonatomic,strong)NSMutableArray *arrData_R;

@property (nonatomic, strong) UILabel *lbl_msgnil;



@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrData = [NSMutableArray  new];
    self.arrData_R = [NSMutableArray new];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"消息";
    
    
    
    self.lbl_msgnil = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 60, 50)];
    self.lbl_msgnil.text = @"无消息";
    self.lbl_msgnil.font = [UIFont systemFontOfSize:20];
    self.lbl_msgnil.textColor = [UIColor grayColor];
    self.lbl_msgnil.center = CGPointMake(kScreen_size.width/2, 200);
    self.lbl_msgnil.hidden = YES;
    [self.view addSubview:self.lbl_msgnil];
    
    
    
#pragma mark 获取最近聊天记录
    //注册通知，好友发来的消息
    [[NSNotificationCenter  defaultCenter]addObserver:self selector:@selector(changeMessageCount:) name:FRIENDMESSAGENOTIFICATION object:nil];
    
    //添加接收好友请求
    [[XMPPHelp  shareXmpp].rosterModule  addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // 创建导航栏按钮
    [self loadMsg];
    [self creacetNavigationItem];
    [self creacteTableView];
    [self updateUserRegistMark];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)updateUserRegistMark
{
    //获取当前的电子名片信息
    XMPPvCardTemp *myvCard = [XMPPHelp shareXmpp].vCard.myvCardTemp;
    
    myvCard.suffix = @"已注册";
    
    //更新 这个方法内部会实现数据上传到服务，无需程序自己操作
    [[XMPPHelp shareXmpp].vCard updateMyvCardTemp:myvCard];
    
    //获取当前的电子名片信息
    XMPPvCardTemp *my = [XMPPHelp shareXmpp].vCard.myvCardTemp;
    }

#pragma mark -
- (void)creacteTableView
{
    // 初始化
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreen_size.width, kScreen_size.height) style:UITableViewStylePlain];
   self.tableView.backgroundColor = [UIColor clearColor];
    UINib  *nib=[UINib  nibWithNibName:@"FriendRequestTableViewCell" bundle:nil];
    [self.tableView  registerNib:nib forCellReuseIdentifier:@"FriendReqCell"];
    
    UINib  *nib1=[UINib  nibWithNibName:@"FriendMsgTableViewCell" bundle:nil];
    [self.tableView  registerNib:nib1 forCellReuseIdentifier:@"msgCell"];
    
    // 线的颜色
    self.tableView.separatorColor = [UIColor whiteColor];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (void)loadMsg
{
    
    NSLog(@"----------------出现");
    self.arrData = [NSMutableArray  new];
    self.arrData_R = [NSMutableArray new];
    
    // 获取单例
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    // 用名称为key  去获取聊天记录
    NSString *msg_key = [UserInfo shareUser].loginName;
    NSMutableArray *arr_name = [def objectForKey:msg_key];
   
    for (int i = 0; i<arr_name.count; i++)
    {
        // 获取与这个好友的消息列表
        NSFetchedResultsController *fetched = [[XMPPHelp shareXmpp] xmppGetMessageLocalWithFriendName:arr_name[i]];
        // 开始工作
        NSError *err = nil;
        [fetched performFetch:&err];
        // 获取最后一条消息
        XMPPMessageArchiving_Message_CoreDataObject *msg = [fetched.fetchedObjects lastObject];
        // 创建字典  存入消息数组
        NSMutableDictionary *dic_data = [NSMutableDictionary new];
        
        NSString *str_msg = @"";
        
        NSString *msgType = [msg.message attributeStringValueForName:@"bodyType"];
        // 根据消息类型进行提示
        if ([msgType isEqualToString:@"text"])
        {
            str_msg = msg.message.body;
            
        } else if ([msgType isEqualToString:@"image"])
        {
            str_msg = @"[图片]";
        } else if ([msgType isEqualToString:@"audio"])
        {
           str_msg = @"[语音]";
        }
    
        NSString *jid = [NSString stringWithFormat:@"%@",arr_name[i]];
        
        [dic_data setObject:@"0" forKey:@"count"];
        [dic_data setObject:str_msg forKey:@"msg"];
        [dic_data setObject:jid forKey:@"jid"];
        
        
        [self.arrData addObject:dic_data];
    }

    
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 已用户名为key  保存聊天记录
    NSString *msg_key = [UserInfo shareUser].loginName;
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arr_name = [NSMutableArray new];
    
    
    for (int i = 0; i<self.arrData.count; i++)
    {
        NSString *jid = self.arrData[i][@"jid"];
        
        [arr_name addObject:jid];
    }
    if (arr_name.count > 0)
    {
        [def removeObjectForKey:msg_key];
        [def setObject:arr_name forKey:msg_key];
    }
    else
    {
       [def removeObjectForKey:msg_key];
    }
   
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"message" object:self];
    
}

//通知接到新消息（没做缓存，下次登录就没了，不过可以获取所有好友的聊天记录）
-(void)changeMessageCount:(NSNotification *)info
{
   dispatch_async(dispatch_get_main_queue(), ^{
        //拿出发来的消息对象
        NSDictionary *dic=[info  userInfo];
         //类型转换
        XMPPMessage  *infoObj=dic[@"message"];
        NSMutableDictionary *dic_data = [NSMutableDictionary new];
        
       // jid 转字符串
        NSString *str_jid = [NSString stringWithFormat:@"%@",infoObj.from];
       
        // 先判断消息类型
        NSString *str_msg = @"";
        NSString *msgType = [infoObj attributeStringValueForName:@"bodyType"];
        // 根据消息类型进行提示
        if ([msgType isEqualToString:@"text"])
        {
            str_msg = infoObj.body;
            
        } else if ([msgType isEqualToString:@"image"])
        {
            str_msg = @"[图片]";
        } else if ([msgType isEqualToString:@"audio"])
        {
            str_msg = @"[语音]";
        }
        
        BOOL  seachCount=NO;//查找原来是不是已经发来过消息的标识
        
        for (int  i=0;i<self.arrData.count;i++)
        {
           //判断是不是同一个人发来的
            if ([str_jid isEqualToString:self.arrData[i][@"jid"]])
            {
                    
                    NSString *count = [NSString stringWithFormat:@"%d",             [self.arrData[i][@"count"] intValue] +1];
                    [dic_data setObject:count forKey:@"count"];
                    [dic_data setObject:str_jid forKey:@"jid"];
                    [dic_data setObject:str_msg forKey:@"msg"];
                    //是的话，换掉原来的改为最后一条消息内容
                    [self.arrData  replaceObjectAtIndex:i withObject:dic_data];
                    seachCount =YES;//找到了
            }
        }
        if (self.arrData.count == 0||seachCount==NO)//没有找到直接添加，或是第一个
        {
           NSString *count = @"1";
            
        [dic_data setObject:count forKey:@"count"];
        [dic_data setObject:str_jid forKey:@"jid"];
        [dic_data setObject:str_msg forKey:@"msg"];
            
            [self.arrData insertObject:dic_data atIndex:0];
            NSLog(@"%@",self.arrData);
           // [self.arrData  addObject:dic_data];//添加一个消息对象
        }
        
        [self.tableView reloadData];//刷新表格
        
    });
}

//收到好友请求 代理函数
-(void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    XMPPJID * fromJid = presence.from;
    
    if (![self.arrData_R  containsObject:fromJid])
    {
        [self.arrData_R addObject:presence];
        
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.navigationController.tabBarController.selectedIndex!=0)
                {
                    int  count=[self.navigationController.tabBarItem.badgeValue  intValue];
                    count ++;//计数加1
                    self.navigationController.tabBarItem.badgeValue=[NSString  stringWithFormat:@"%d",count];//信息条数加1
                }
                [self.tableView  reloadData];
            });
            
       
    }
    
    
    
}


#pragma mark 表视图代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 判断是否有消息
    if (self.arrData_R.count == 0 && self.arrData.count == 0)
    {
        self.lbl_msgnil.hidden = NO;
    }
    else
    {
        self.lbl_msgnil.hidden = YES;
    }
    
    if (section == 0)
    {
       return self.arrData_R.count;
    }
    else
    {
       return self.arrData.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (indexPath.section == 1)// 请求
    {
        
        FriendMsgTableViewCell  *cell=[tableView  dequeueReusableCellWithIdentifier:@"msgCell" forIndexPath:indexPath];
       
        //线
        UIView *View = [[UIView alloc] initWithFrame:CGRectMake(65, cell.frame.size.height-1, kScreen_size.width, 0.3)];
        View.backgroundColor = [UIColor grayColor];
        View.alpha = 0.5;
        [cell addSubview:View];
        
        
        [cell setCellMsg:self.arrData[indexPath.row]];
        
        return cell;
       
        
    }
    if (indexPath.section == 0)
    {
        
        FriendRequestTableViewCell  *cell=[tableView  dequeueReusableCellWithIdentifier:@"FriendReqCell" forIndexPath:indexPath];
        id  data=self.arrData_R[indexPath.row];
        XMPPPresence *presence=(XMPPPresence *)data;
        
        
        //线
        UIView *View = [[UIView alloc] initWithFrame:CGRectMake(43, cell.frame.size.height-1, kScreen_size.width, 0.3)];
        View.backgroundColor = [UIColor grayColor];
        View.alpha = 0.5;
        [cell addSubview:View];
        
        
        
        [cell  setCell:presence.from.user];
       
        return cell;

    }
   
  
    UITableViewCell *cell = [UITableViewCell new];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dic = self.arrData[indexPath.row];
    [dic removeObjectForKey:@"count"];
    [dic setObject:@"0" forKey:@"count"];
  
    [self.arrData replaceObjectAtIndex:indexPath.row withObject:dic];
    [self.tableView reloadData];
    
    if (indexPath.section  == 1)
    {
        //获取选中的cell
        FriendMsgTableViewCell *cell=(FriendMsgTableViewCell *)[self.tableView  cellForRowAtIndexPath:indexPath];
        cell.lblMsgCount.hidden=YES;
        ChatViewController *chatView = [ChatViewController new];
        chatView.delegate = self;
        
        XMPPJID *jid = [XMPPJID jidWithString:self.arrData[indexPath.row][@"jid"]];
        
        chatView.fridendJid = jid;
       
        chatView.arrJid = [NSMutableArray new];
        chatView.arrJid = self.arrData[indexPath.row][@"jid"];
        
        [self.navigationController pushViewController:chatView animated:YES];
    }
    
    
    
}

#pragma mark chatViewDelegate

- (void)removeCount:(XMPPJID *)jid
{   //iPhone
    NSString *Fjid = [NSString stringWithFormat:@"%@@%@/iPhone",jid.user,jid.domain];
    
    
   
    for (NSMutableDictionary *dic in self.arrData)
    {
       
        if ([dic[@"jid"] isEqualToString:Fjid ])
        {
            [dic removeObjectForKey:@"count"];
            [dic setObject:@"0" forKey:@"count"];
        }
    }
    [self.tableView reloadData];
}


#pragma mark -

//实现这个方法，cell往左滑就会有个delete(一定要写，不然不能左滑）
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        XMPPPresence *presence=self.arrData_R[indexPath.row];
        UITableViewRowAction *acceptAction=[UITableViewRowAction  rowActionWithStyle:UITableViewRowActionStyleDefault title:@"接受" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                          
        {
                                //接受好友请求
        if ([presence.type isEqualToString:@"subscribe"])
            
        {//是订阅请求  直接通过
            
            [[XMPPHelp  shareXmpp].rosterModule acceptPresenceSubscriptionRequestFrom:presence.from andAddToRoster:YES];
            
        }
                                               
       [self.arrData_R  removeObjectAtIndex:indexPath.row];
            [tableView  reloadData];
                                                
        }];
        acceptAction.backgroundColor=[UIColor  redColor];
        UITableViewRowAction *ignoreAction=[UITableViewRowAction  rowActionWithStyle:UITableViewRowActionStyleDefault title:@"忽略" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                            {
                                                //接受好友请求
                                                if ([presence.type isEqualToString:@"subscribe"])
                                                {//是拒绝请求
                                                    [[XMPPHelp  shareXmpp].rosterModule rejectPresenceSubscriptionRequestFrom:presence.from];
                                                }
                                                [self.arrData_R  removeObjectAtIndex:indexPath.row];
                                                [tableView  reloadData];
                                            }];
        ignoreAction.backgroundColor=[UIColor  blueColor];
        return @[acceptAction,ignoreAction];
 
    }
    else
    {
        UITableViewRowAction *deleteAction=[UITableViewRowAction  rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                            {
                                                [self.arrData  removeObjectAtIndex:indexPath.row];
                                                [self.tableView reloadData];
                                            }];
        deleteAction.backgroundColor=[UIColor  blueColor];
        return @[deleteAction];
        
    }
    
}

// 创建导航栏按钮
- (void)creacetNavigationItem
{
    // 左侧按钮
    UIBarButtonItem *LeftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"topbar_menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    // 右侧按钮
    UIBarButtonItem *RightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"emo_layer_more"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(more)];
    
    
    // 添加
    self.navigationItem.leftBarButtonItem = LeftItem;
    self.navigationItem.rightBarButtonItem = RightItem;
   
}

#pragma mark 更多按钮
- (void)more
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MoreTableViewController *moerVC = [storyboard instantiateViewControllerWithIdentifier:@"homeMoreVC"];
    [self.navigationController pushViewController:moerVC animated:YES];
}

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
