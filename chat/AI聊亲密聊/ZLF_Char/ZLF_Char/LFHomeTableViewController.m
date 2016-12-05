//
//  LFHomeTableViewController.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/25.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFHomeTableViewController.h"
#import "LFChatTableViewCell.h"
#import "LFChatViewController.h"
#import "LFConstant.h"
#import "LFXMPPHelp+Message.h"
#import "LFUserInfo.h"
#import "LFNewFriendTableViewCell.h"
#import "NSDate+LFExtension.h"
#import "XMPPvCardTemp.h"
#import "MBProgressHUD+MJ.h"

@interface LFHomeTableViewController () <XMPPRosterDelegate>
@property (nonatomic, strong) NSMutableArray *mArray; // 最近给我发过消息的好友JidStr数组
@end

@implementation LFHomeTableViewController
// 数组懒加载初始化
- (NSMutableArray *)mArray {
    if (_mArray == nil) {
        // 初始化
        _mArray = [NSMutableArray new];
        
        // 从沙盒读取数据
        [_mArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:kMyLoginName]];
    }
    
    return _mArray;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        // 设置未被选中图片
        self.navigationController.tabBarItem.image = [[UIImage imageNamed:@"talk01"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        // 设置被选中图片
        self.navigationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"talk02"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 0.5秒以后刷新表格
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    
    
//    // 获取该账号上次离线时间
//    NSString *exitTime = [[LFUserInfo shareUserInfo] getExitTime];
//   
//    if (![exitTime isEqualToString:@""]) {
//        int time = (int)([[NSDate getNowTime] doubleValue] / 1000000) - (int)([exitTime doubleValue] / 1000000);
//        if (time >= 1) { // 如果登陆间隔大于1天
//            // 从服务器获取个人信息
//        XMPPvCardTemp *myvCardTemp = [LFXMPPHelp shareXMPPHelp].xmppvCardTempModule.myvCardTemp;
//            if (myvCardTemp.givenName) {
//                // 获取原本的钻石数量
//                int roleCount = [myvCardTemp.givenName intValue];
//                // 更新钻石数量
//                myvCardTemp.givenName = [NSString stringWithFormat:@"%d", roleCount + 10];
//                myvCardTemp.givenName = @"1580";
//            } else {
//                // 更新钻石数量
//                myvCardTemp.givenName = @"10";
//            }
//            // 通知服务器更新
//            [[LFXMPPHelp shareXMPPHelp].xmppvCardTempModule updateMyvCardTemp:myvCardTemp];
//            
//
//            // 提示
//            [MBProgressHUD showSuccess:@"今天首次登陆,赠送10个钻石~"];
//        }
//    }
    
//    [[LFXMPPHelp shareXMPPHelp] xmppGetFriends]
    
    // 设置导航栏左侧按钮
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"忽略" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    self.navigationItem.leftBarButtonItem = leftItem;

//    // 设置导航栏右侧按钮
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"透明双人"] style:UIBarButtonItemStylePlain target:self action:@selector(findFriends)];
//    rightItem.imageInsets = UIEdgeInsetsMake(25, 26, 25, 26);
// 
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    // 设置表格背景颜色
    self.tableView.backgroundColor = [UIColor clearColor];
    // 创建nib
    UINib *nib = [UINib nibWithNibName:@"LFChatTableViewCell" bundle:nil];
    // 注册nib
    [self.tableView registerNib:nib forCellReuseIdentifier:@"LFChatTableViewCell"];
    
    nib = [UINib nibWithNibName:@"LFNewFriendTableViewCell" bundle:nil];
    // 注册nib
    [self.tableView registerNib:nib forCellReuseIdentifier:@"LFNewFriendTableViewCell"];
    
    // 监听消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receptionMessage:) name:FRIENDMESSAGENOTIFICATION object:nil];
    
    // 创建定时器
    // 使用表格在拖拽表格时会出现定时器停止工作的情况，因此创建自定义定时器加入运行循环
    NSTimer *timer = [NSTimer timerWithTimeInterval:60 target:self selector:@selector(changeView) userInfo:nil repeats:YES];
    // 加入运行循环
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    
    // 设置代理(好友申请)
    [[LFXMPPHelp shareXMPPHelp].xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 获取沙盒
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    // 清除原先的内容
    [self.mArray removeAllObjects];
    // 添加新的数据
    [self.mArray addObjectsFromArray:[def objectForKey:kMyLoginName]];
    // 刷新表格
    [self.tableView reloadData];
    
    // 角标清空
    self.navigationController.tabBarItem.badgeValue = nil;
}

/**
 *  定时器相应
 */
- (void)changeView {
    [self.tableView reloadData];
}

/**
 *  左侧Item点击事件
 */
- (void)leftItemClick {
    // 删除所有角标
    [LFUserInfo removeAllFriendBadge];
    // 刷新表格
    [self.tableView reloadData];
}

/**
 *  删除沙盒内字段并刷新数据
 */
- (void)removeDefName:(NSString *)name {
    // 获取沙盒
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    // 如果值存在
    if ([def objectForKey:kMyLoginName]) {
        // 获取内容
        NSMutableArray *mArray = [[def objectForKey:kMyLoginName] mutableCopy];
        [mArray removeObject:name];
        // 存入沙盒
        [def setObject:mArray forKey:kMyLoginName];
        // 清除原先的内容
        [self.mArray removeAllObjects];
        // 添加新的数据
        [self.mArray addObjectsFromArray:[def objectForKey:kMyLoginName]];
        // 表格
        [self.tableView reloadData];
    }
}

#pragma mark - xmpp代理方法

/*
 message = <message xmlns="jabber:client" id="aFT1p-29" to="15160002593@112.74.105.205/iPhone" from="13159260427@112.74.105.205/Spark 2.6.3" type="chat"><body>321</body><thread>m0zC63</thread><x xmlns="jabber:x:event"><offline/><composing/></x></message>;
 */
- (void)receptionMessage:(NSNotification *)noti {
    // 回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        // 取出消息
        XMPPMessage *infoObj = noti.userInfo[@"message"];
        NSString *name = [[LFXMPPHelp shareXMPPHelp] xmppGetJibWithName:infoObj.fromStr].user;
        
        // 更新好友名
        [LFUserInfo nearestFriend:name];
        
        // 获取沙盒
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        // 清除原先的内容
        [self.mArray removeAllObjects];
        // 添加新的数据
        [self.mArray addObjectsFromArray:[def objectForKey:kMyLoginName]];
        // 同步数据
        [def synchronize];
        
        // 增加亲密度
        [LFUserInfo friendIntimacy:name];
        // 增加对应角标
        [LFUserInfo addFriendBadge:name];
        // 刷新表格
        [self.tableView reloadData];
        // 增加角标
        [self addBadgeValue];
    });
}

/**
 *  收到好友申请时调用
 */
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence {
//    NSString *presenceType = [presence type];
    XMPPJID *fromJid = presence.from;
    // 存入沙盒
    [LFUserInfo nearestFriend:fromJid.user];
    
    // 获取沙盒
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    // 清除原先的内容
    [self.mArray removeAllObjects];
    // 添加新的数据
    [self.mArray addObjectsFromArray:[def objectForKey:kMyLoginName]];
    // 同步数据
    [def synchronize];
    
    // 增加对应角标
    [LFUserInfo addFriendBadge:fromJid.user];
    
    // 回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        // 表格刷新
        [self.tableView reloadData];
        // 增加角标
        [self addBadgeValue];
    });
}

/**
 *  增加角标
 */
- (void)addBadgeValue {
    // 当前不在消息页
    if (self.navigationController.tabBarController.selectedIndex != 0) {
        // 取出角标
        int num = [[[self.navigationController.tabBarController.viewControllers[0] tabBarItem] badgeValue] intValue];
        if (num < 99) {
            // 更改角标
            [[self.navigationController.tabBarController.viewControllers[0] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%d", ++num]];
        } else {
            // 更改角标
            [[self.navigationController.tabBarController.viewControllers[0] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"99+"]];
        }
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.mArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建好友基本信息
    XMPPUserCoreDataStorageObject *myUser = nil;
    // XMPPUserCoreDataStorageObject
    BOOL isOther = YES;
    // 获取好友姓名
    NSString *name = self.mArray[indexPath.row];
    NSArray *arr = [[LFXMPPHelp shareXMPPHelp] xmppGetFriends];
    // 判断是不是原本就是好友
    for (XMPPUserCoreDataStorageObject *obj in arr) {
        name = [[LFXMPPHelp shareXMPPHelp] xmppGetJibWithName:name].user;
        NSString *otherName = [[LFXMPPHelp shareXMPPHelp] xmppGetJibWithName:obj.jidStr].user;
        if ([name isEqualToString:otherName]) {
            isOther = NO;
            myUser = obj;
            
            break;
        }
    }
    
    if (isOther) { // 是好友申请
        if (self.mArray.count > 0) {
            LFNewFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFNewFriendTableViewCell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor clearColor];
            // 设置单元格内容
            [cell setCell:self.mArray[indexPath.row]];
            
            return cell;
        }
    } else { // 是原本的好友 是消息
        // 创建对象
        LFChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFChatTableViewCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        if (self.mArray.count > 0) {
            // 获取好友姓名
            NSString *name = self.mArray[indexPath.row];
            // 查询对应的好友详细信息
            XMPPvCardTemp *temp = [[LFXMPPHelp shareXMPPHelp] xmppGetFriendInfoWithUsername:name];
            // 传递基本信息
            cell.myUser = myUser;
            // 设置单元格内容
            [cell setCell:temp andName:name];
        }
        return cell;
    }

    LFChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFChatTableViewCell" forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // XMPPUserCoreDataStorageObject
    BOOL isOther = YES;
    // 获取好友姓名
    NSString *name = self.mArray[indexPath.row];
    NSArray *arr = [[LFXMPPHelp shareXMPPHelp] xmppGetFriends];
    // 判断是不是原本就是好友
    for (XMPPUserCoreDataStorageObject *obj in arr) {
        name = [[LFXMPPHelp shareXMPPHelp] xmppGetJibWithName:name].user;
        NSString *otherName = [[LFXMPPHelp shareXMPPHelp] xmppGetJibWithName:obj.jidStr].user;
        if ([name isEqualToString:otherName]) {
            isOther = NO;
            break;
        }
    }
    
    if (isOther) { // 是好友申请
        // 先放空
    } else { // 是原本的好友 是消息
        // 创建聊天控制器
        LFChatViewController *chatVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LFChatViewController"];
        
        // 获取所有好友列表
        NSArray *arr = [[LFXMPPHelp shareXMPPHelp] xmppGetFriends];
        // 查找对应的XMPPUserCoreDataStorageObject
        XMPPUserCoreDataStorageObject *cellObj = nil;
        for (XMPPUserCoreDataStorageObject *obj in arr) {
            if ([[[LFXMPPHelp shareXMPPHelp] xmppGetJibWithName:obj.jidStr].user isEqualToString:[[LFXMPPHelp shareXMPPHelp] xmppGetJibWithName:self.mArray[indexPath.row]].user]) {
                cellObj = obj;
                
                break;
            }
        }
        // 视图赋值
        [chatVc setFriendInfo:cellObj];
        
        // 跳转
        [self.navigationController pushViewController:chatVc animated:YES];
        
        // 清空角标
        [LFUserInfo removeFriendBadge:self.mArray[indexPath.row]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

/**
 *  产生左滑事件 默认是删除
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // XMPPUserCoreDataStorageObject
    BOOL isOther = YES;
    // 获取好友姓名
    NSString *name = self.mArray[indexPath.row];
    NSArray *arr = [[LFXMPPHelp shareXMPPHelp] xmppGetFriends];
    // 判断是不是原本就是好友
    for (XMPPUserCoreDataStorageObject *obj in arr) {
        name = [[LFXMPPHelp shareXMPPHelp] xmppGetJibWithName:name].user;
        NSString *otherName = [[LFXMPPHelp shareXMPPHelp] xmppGetJibWithName:obj.jidStr].user;
        if ([name isEqualToString:otherName]) {
            isOther = NO;
            break;
        }
    }
    
    if (isOther) { // 是好友申请
        UITableViewRowAction *acceptAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"接受" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            // 允许添加好友
            [[LFXMPPHelp shareXMPPHelp].xmppRoster acceptPresenceSubscriptionRequestFrom:[[LFXMPPHelp shareXMPPHelp] xmppGetJibWithName:self.mArray[indexPath.row]] andAddToRoster:YES];
            // 删除界面数据
            [self removeDefName:self.mArray[indexPath.row]];
        }];
        // 设置透明背景
        acceptAction.backgroundColor = [UIColor clearColor];
        UITableViewRowAction *ignoreAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"忽略" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            // 忽略请求
            [[LFXMPPHelp shareXMPPHelp].xmppRoster rejectPresenceSubscriptionRequestFrom:[[LFXMPPHelp shareXMPPHelp] xmppGetJibWithName:self.mArray[indexPath.row]]];
            // 删除界面数据
            [self removeDefName:self.mArray[indexPath.row]];
        }];
        // 设置透明背景
        ignoreAction.backgroundColor = [UIColor clearColor];
        
        return @[ignoreAction, acceptAction];
    } else { // 是原本的好友 是消息
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            // 删除对应数据
            [self removeDefName:self.mArray[indexPath.row]];
        }];
        // 设置透明背景
        deleteAction.backgroundColor = [UIColor clearColor];
        
        return @[deleteAction];
    }
}


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 80;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    // 创建视图
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 30)];
////    CGFloat padding = 5;
////    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(padding, padding, kScreenW - 2 * padding, kScreenH - 2 *padding)];
//    view.backgroundColor = [UIColor clearColor];
//    
////    [view addSubview:searchBar];
//    
//    return view;
//}

@end
