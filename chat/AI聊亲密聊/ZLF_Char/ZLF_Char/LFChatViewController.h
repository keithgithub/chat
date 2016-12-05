//
//  LFChatViewController.h
//  ZLF_Char
//
//  Created by ibokan on 15/11/26.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMPPUserCoreDataStorageObject;

@interface LFChatViewController : UIViewController
@property (nonatomic, assign) BOOL isHiddenRightItem;

/**
 *  是否隐藏右侧按钮
 */
- (void)hiddenRightItem;

/**
 *  设置好友信息
 *
 *  @param temp 好友信息管理类
 */
- (void)setFriendInfo:(XMPPUserCoreDataStorageObject *)user;

@end
