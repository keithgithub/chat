//
//  LFXMPPHelp+Message.h
//  ZLF_Char
//
//  Created by 郑卢峰 on 15/11/29.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFXMPPHelp.h"

// 枚举定义
typedef NS_ENUM(NSInteger, MessageType) {
    text,
    image,
    audio
};

@interface LFXMPPHelp (Message)
- (void)xmppTalkToFriend:(NSString *)friendName andMessage:(NSString *)msg andMessageType:(MessageType)type;

/**
 *  获取聊天记录
 */
- (NSFetchedResultsController *)xmppGetMessageLocalWithFriendName:(NSString *)name;
@end
