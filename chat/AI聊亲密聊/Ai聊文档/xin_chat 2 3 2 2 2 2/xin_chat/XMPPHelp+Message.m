//
//  XMPPHelp+Message.m
//  WeiXinChar
//
//  Created by guan song on 15/11/25.
//  Copyright (c) 2015年 guan song. All rights reserved.
//

#import "XMPPHelp+Message.h"

@implementation XMPPHelp (Message)
#pragma mark 与某个好友聊天
-(void) talkToFriend:(XMPPJID*)friendsJid andMsg:(NSString*) msg  andMsgType:(MsgType) msgT
{

    NSString *msgText;
    switch (msgT)
    {
        case 0:
            msgText=@"text";
            break;
        case 1:
            msgText=@"image";
            break;
        case 2:
            msgText=@"audio";
            break;
        default:
            break;
    }
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:friendsJid];
    
    //text 纯文本
    [message addAttributeWithName:@"bodyType" stringValue:msgText];
    
    // 设置内容
    [message addBody:msg];
   [self.xmppStream sendElement:message];
    
}

/**
 *  获取聊天记录
 */
- (NSFetchedResultsController *)xmppGetMessageLocalWithFriendName:(NSString *)name {
    // 获取消息存储器的上下文
    NSManagedObjectContext *context = self.msgStorage.mainThreadManagedObjectContext;
    // 请求对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    // 这里获取到得是所有的好友的消息记录
    // 过滤、排序
    // 1.当前登录用户的JID的消息
    // 2.好友的Jid的消息
    XMPPJID *friendJid = [self xmppGetJibWithName:name];
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@",[self xmppGetJibWithName:[UserInfo shareUser].loginName].bare, friendJid.bare];
    request.predicate = pre;
    // 时间升序
    NSSortDescriptor *tiemSort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[tiemSort];
    
    // 查询
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
}


#pragma mark 接收到好友消息
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    //如果当前程序不在前台，发出一个本地通知
    if([UIApplication sharedApplication].applicationState != UIApplicationStateActive){
       
        //本地通知
        UILocalNotification *localNoti = [[UILocalNotification alloc] init];
        
        // 设置内容
        localNoti.alertBody = [NSString stringWithFormat:@"%@\n%@",message.from.user,message.body];
        
        // 设置通知执行时间
        localNoti.fireDate = [NSDate date];
        
        //声音
        localNoti.soundName = @"default";
        
        //执行
        [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
    
    }
    
        //创建通知
        NSNotification *notification=[NSNotification  notificationWithName:FRIENDMESSAGENOTIFICATION object:self userInfo:@{@"message":message}];
        
        [[NSNotificationCenter  defaultCenter]  postNotification:notification];//发送通知
        
    
}

@end
