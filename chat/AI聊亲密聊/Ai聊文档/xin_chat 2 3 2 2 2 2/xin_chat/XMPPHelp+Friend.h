//
//  XMPPHelp+Friend.h
//  WeiXinChar
//
//  Created by guan song on 15/11/25.
//  Copyright (c) 2015年 guan song. All rights reserved.
//

#import "XMPPHelp.h"

@interface XMPPHelp (Friend)

/**
 *  获取好友列表
 *
 *  @param friendBlock 回调好友的Block
 */
-(NSFetchedResultsController *)getFriends;
//-(void) activeModules;
//添加好友
-(BOOL) addFriend:(NSString*) friendName;

+(XMPPvCardTemp *)searchFriendDetailInfo:(XMPPJID *)friJid;

//#pragma mark 删除好友，name为好友账号
//- (void)removeBuddy:(NSString *)name;
//#pragma mark name为用户账号
////接受好友的请求
//- (void)XMPPAddFriendSubscribe:(NSString *)name;
@end
