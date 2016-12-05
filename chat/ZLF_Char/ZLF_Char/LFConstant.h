//
//  LFConstant.h
//  ZLF_Char
//
//  Created by ibokan on 15/11/25.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#ifndef ZLF_Char_LFConstant_h
#define ZLF_Char_LFConstant_h

#ifdef DEBUG // 处于开发阶段
#define LFLog(...) NSLog(__VA_ARGS__)
#else // 处于发布阶段
#define LFLog(...)
#endif

// 屏幕宽度
#define kScreenW [UIScreen mainScreen].bounds.size.width
// 屏幕高度
#define kScreenH [UIScreen mainScreen].bounds.size.height
// 圆角
#define kCornerRadius 5

#define kSideViewChangeY 150

/**
 *  读取沙盒使用(用于存储最近发消息给我的好友清单)
 */
#define kMyLoginName [[LFXMPPHelp shareXMPPHelp] xmppGetJibWithName:[LFUserInfo shareUserInfo].loginName].user

/**
 *  读取沙盒使用(用于存储最近每个账户对应好友的亲密度)
 */
#define kFriendIntimacy [NSString stringWithFormat:@"%@friendIntimacy", [[LFXMPPHelp shareXMPPHelp] xmppGetJibWithName:[LFUserInfo shareUserInfo].loginName].user]

/**
 *  读取沙盒使用(用于存储最近每个账户对应好友的未读消息角标)
 */
#define kFriendBadge [NSString stringWithFormat:@"%@friendBadge", [[LFXMPPHelp shareXMPPHelp] xmppGetJibWithName:[LFUserInfo shareUserInfo].loginName].user]

/**
 *  读取沙盒使用(用于存储每个账号的离线时间)
 */
#define kExitTime [NSString stringWithFormat:@"%@ExitTime", [[LFXMPPHelp shareXMPPHelp] xmppGetJibWithName:[LFUserInfo shareUserInfo].loginName].user]

/**
 *  男生颜色
 */
#define kBoyColor [UIColor colorWithRed:0.318 green:0.827 blue:0.937 alpha:1.000]

/**
 *  女生颜色
 */
#define kGirlColor [UIColor colorWithRed:0.965 green:0.576 blue:0.741 alpha:1.000]

#endif





