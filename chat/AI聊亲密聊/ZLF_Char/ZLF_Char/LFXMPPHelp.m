//
//  LFXMPPHelp.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/27.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFXMPPHelp.h"
#import "LFConstant.h"
#import "MBProgressHUD+MJ.h"
#import "XMPPvCardTemp.h"

/**
 *  单例对象
 */
static LFXMPPHelp *help = nil;

/**
 *  服务器名
 */
static NSString *ip= @"112.74.105.205";
static NSString *domain= @"iz94h43ebwiz";
@implementation LFXMPPHelp

- (XMPPJID *)xmppGetJibWithName:(NSString *)user {
    if ([user containsString:@"@"]) { // 如果传入的是完整名称则分割
        NSUInteger index = [user rangeOfString:@"@"].location;
        user = [user substringToIndex:index];
    }
    return [XMPPJID jidWithUser:user domain:domain resource:@"iPhone"];
}

#pragma mark - 属性初始化
/**
 *  获取XMPPHelp的单例对象
 */
+ (LFXMPPHelp *)shareXMPPHelp {
    if (help == nil) {
        help = [[self alloc] init];
    }
    
    return help;
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController == nil) {
        // 指定查询的实体
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"XMPPUserCoreDataStorageObject"];
        // 用户单例，获取用户名
        LFUserInfo *user = [LFUserInfo shareUserInfo];

        // 筛选本用户的好友
        NSString *userInfo = [NSString stringWithFormat:@"%@@%@", user.loginName, domain];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@", userInfo];
        
        request.predicate = predicate;
        
        // 设定排序描述
        NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"sectionNum" ascending:YES];
        NSSortDescriptor *sort2 = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
        request.sortDescriptors = @[sort1, sort2];
        
        // 添加上下文
        NSManagedObjectContext *context = self.xmppRosterCoredataStorage.mainThreadManagedObjectContext;
        
        // 实例化结果控制器
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    }
    
    return _fetchedResultsController;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    //只执行一次，多用在类方法中用来返回一个单例
    static  dispatch_once_t  onceToken;
    //该函数接收一个dispatch_once用于检查该代码块是否已经被调度
    //dispatch_once不仅意味着代码仅会被运行一次，而且还是线程安全的
    dispatch_once(&onceToken, ^{
        help = [super  allocWithZone:zone];
    });
    return help;
}

/**
 *  创建xmppStream流对象，并设置代理
 */
- (void)setupStream {
    if (!self.xmppStream) {
        _xmppStream = [[XMPPStream alloc] init];
        // 创建对象
        _xmppReconnect = [[XMPPReconnect alloc] init];
        [_xmppReconnect activate:_xmppStream];
        
        // 获取单例对象
//        _xmppRosterCoredataStorage = [XMPPRosterCoreDataStorage sharedInstance];
        _xmppRosterCoredataStorage = [[XMPPRosterCoreDataStorage alloc] init];
        _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:_xmppRosterCoredataStorage];
        // 激活
        [_xmppRoster activate:_xmppStream];
        // 添加代理
        [_xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        /* 使用头像需要的属性部分 */
        // 管理coredata数据类
        _xmppvCardCoreDataStorage = [XMPPvCardCoreDataStorage sharedInstance];
        // 临时模块
        _xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:_xmppvCardCoreDataStorage];
        // 头像上传需要
        _xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_xmppvCardTempModule];
        
        // 设置代理
        [_xmppvCardTempModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [_xmppvCardAvatarModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        /* 获取消息记录 */
        _msgStorage = [[XMPPMessageArchivingCoreDataStorage alloc] init];
        _msgArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_msgStorage];
        [_msgArchiving activate:_xmppStream];
        
        // 激活
        [_xmppvCardTempModule activate:_xmppStream];
        [_xmppvCardAvatarModule activate:_xmppStream];
        
        [self fetchedResultsController];
        
        _xmppStream.enableBackgroundingOnSocket = YES;
    }
    // 设置代理
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

#pragma mark - 注册/登陆
/**
 *  注册/登陆
 */
- (void)xmppUserRegisterOrLoginResultBlock:(XMPPResultBlock)resultBlock {
    // 代码块存储
    self.saveResultBlock = resultBlock;
    // 若以前连接过先断开
    [self.xmppStream disconnect];
    
    // 连接服务器
    [self connectToHost];
    
    // 从单例获取用户名
    NSString *user = nil;
    // 判断是注册
    if (self.isRegisterOpeation) {
        user = [LFUserInfo shareUserInfo].registerName; // 注册名
    } else { // 是登录￼
        user = [LFUserInfo shareUserInfo].loginName; // 用户名
    }
    // 获取拼接jib,并设置(user:用户名  domain:服务器名)*****必要
    self.xmppStream.myJID = [XMPPJID jidWithUser:user domain:domain resource:@"iPhone"];
    // 设置主机服务器域名
    self.xmppStream.hostName = ip;
    // 设置端口，如果服务器端口是5222,可以省略(默认)
    self.xmppStream.hostPort = 5222;
    
    // 连接
    NSError *err = nil;
    if (![self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&err]) {
        LFLog(@"连接出错 err:%@", err);
    }
}

/**
 *  添加好友
 */
- (void) xmppAddNewFriendWithName:(NSString *)user {
    // 获取jib
    XMPPJID *jib = [self xmppGetJibWithName:user];
    
    // 返回好友是否存在
    BOOL isContains = [[LFXMPPHelp shareXMPPHelp].xmppRosterCoredataStorage userExistsWithJID:jib xmppStream:[LFXMPPHelp shareXMPPHelp].xmppStream];
    if (isContains) { // 如果好友已经存在
        [MBProgressHUD showError:@"好友已经存在"];
        return;
    }
    
    // 添加好友
    [[LFXMPPHelp shareXMPPHelp].xmppRoster subscribePresenceToUser:jib];
    [MBProgressHUD showSuccess:@"好友申请已发送"];
}



#pragma mark 连接服务器
/**
 *  连接服务器
 */
- (void)connectToHost {
    [self setupStream];
}

#pragma mark XMPP代理方法

/**
 *  连接成功回调
 */
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    LFLog(@"连接成功!");
    // 存储错误信息
    NSError *err = nil;
    NSString *pwd = nil;
    
    if (self.isRegisterOpeation) { // 是注册
        // 获取注册密码
        pwd = [LFUserInfo shareUserInfo].registerPwd;
        // 发送注册密码 ***
        [self.xmppStream registerWithPassword:pwd error:&err];
    } else { // 是登录
        // 获取登录密码
        pwd = [LFUserInfo shareUserInfo].loginPwd;
        // 发送登录密码 *** 和发送注册密码不一样
        [self.xmppStream authenticateWithPassword:pwd error:&err];
    }
    
    if (err) {
        LFLog(@"err : %@", err);
    }
}

/**
 *  连接失败
 */
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    // 如果有错误代表连接失败
    
    // 如果没有错误,表示正常的断开连接(人为断开连接)
    
    if (error && self.saveResultBlock) {
        // 代码块回调连接断开
        self.saveResultBlock(XMPPResultTypeNetWorkError);
    }
    
    if (error) {
        // 通知网络不稳定(通知)
//        [self ]
    }
}

/**
 *  注册成功调用
 */
- (void)xmppStreamDidRegister:(XMPPStream *)sender {
    LFLog(@"注册成功");
    // 回调注册成功
    self.saveResultBlock(XMPPResultTypeRegisterSuccess);
}

/**
 *  注册失败
 */
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error {
    // 回调注册失败
    self.saveResultBlock(XMPPResultTypeRegisterFailure);
    LFLog(@"%@", error);
}

/**
 *  授权(登陆)成功调用
 */
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    // 创建XMPP用户状态管理对象
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    // 发送上线状态
    [self.xmppStream sendElement:presence];
    
//    // 激活
//    [_xmppvCardTempModule activate:_xmppStream];
//    [_xmppvCardAvatarModule activate:_xmppStream];
    
    // 回调代码块
    self.saveResultBlock(XMPPResultTypeLoginSuccess);
}

/**
 *  授权失败调用
 */
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error {
    LFLog(@"授权失败");
    self.saveResultBlock(XMPPResultTypeLoginFailure);
}

/**
 *  获取全部好友
 */
- (NSArray *)xmppGetFriends {
    // 查询数据
    NSError *err = nil;
    [self.fetchedResultsController performFetch:&err];
    
    if (err) {
        LFLog(@"LFXmppHelp xmppGetFriends %@", err);
    }
    
    return self.fetchedResultsController.fetchedObjects;
}

/**
 *  获取用户详细信息
 *
 *  @param name 用户账号
 *
 *  @return 用户信息类XMPPvCardTemp
 */
- (XMPPvCardTemp *) xmppGetFriendInfoWithUsername:(NSString *)name {
    return [self.xmppvCardTempModule vCardTempForJID:[self xmppGetJibWithName:name] shouldFetch:YES];
}

/**
 *  获取用户详细信息
 *
 *  @param JID
 *
 *  @return 用户信息类XMPPvCardTemp
 */
- (XMPPvCardTemp *) xmppGetFriendInfoWithJID:(XMPPJID *)jid {
    return [self.xmppvCardTempModule vCardTempForJID:jid shouldFetch:YES];
}

#pragma mark 注销
- (void)xmppUserLogout {
    // 1.发送离线消息
    XMPPPresence *offLine = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offLine];
    
    // 释放相关资源并且断开连接
    [self teardownXmpp];
}

#pragma mark 释放xmppStream相关的资源
- (void)teardownXmpp {
    // 移除模块
    [_xmppStream removeDelegate:self];
    
    [_xmppRoster removeDelegate:self];
    [_xmppvCardTempModule removeDelegate:self];
    [_xmppvCardAvatarModule removeDelegate:self];
    
    // 停止模块
    [_xmppReconnect deactivate];
    [_xmppvCardTempModule deactivate];
    [_xmppvCardAvatarModule deactivate];
    [_xmppRoster deactivate];
    [_msgArchiving deactivate];
    
    
    // 断开连接****重要
    [self.xmppStream disconnect];
    
    _xmppReconnect = nil;
    _xmppvCardTempModule = nil;
    _xmppvCardCoreDataStorage = nil;
    _xmppvCardAvatarModule = nil;
    _xmppRoster = nil;
    _xmppRosterCoredataStorage = nil;
    
    _msgArchiving = nil;
    _msgStorage = nil;
    _xmppStream = nil;
    _fetchedResultsController = nil;
}
/*
 // 获取单例对象

_xmppStream.enableBackgroundingOnSocket = YES;

 */

@end

















