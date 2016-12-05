//
//  LFXMPPHelp.h
//  ZLF_Char
//
//  Created by ibokan on 15/11/27.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "LFUserInfo.h"

#define FRIENDMESSAGENOTIFICATION @"FRIENDMESSAGENOTIFICATION"//好友消息通知

// 枚举
typedef NS_ENUM(NSInteger, XMPPResultType) {
    XMPPResultTypeConnecting, // 连接中...
    XMPPResultTypeLoginSuccess, // 登录成功
    XMPPResultTypeLoginFailure, // 登录失败
    XMPPResultTypeNetWorkError, // 网络不给力
    XMPPResultTypeRegisterSuccess, // 注册成功
    XMPPResultTypeRegisterFailure // 注册失败
};

/**
 *  代码块
 *
 *  @param XMPPResultType 枚举类型
 */
typedef void (^XMPPResultBlock)(XMPPResultType type);

@interface LFXMPPHelp : NSObject <XMPPStreamDelegate> // 签协议,连接代理

/**
 *  存储请求参数的代码块
 */
@property (nonatomic, strong) XMPPResultBlock saveResultBlock;

/**
 *  1.YES:注册, NO:登录
 */
@property (nonatomic, assign) BOOL isRegisterOpeation;

//=================XMPP==============
/**
 *  2.创建xmpp流对象，
 */
@property (nonatomic, strong) XMPPStream *xmppStream;

/**
 *  xmpp添加好友管理对象
 */
@property (nonatomic, strong) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong) XMPPRosterCoreDataStorage *xmppRosterCoredataStorage;
@property (nonatomic, strong) XMPPRoster *xmppRoster;

/**
 *  查询结果调度器
 */
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

/**
 *  声明上传头像相关对象
 */
@property (nonatomic, strong) XMPPvCardCoreDataStorage *xmppvCardCoreDataStorage;
@property (nonatomic, strong) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong) XMPPvCardAvatarModule *xmppvCardAvatarModule;

/**
 *  获取消息记录相关对象
 */
@property (nonatomic, strong) XMPPMessageArchivingCoreDataStorage *msgStorage; // 消息存储
@property (nonatomic, strong) XMPPMessageArchiving *msgArchiving; // 消息模块
@property (nonatomic, strong) NSFetchedResultsController *fetMsgRecord; // 查询消息的fetch

/**
 *  3.获取类的单例对象
 */
+ (LFXMPPHelp *)shareXMPPHelp;

/**
 *  注册,登录
 *
 *  @param resultBlock 注册结果返回
 */
- (void)xmppUserRegisterOrLoginResultBlock:(XMPPResultBlock)resultBlock;

/**
 *  注销
 */
- (void)xmppUserLogout;

/**
 *  通过名字获取JIB
 */
- (XMPPJID *)xmppGetJibWithName:(NSString *)user;

/**
 *  添加好友
 *
 *  @param user 用户账号
 */
- (void) xmppAddNewFriendWithName:(NSString *)user;


/**
 *  获取好友列表
 */
- (NSArray *)xmppGetFriends;

/**
 *  获取用户详细信息
 *
 *  @param name 用户账号
 *
 *  @return 用户信息类XMPPvCardTemp
 */
- (XMPPvCardTemp *) xmppGetFriendInfoWithUsername:(NSString *)name;

/**
 *  获取用户详细信息
 *
 *  @param JID
 *
 *  @return 用户信息类XMPPvCardTemp
 */
- (XMPPvCardTemp *) xmppGetFriendInfoWithJID:(XMPPJID *)jid;

@end








