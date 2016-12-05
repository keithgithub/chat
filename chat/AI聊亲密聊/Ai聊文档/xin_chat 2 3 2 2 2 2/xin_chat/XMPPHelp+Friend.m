//
//  XMPPHelp+Friend.m
//  WeiXinChar
//
//  Created by guan song on 15/11/25.
//  Copyright (c) 2015年 guan song. All rights reserved.
//

#import "XMPPHelp+Friend.h"

@implementation XMPPHelp (Friend)
#pragma mark  获取好友列表
-(NSFetchedResultsController *)getFriends
{
    
    //获取coredata管理对象上下文
    NSManagedObjectContext *context=self.rosterStorage.mainThreadManagedObjectContext;
    //创建请求2.FetchRequest【查哪张表】
    NSFetchRequest *request=[[NSFetchRequest  alloc]initWithEntityName:@"XMPPUserCoreDataStorageObject"];
    //用户单例，获取用户名
    UserInfo *user=[UserInfo  shareUser];
    
    //筛选本用户的好友
    NSString *userinfo = [NSString stringWithFormat:@"%@@%@",user.loginName,domain];
    
    NSLog(@"userinfo = %@",userinfo);
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@ "streamBareJidStr = %@",userinfo];
    request.predicate = predicate;
    
    //排序
    NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    
    self.fetFriend = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    //    self.fetFriend.delegate = self;
    NSError *error;
    [self.fetFriend performFetch:&error];
    
    //返回的数组是XMPPUserCoreDataStorageObject  *obj类型的
    //名称为 obj.displayName
    NSLog(@"%lu",(unsigned long)self.fetFriend.fetchedObjects.count);
    
    return  self.fetFriend;
}
#pragma mark  添加好友

//添加好友
-(BOOL) addFriend:(NSString*) friendName
{
    XMPPJID * friendJid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",friendName,domain]];
    [self.rosterModule subscribePresenceToUser:friendJid];
    return YES;
}

/**
 *  根据好友的jid获取电话号码
 *
 *  @param friJid 好友jid
 *
 *  @return 好友名片
 */
+(XMPPvCardTemp *)searchFriendDetailInfo:(XMPPJID *)friJid
{
    XMPPvCardTemp *myVCard=  [[XMPPHelp  shareXmpp].vCard  vCardTempForJID:friJid shouldFetch:YES];
    
    return myVCard;
    
}

//#pragma mark 删除好友，name为好友账号
//- (void)removeBuddy:(NSString *)name
//{
//    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",name,domain]];
//    [self.rosterModule removeUser:jid];
//}
//
//
//#pragma mark name为用户账号
////接受好友的请求
//- (void)XMPPAddFriendSubscribe:(NSString *)name
//{
//    //XMPPHOST 就是服务器名，  主机名
//    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",name,domain]];
//    
//    [self.rosterModule subscribePresenceToUser:jid];
//    
//}


@end
