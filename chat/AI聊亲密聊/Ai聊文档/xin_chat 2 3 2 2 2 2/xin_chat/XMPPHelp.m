//
//  XMPPHelp.m
//  WeiXinChar
//
//  Created by guan song on 15/11/23.
//  Copyright (c) 2015年 guan song. All rights reserved.
//

#import "XMPPHelp.h"
//单例对象
static  XMPPHelp  *help=nil;

@implementation XMPPHelp
/**
 *  获取XMPPHelp类单例对象
 *
 *  @return 返回对象
 */
+(XMPPHelp *)shareXmpp
{
    if (help==nil)
    {
        help=[[self  alloc]init];
    }
    return help;
    
}
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    //只执行一次，多用在类方法中用来返回一个单例
    static  dispatch_once_t  onceToken;
    //该函数接收一个dispatch_once用于检查该代码块是否已经被调度
    //dispatch_once不仅意味着代码仅会被运行一次，而且还是线程安全的
    dispatch_once(&onceToken, ^{
        help=[super  allocWithZone:zone];
    });
    return help;
}
#pragma mark 激活相关的模块
//-(void) activeModules
//{
//    //1.花名册存储对象
//    self.rosterStorage = [XMPPRosterCoreDataStorage sharedInstance];
//    //2.花名册模块
//    self.rosterModule = [[XMPPRoster alloc] initWithRosterStorage:self.rosterStorage];
//    //3.激活此模块
//    [self.rosterModule activate:self.xmppStream];
//    //4.添加roster代理
//    [self.rosterModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
//    
//    //    //1.消息存储对象
//    self.msgStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
//    self.msgModule = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:self.msgStorage];
//    [self.msgModule activate:self.xmppStream];
//    [self.msgModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
//    
//}




- (XMPPJID *)xmppGetJibWithName:(NSString *)user {
    if ([user containsString:@"@"]) { // 如果传入的是完整名称则分割
        NSUInteger index = [user rangeOfString:@"@"].location;
        user = [user substringToIndex:index];
    }

    return [XMPPJID jidWithUser:user domain:domain resource:@"iPhone"];
}

/**
 *  创建xmppStraem流对象，并设置代理
 */
-(void)setupStream
{
    if(!self.xmppStream)
    {
        self.xmppStream=[[XMPPStream  alloc]init];
        
//        _xmppStream = [[XMPPStream alloc] init];
//#warning 每一个模块添加后都要激活
        //添加自动连接模块
        _reconnect = [[XMPPReconnect alloc] init];
        [_reconnect activate:_xmppStream];
        
        //添加电子名片模块
        _vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];

        _vCard = [[XMPPvCardTempModule alloc] initWithvCardStorage:_vCardStorage];
        
        //激活
        [_vCard activate:_xmppStream];
        
        //添加头像模块
        _avatar = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_vCard];
        [_avatar activate:_xmppStream];
        
        
        // 添加花名册模块【获取好友列表】
        _rosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
        _rosterModule=[[XMPPRoster alloc]initWithRosterStorage:self.rosterStorage dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        [_rosterModule activate:_xmppStream];
        
        // 添加聊天模块
        _msgStorage = [[XMPPMessageArchivingCoreDataStorage alloc] init];
        _msgArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_msgStorage];
        [_msgArchiving activate:_xmppStream];
        
        _xmppStream.enableBackgroundingOnSocket = YES;
        
//        // 设置代理
//        [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        
        
        [self.xmppStream  addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        
        
        
    }
    
    
}


#pragma mark  注册/登录
-(void)xmppUserRegisterOrLoginResultBlock:(XMPPResultBlock)resultBlock
{
    self.saveResultBlock=resultBlock;
    //若以前连接过，先断开连接
    [self.xmppStream  disconnect];
    
    [self  connectToHost];//连接
    
    //发送通知，正在连接
    [self  postNotification:XMPPResultTypeConnecting];
    // 从单例获取用户名
    NSString *user = nil;
    //判断是注册
    if (self.isRegisterOperation)
    {
        user=[UserInfo  shareUser].registerName;//注册名
    }
    else
    {
        user=[UserInfo  shareUser].loginName;//用户名
    }
   
  //获取拼接jid,并设置
    self.xmppStream.myJID=[XMPPJID  jidWithUser:user domain:domain resource:@"iPhone"];
    //设置主机服务器域名
    self.xmppStream.hostName=domain;//@"192.168.2.201";//
    //设置端口,设置端口 如果服务器端口是5222，可以省略（默认）
    self.xmppStream.hostPort=5222;
    //连接
    NSError *err=nil;
    if (![self.xmppStream  connectWithTimeout:XMPPStreamTimeoutNone error:&err])
    {
        //连接出错
//        WCLog(@"%@",err);
    }
}
#pragma mark  连接服务器
/**
 *  连接服务器
 */
-(void)connectToHost
{
  
    [self  setupStream];
    
}

/**
 * 通知 WCHistoryViewControllers 登录状态
 *
 */
-(void)postNotification:(XMPPResultType)resultType{
    
    // 将登录状态放入字典，然后通过通知传递
    NSDictionary *userInfo = @{@"loginStatus":@(resultType)};
    //
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSLoginStatusChangeNotification" object:nil userInfo:userInfo];
}
#pragma mark  XMPPStream代理

#pragma mark  连接成功的回调
-(void)xmppStreamDidConnect:(XMPPStream *)sender
{
//    WCLog(@"连接成功!");
    //存储错误信息
    NSError *err=nil;
    NSString *pwd=nil;
    if (self.isRegisterOperation)//是注册
    {
        //获取注册密码
        pwd=[UserInfo  shareUser].registerPwd;
        //发送注册密码
        [self.xmppStream  registerWithPassword:pwd error:&err];
    }
    else//登录
    {
        //获取登录密码
        pwd=[UserInfo  shareUser].loginPwd;
        //发送登录密码
        [self.xmppStream  authenticateWithPassword:pwd error:&err];
    }
    
    
}
#pragma mark  连接失败
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    // 如果有错误，代表连接失败
    
    // 如果没有错误，表示正常的断开连接(人为断开连接)
    
    if (error && self.saveResultBlock)
    {
        //代码块回调连接断开
        self.saveResultBlock(XMPPResultTypeNetWorkError);
    }
    if (error)
    {
        //通知网络不稳定
        [self  postNotification:XMPPResultTypeNetWorkError];
    }
   
}
#pragma mark  授权成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
   
    [self  sendOnlineToHost];
    UserInfo  *user=[UserInfo  shareUser];
    
        user.loginStatus=YES;
        //成功回调
        self.saveResultBlock(XMPPResultTypeLoginSuccess);
}
#pragma mark  授权失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    
    self.saveResultBlock(XMPPResultTypeLoginFailure);//登录失败回调
    
  
}
#pragma mark  注册成功
-(void)xmppStreamDidRegister:(XMPPStream *)sender
{
    self.saveResultBlock(XMPPResultTypeRegisterSuccess);
}
#pragma mark 注册失败
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    self.saveResultBlock(XMPPResultTypeRegisterFailure);//登录失败回调
    
   }
#pragma end  mark
/**
 *  发送上线状态到主机
 */
-(void)sendOnlineToHost
{
   XMPPPresence  *presence=[XMPPPresence  presenceWithType:@"available"];//状态信息
    [self.xmppStream  sendElement:presence];//发送上线状态
}

/**
 *  发送下线状态到主机
 */
-(void)sendOfflineToHost
{
XMPPPresence  *presence=[XMPPPresence  presenceWithType:@"unavailable"];//状态信息
    [self.xmppStream  sendElement:presence];//发送上线状态
}

#pragma mark  注销
-(void)xmppUserlogout{
    // 1." 发送 "离线" 消息"
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offline];
    
    // 2. 与服务器断开连接
    [_xmppStream disconnect];
    
    
    //4.更新用户的登录状态
    [UserInfo shareUser].loginStatus = NO;
    [[UserInfo shareUser] saveUserInfoToSanbox];
    
}
////处理加好友
#pragma mark 处理加好友回调,加好友
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
       //取得好友状态
   
    //请求的用户
    NSString *presenceFromUser =[NSString stringWithFormat:@"%@", [[presence from] user]];
   
    
    XMPPJID *jid = [XMPPJID jidWithString:presenceFromUser];
    [self.rosterModule acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
    
}

//判断手机号
+(BOOL)isTelphoneNum:(NSString *)phoneText
{
    
    NSString *telRegex = @"^1[3578]\\d{9}$";
    NSPredicate *prediate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telRegex];
    return [prediate evaluateWithObject:phoneText];
    
}

@end
