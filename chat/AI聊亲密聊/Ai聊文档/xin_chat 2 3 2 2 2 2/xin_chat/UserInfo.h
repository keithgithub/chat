//
//  UserInfo.h
//  WeiXinChar
//
//  Created by guan song on 15/11/24.
//  Copyright (c) 2015年 guan song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject


@property(nonatomic,copy)NSString *registerName,*registerPwd,*loginName,*loginPwd;//注册名，密码，登录名,登录密码
/**
 *  登录的状态 YES 登录过/NO 注销
 */
@property (nonatomic, assign) BOOL  loginStatus;
// 是否是记录登录状态的
@property (nonatomic, assign) BOOL  SaveStatus;

/**
 *  获取用户单例对象
 *
 *  @return 返回对象
 */
+(instancetype)shareUser;
/**
 *  从沙盒获取用户信息
 */
-(void)loadUserInfoFromSenbox;
/**
 *  保存用户信息到沙盒
 */
-(void)saveUserInfoToSanbox;

/**
 *  存储最近联系人到沙盒
 *
 *  @param name 联系人名
 */
+ (void)nearestFriend:(NSString *)name;

// 获取本地存储的好友信息
+ (NSMutableDictionary*)getFriendInforFromSanBoxAndKey:(NSString*)key;

// 获取本地存储的好友信息
+ (void)SaveFriendInforToSanBox:(NSMutableDictionary*)dic andName:(NSString*)name;

@end
