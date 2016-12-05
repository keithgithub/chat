//
//  LFUserInfo.h
//  ZLF_Char
//
//  Created by ibokan on 15/11/27.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LFUserInfo : NSObject

// 注册名
@property (nonatomic, copy) NSString *registerName;

// 密码
@property (nonatomic, copy) NSString *registerPwd;

// 登陆名
@property (nonatomic, copy) NSString *loginName;

// 登陆密码
@property (nonatomic, copy) NSString *loginPwd;

/**
 *  登陆的状态 YES登录过/ NO 注销
 */
@property (nonatomic, assign) BOOL loginStatus;

/**
 *  获取用户单例对象
 */
+ (instancetype)shareUserInfo;

/**
 *  存储最近联系人到沙盒
 *
 *  @param name 联系人名
 */
+ (void)nearestFriend:(NSString *)name;

/**
 *  增加好友亲密度
 */
+ (void)friendIntimacy:(NSString *)name;

/**
 *  获取好友亲密度
 */
+ (NSString *)getFriendIntimacy:(NSString *)name;

/**
 *  增加好友消息角标
 */
+ (void)addFriendBadge:(NSString *)name;

/**
 *  获取好友消息角标
 */
+ (NSString *)getFriendBadge:(NSString *)name;

/**
 *  清空好友消息角标
 */
+ (void)removeFriendBadge:(NSString *)name;

/**
 *  设置离开时间
 */
- (void)setExitTime;

/**
 *  获取离开时间(如果没有就返回空字符串)
 */
- (NSString *)getExitTime;

/**
 *  清空所有消息角标
 */
+ (void)removeAllFriendBadge;

/**
 *  判断是不是电话号码
 */
+ (BOOL)isTelphoneNum:(NSString *)phoneText;

@end






