//
//  LFXMPPHelp+Message.m
//  ZLF_Char
//
//  Created by 郑卢峰 on 15/11/29.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFXMPPHelp+Message.h"
#import "LFConstant.h"


@implementation LFXMPPHelp (Message)

- (void)xmppTalkToFriend:(NSString *)friendName andMessage:(NSString *)msg andMessageType:(MessageType)type {
    // 作为请求参数
    NSString *messageText = nil;
    switch (type) {
        case text:
            messageText = @"text";
            break;
        case image:
            messageText = @"image";
            break;
        case audio:
            messageText = @"audio";
            break;
        default:
            break;
    }
    
    XMPPJID *jid = [self xmppGetJibWithName:friendName];
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:jid];
    // 声明内容为纯文本
    [message addAttributeWithName:@"bodyType" stringValue:messageText];
    // 设置内容
    [message addBody:msg];
    // 发送请求
    [self.xmppStream sendElement:message];
    
    // 截取存储用的格式名
    NSString *newName = [[LFXMPPHelp shareXMPPHelp] xmppGetJibWithName:friendName].user;
    
    // 存入沙盒
    [LFUserInfo nearestFriend:newName];
    // 怎么亲密度
    [LFUserInfo friendIntimacy:newName];
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
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@",[self xmppGetJibWithName:[LFUserInfo shareUserInfo].loginName].bare, friendJid.bare];
    request.predicate = pre;
    // 时间升序
    NSSortDescriptor *tiemSort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[tiemSort];
    
    // 查询
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) { // 在后台
        LFLog(@"在后台");
    } else { // 程序运行中
        // 创建通知 并且把好友发来的信息发送出去
        NSNotification *notification = [NSNotification notificationWithName:FRIENDMESSAGENOTIFICATION object:self userInfo:@{@"message" : message}];
        // 发送消息
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

@end










