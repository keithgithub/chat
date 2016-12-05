//
//  ChatViewController.h
//  xin_chat
//
//  Created by xiao on 15/11/29.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPHelp+Message.h"

@protocol  ChatViewControllerDelegate<NSObject>

- (void)removeCount:(XMPPJID*)jid;

@end

@interface ChatViewController : UIViewController

@property (nonatomic,assign) id<ChatViewControllerDelegate> delegate;
@property(nonatomic,strong) XMPPJID  *fridendJid;//好友对象

@property (nonatomic, copy) NSString *strJid;

@property (nonatomic, strong) NSMutableArray *arrJid;

@end
