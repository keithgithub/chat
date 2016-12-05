//
//  XMPPHelp.h
//  WeiXinChar
//
//  Created by guan song on 15/11/23.
//  Copyright (c) 2015年 guan song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

#import "UserInfo.h"

//NSString *const NSLoginStatusChangeNotification;

typedef enum {
    XMPPResultTypeConnecting,//连接中...
    XMPPResultTypeLoginSuccess,//登录成功
    XMPPResultTypeLoginFailure,//登录失败
    XMPPResultTypeNetWorkError,//网络不给力
    XMPPResultTypeRegisterSuccess,//注册成功
    XMPPResultTypeRegisterFailure//注册失败
}XMPPResultType;

typedef enum {//发送消息类型的枚举
    
    text,
    
    image,
    
    audio
    
} MsgType;

typedef void (^XMPPResultBlock)(XMPPResultType type);// XMPP请求结果的block
//@"pro.local";//
static NSString *domain = @"112.74.105.205";//服务器名



@interface XMPPHelp : NSObject<XMPPStreamDelegate>//签协议，连接代理
{
    XMPPReconnect *_reconnect;// 自动连接模块
    
    XMPPvCardCoreDataStorage *_vCardStorage;//电子名片的数据存储
    
    XMPPvCardAvatarModule *_avatar;//头像模块
    
    XMPPMessageArchiving *_msgArchiving;//聊天模块
}
//--------1
@property(nonatomic,strong)XMPPResultBlock  saveResultBlock;//存储请求参数的代码块
@property(nonatomic,assign)BOOL  isRegisterOperation;//YES:注册，NO:登录
//=================================
//创建xmpp流对象，xmpp的数据处理都为xml流
@property(nonatomic,strong)XMPPStream  *xmppStream;


@property(strong,nonatomic) XMPPRosterCoreDataStorage * rosterStorage;//花名册存储
@property(nonatomic,strong)NSFetchedResultsController *fetFriend;//查询好友的Fetch
@property(strong,nonatomic) XMPPRoster * rosterModule;//花名册模块
@property (nonatomic, strong,readonly)XMPPvCardTempModule *vCard;//电子名片
@property(strong,nonatomic) XMPPMessageArchivingCoreDataStorage *msgStorage;//消息存储
@property(strong,nonatomic) XMPPMessageArchiving * msgModule;//消息模块
@property(strong,nonatomic) NSFetchedResultsController *fetMsgRecord;//查询消息的Fetch


#define FRIENDMESSAGENOTIFICATION @"FRIENDMESSAGENOTIFICATION"//好友消息通知
#define WCUserStatusChangeNotification  @"WCUserStatusChangeNotification"//用状态改变的通知



//=================================

//-------3--------
+(XMPPHelp *)shareXmpp;//获取类的单例对象
/**
 *  注册,登录
 *  @param resultBlock 注册结果返回
 */
-(void)xmppUserRegisterOrLoginResultBlock:(XMPPResultBlock)resultBlock;
//--------------------------
/**
 *  注销
 */
-(void)xmppUserlogout;

/**
 *  通过名字获取JIB
 */
- (XMPPJID *)xmppGetJibWithName:(NSString *)user;

+(BOOL)isTelphoneNum:(NSString *)phoneText;
@end





