//
//  XMPPHelp+Message.h
//  WeiXinChar
//
//  Created by guan song on 15/11/25.
//  Copyright (c) 2015年 guan song. All rights reserved.
//

#import "XMPPHelp.h"

@interface XMPPHelp (Message)
//与某个好友聊天
-(void) talkToFriend:(XMPPJID*)friendsJid andMsg:(NSString*) msg  andMsgType:(MsgType) msgT;
/**
 *  获取聊天记录
 */
- (NSFetchedResultsController *)xmppGetMessageLocalWithFriendName:(NSString *)name;
@end
