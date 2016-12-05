//
//  LFAddressBookTableViewController.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/25.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFAddressBookTableViewController.h"
#import "LFAddressBookTableViewCell.h"
#import "LFChatViewController.h"
#import "LFConstant.h"
#import "LFSeeInfoViewController.h"
#import "LFAddFriendViewController.h"
#import "XMPPFramework.h"
#import "LFXMPPHelp.h"
#import "XMPPvCardTemp.h"

@interface LFAddressBookTableViewController () <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSMutableArray *allFriends; // 存放所有好友
@property (nonatomic, strong) NSMutableArray *onLineFriends; // 存放在线好友
@property (nonatomic, strong) NSMutableArray *exitFriends; // 存放离线好友
@property (nonatomic, strong) NSMutableArray *goodFriends; // 存放最好的好友
@end

@implementation LFAddressBookTableViewController

#pragma mark - 懒加载
/**
 *  所有好友数组
 */
- (NSMutableArray *)allFriends {
    if (_allFriends == nil) {
        _allFriends = [NSMutableArray new];
        [_allFriends removeAllObjects];
        // 遍历
        for (XMPPUserCoreDataStorageObject *obj in [[LFXMPPHelp shareXMPPHelp] xmppGetFriends]) {
            // 如果互为好友
            if ([obj.subscription isEqualToString:@"both"]) {
                [_allFriends addObject:obj];
            }
        }
        
//        [_allFriends addObjectsFromArray:[[LFXMPPHelp shareXMPPHelp] xmppGetFriends]];
    }
    
    return _allFriends;
}

#pragma mark - 初始化方法
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        // 设置未被选中图片
        self.navigationController.tabBarItem.image = [[UIImage imageNamed:@"icon_menu_friends_01"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        // 设置被选中图片
        self.navigationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_menu_friends_02"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化数组
    self.onLineFriends = [NSMutableArray new];
    self.exitFriends = [NSMutableArray new];
    self.goodFriends = [NSMutableArray new];
    
    // 好友分组
//    [self changeFriendArray];
    
    // 创建右侧item
    [self createRightItem];
    
    // 设置表格背景颜色
    self.tableView.backgroundColor = [UIColor clearColor];
    // 创建nib
    UINib *nib = [UINib nibWithNibName:@"LFAddressBookTableViewCell" bundle:nil];
    // 注册nib
    [self.tableView registerNib:nib forCellReuseIdentifier:@"LFAddressBookTableViewCell"];
    
    [LFXMPPHelp shareXMPPHelp].fetchedResultsController.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 重新分类好友
    [self changeFriendArray];
    // 刷新表格
    [self.tableView reloadData];
}

#pragma end mark

/**
 *  好友分组
 */
- (void)changeFriendArray {
//    [_allFriends removeAllObjects];
//    [_allFriends addObjectsFromArray:[[LFXMPPHelp shareXMPPHelp] xmppGetFriends]];
    
    [self.allFriends removeAllObjects];
    // 遍历
    for (XMPPUserCoreDataStorageObject *obj in [[LFXMPPHelp shareXMPPHelp] xmppGetFriends]) {
        // 如果互为好友
        if ([obj.subscription isEqualToString:@"both"]) {
            [self.allFriends addObject:obj];
        }
    }
    
    // 清空数据
    [self.onLineFriends removeAllObjects];
    [self.exitFriends removeAllObjects];
    [self.goodFriends removeAllObjects];
    
    // 遍历分类
    for (XMPPUserCoreDataStorageObject *user in self.allFriends) {
        if (user.section == 0) {
            [self.onLineFriends addObject:user];
        } else if (user.section == 2) {
            [self.exitFriends addObject:user];
        }
        // 如果亲密度为100
        if ([[LFUserInfo getFriendIntimacy:user.jidStr] isEqualToString:@"100"]) {
            [self.goodFriends addObject:user];
        }
    }
}

#pragma mark - 导航栏右侧按钮
- (void)createRightItem {
    // 创建对象
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"透明添加好友"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    // 设置内边距
    right.imageInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    // 设置
    self.navigationItem.rightBarButtonItem = right;
}

- (void)rightItemClick {
    // 从故事板中获取对象
    LFAddFriendViewController *addFriendVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LFAddFriendViewController"];
    // 跳转
    [self.navigationController pushViewController:addFriendVc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.goodFriends.count;
    }
    
    if (section == 1) {
        return self.onLineFriends.count;
    }
    
    if (section == 2) {
        return self.exitFriends.count;
    }
    
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建对象
    LFAddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFAddressBookTableViewCell" forIndexPath:indexPath];
    // 单元格背景透明
    cell.backgroundColor = [UIColor clearColor];
    // 设置cell选中样式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        // 获取对应的好友基本信息
        XMPPUserCoreDataStorageObject *user = self.goodFriends[indexPath.row];
        // 根据用户账号查询详细信息
        XMPPvCardTemp *temp = [[LFXMPPHelp shareXMPPHelp] xmppGetFriendInfoWithUsername:user.jidStr];
        // 传递基础好友信息
        if (user.jidStr) {
            // 传递基础好友信息
            cell.user = user;
        }
        // 设置cell内容
        [cell setCell:temp];
    } else if (indexPath.section == 1) {
        // 获取对应的好友基本信息
        XMPPUserCoreDataStorageObject *user = self.onLineFriends[indexPath.row];
        // 根据用户账号查询详细信息
        XMPPvCardTemp *temp = [[LFXMPPHelp shareXMPPHelp] xmppGetFriendInfoWithUsername:user.jidStr];
        if (user.jidStr) {
            // 传递基础好友信息
            cell.user = user;
        }
        
        // 设置cell内容
        [cell setCell:temp];
    } else if (indexPath.section == 2) {
        // 获取对应的好友基本信息
        XMPPUserCoreDataStorageObject *user = self.exitFriends[indexPath.row];
        // 根据用户账号查询详细信息
        XMPPvCardTemp *temp = [[LFXMPPHelp shareXMPPHelp] xmppGetFriendInfoWithUsername:user.jidStr];
        // 传递基础好友信息
        if (user.jidStr) {
            // 传递基础好友信息
            cell.user = user;
        }
        // 设置cell内容
        [cell setCell:temp];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) { // 只有第一组需要更大的控件存放搜索条
        return 30;
    }
    
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 20)];
    // 创建Label
    UILabel *title = [[UILabel  alloc] initWithFrame:CGRectMake(5, 5, view.frame.size.width - 5, 30)];
    if (section == 0) { // 如果是第2组
        // 设置文本
        title.text = [NSString stringWithFormat:@"百分百好友(%d人)", self.goodFriends.count];;
    } else if (section == 1) {
        title.text = [NSString stringWithFormat:@"在线好友(%d/%d)", self.onLineFriends.count, self.allFriends.count];;
    } else if (section == 2) {
        title.text = [NSString stringWithFormat:@"离线好友(%d/%d)", self.exitFriends.count, self.allFriends.count];;
    }
    // 设置字体大小
    title.font = [UIFont boldSystemFontOfSize:15.0f];
    // 设置文本颜色
    title.textColor = [UIColor whiteColor];
    // 加入视图
    [view addSubview:title];
    // 透明背景色
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建聊天控制器
//    LFChatViewController *chatVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LFChatViewController"];
//    chatVc.hidesBottomBarWhenPushed = YES;
    
    LFSeeInfoViewController *seeInfoVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LFSeeInfoViewController"];
    // 创建按钮
    [seeInfoVc setTalkButton];
    
    // 获取对应的用户数据
    XMPPUserCoreDataStorageObject *user = nil;
    if (indexPath.section == 0) {
        user = self.goodFriends[indexPath.row];
    } else if (indexPath.section == 1) {
        user = self.onLineFriends[indexPath.row];
    } else if (indexPath.section == 2) {
        user = self.exitFriends[indexPath.row];
    }
    
    // 设置好友信息
    seeInfoVc.temp = [[LFXMPPHelp shareXMPPHelp] xmppGetFriendInfoWithUsername:user.jidStr];
    // 传递好友基本信息
    seeInfoVc.obj = user;
    // 传入代码块
    seeInfoVc.talkBlock = ^(LFSeeInfoViewController *seeInfoVc) {
        // 创建聊天控制器
        LFChatViewController *chatVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LFChatViewController"];
        chatVc.isHiddenRightItem = YES;
        
//        if (indexPath.section == 1) {
//            // 获取对应的用户数据
//            XMPPUserCoreDataStorageObject *user = self.onLineFriends[indexPath.row];
//            // 设置好友信息
//            [chatVc setFriendInfo:user];
//        } else if (indexPath.section == 2) {
//            // 获取对应的用户数据
//            XMPPUserCoreDataStorageObject *user = self.exitFriends[indexPath.row];
//            // 设置好友信息
//            [chatVc setFriendInfo:user];
//        }
        // 设置好友信息
        [chatVc setFriendInfo:user];
        // 跳转
        [self.navigationController pushViewController:chatVc animated:YES];
        
    };
    
    // 跳转
    [self.navigationController pushViewController:seeInfoVc animated:YES];
}

/**
 *  产生左滑事件 默认是删除
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建事件
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        XMPPUserCoreDataStorageObject *obj = nil;
        if (indexPath.section == 0) {
            obj = self.goodFriends[indexPath.row];
        } else if (indexPath.section == 1) {
            obj = self.onLineFriends[indexPath.row];
        } else if (indexPath.section == 2) {
            obj = self.exitFriends[indexPath.row];
        }
        if (obj.jid) {
            [[LFXMPPHelp shareXMPPHelp].xmppRoster removeUser:obj.jid];
        } else {
            return;
        }
        
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        
        // 把好友从沙盒中删除
        if ([def objectForKey:kMyLoginName]) {
            NSString *name = nil;
            if (obj.jidStr) {
                name = [[LFXMPPHelp shareXMPPHelp] xmppGetJibWithName:obj.jidStr].user;
            }
            
            NSMutableArray *arr = [[def objectForKey:kMyLoginName] mutableCopy];
            if ([arr containsObject:name]) {
                [arr removeObject:name];
                [def setObject:arr forKey:kMyLoginName];
            }
        }
    }];
    // 设置透明背景
    deleteAction.backgroundColor = [UIColor clearColor];
    
    return @[deleteAction];
}


#pragma mark - xmpp代理方法
/**
 *  当上下文变化时调用(好友上下线)
 */
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // 重新分类好友
    [self changeFriendArray];
    // 刷新表格
    [self.tableView reloadData];
}


@end
