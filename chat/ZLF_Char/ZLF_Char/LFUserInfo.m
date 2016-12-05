//
//  LFUserInfo.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/27.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFUserInfo.h"
#import "LFXMPPHelp.h"
#import "LFConstant.h"
#import "NSDate+LFExtension.h"

// 单例对象
static LFUserInfo *user = nil;

@implementation LFUserInfo

/**
 *  实现单例类方法
 *
 *  @return 单例对象
 */
+ (instancetype)shareUserInfo {
    if (user == nil) {
        user = [[LFUserInfo alloc] init];
    }
    
    return user;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    // 只执行一次，多用在类方法中用来返回一个单例
    static dispatch_once_t onceToken;
    
    // 该函数接收一个dispatch_once用于检查该代码块是否已经被调度
    // dispatch_once不仅意味着代码仅会被运行一次，而且还是线程安全的
    dispatch_once(&onceToken, ^{
        user = [super allocWithZone:zone];
    });
    
    return user;
}

+ (void)nearestFriend:(NSString *)name {
    // 获取沙盒存储
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([def objectForKey:kMyLoginName]) { // 如果数据已存在
        // 取出原来的数组
        NSMutableArray *mArray = [[def objectForKey:kMyLoginName] mutableCopy];
        if ([mArray containsObject:name]) { // 如果这个用户已经存到沙盒
            // 删除原本的
            [mArray removeObject:name];
            // 添加数据并插入到第一个位置
            [mArray insertObject:name atIndex:0];
        } else {
            if (name) {
                // 添加数据并插入到第一个位置
                [mArray insertObject:name atIndex:0];
            }
        }
        [def setObject:mArray forKey:kMyLoginName];
    } else { // 数据还没被创建
        // 创建新的可变数组
        NSMutableArray *mArray = [NSMutableArray new];
        // 添加数据
        [mArray addObject:name];
        // 写入沙盒
        [def setObject:mArray forKey:kMyLoginName];
    }
    // 同步数据
    [def synchronize];
}

/**
 *  好友亲密度
 */
+ (void)friendIntimacy:(NSString *)name {
    // 获取好友准确账号
    name = [[LFXMPPHelp shareXMPPHelp] xmppGetJibWithName:name].user;
    // 获取沙盒存储
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([def objectForKey:kFriendIntimacy]) { // 如果数据已存在
        // 取出原来的字典
        NSMutableDictionary *mDict = [[def objectForKey:kFriendIntimacy] mutableCopy];
        if (mDict[name]) { // 如果这个用户的亲密度已经存到沙盒
            // 获取亲密度
            NSString *intimacy = mDict[name];
            int i = [intimacy intValue];
            // 如果亲密度未满
            if (i < 100) {
                // 值增加
                intimacy = [NSString stringWithFormat:@"%d", ++i];
                // 重新赋值
                mDict[name] = intimacy;
            }
        } else {
            if (name) {
                // 创建新的key和初始值
                mDict[name] = @"1";
            }
        }
        [def setObject:mDict forKey:kFriendIntimacy];
    } else { // 数据还没被创建
        // 创建可变字典
        NSMutableDictionary *mDict = [NSMutableDictionary new];
        // 创建新的key和初始值
        mDict[name] = @"1";
        // 写入沙盒
        [def setObject:mDict forKey:kFriendIntimacy];
    }
    // 同步数据
    [def synchronize];
}

/**
 *  获取好友亲密度
 */
+ (NSString *)getFriendIntimacy:(NSString *)name {
    // 获取好友准确账号
    name = [[LFXMPPHelp shareXMPPHelp] xmppGetJibWithName:name].user;
    
    // 获取沙盒存储
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([def objectForKey:kFriendIntimacy]) { // 如果数据已存在
        // 取出原来的字典
        NSMutableDictionary *mDict = [[def objectForKey:kFriendIntimacy] mutableCopy];
        if (mDict[name]) { // 如果这个用户的亲密度已经存到沙盒
            
            return  mDict[name];
        } else {
            if (name) {
                // 创建新的key和初始值
                [mDict setObject:@"1" forKey:name];
                [def setObject:mDict forKey:kFriendIntimacy];
                // 同步数据
                [def synchronize];
                
                return  mDict[name];
            }
        }
    } else { // 数据还没被创建
        // 创建可变字典
        NSMutableDictionary *mDict = [NSMutableDictionary new];
        if (name) {
            // 创建新的key和初始值
            [mDict setObject:@"1" forKey:name];
        }
        // 写入沙盒
        [def setObject:mDict forKey:kFriendIntimacy];
        // 同步数据
        [def synchronize];
        
        return  mDict[name];
    }
    
    return @"0";
}

/**
 *  增加好友消息角标
 */
+ (void)addFriendBadge:(NSString *)name {
    // 获取好友准确账号
    name = [[LFXMPPHelp shareXMPPHelp] xmppGetJibWithName:name].user;
    // 获取沙盒存储
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([def objectForKey:kFriendBadge]) { // 如果数据已存在
        // 取出原来的字典
        NSMutableDictionary *mDict = [[def objectForKey:kFriendBadge] mutableCopy];
        if (mDict[name]) { // 如果这个用户的角标已经存到沙盒
            // 获取角标数量
            NSString *badge = mDict[name];
            // 转为整形
            int i = [badge intValue];
            // 如果角标未到100条
            if (i < 100) {
                // 值增加
                badge = [NSString stringWithFormat:@"%d", ++i];
                // 重新赋值
                mDict[name] = badge;
            } else {
                mDict[name] = [NSString stringWithFormat:@"99+"];
            }
        } else {
            if (name) {
                // 创建新的key和初始值
                mDict[name] = @"1";
            }
        }
        [def setObject:mDict forKey:kFriendBadge];
    } else { // 数据还没被创建
        // 创建可变字典
        NSMutableDictionary *mDict = [NSMutableDictionary new];
        // 创建新的key和初始值
        mDict[name] = @"1";
        // 写入沙盒
        [def setObject:mDict forKey:kFriendBadge];
    }
    // 同步数据
    [def synchronize];
}

/**
 *  获取好友消息角标
 */
+ (NSString *)getFriendBadge:(NSString *)name {
    // 获取好友准确账号
    name = [[LFXMPPHelp shareXMPPHelp] xmppGetJibWithName:name].user;
    // 获取沙盒存储
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([def objectForKey:kFriendBadge]) { // 如果数据已存在
        // 取出原来的字典
        NSMutableDictionary *mDict = [[def objectForKey:kFriendBadge] mutableCopy];
        if (mDict[name]) { // 如果这个用户的角标已经存到沙盒
            // 获取角标数量
            NSString *badge = mDict[name];
            
            return badge;
        }
    }  else { // 数据还没被创建
        // 创建可变字典
        NSMutableDictionary *mDict = [NSMutableDictionary new];
        // 创建新的key和初始值
        mDict[name] = @"0";
        // 写入沙盒
        [def setObject:mDict forKey:kFriendBadge];
        // 同步数据
        [def synchronize];
        
        return mDict[name];
    }
    // 同步数据
    [def synchronize];
    
    return @"0";
}

/**
 *  清空好友消息角标
 */
+ (void)removeFriendBadge:(NSString *)name {
    // 获取好友准确账号
    name = [[LFXMPPHelp shareXMPPHelp] xmppGetJibWithName:name].user;
    // 获取沙盒存储
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([def objectForKey:kFriendBadge]) { // 如果数据已存在
        // 取出原来的字典
        NSMutableDictionary *mDict = [[def objectForKey:kFriendBadge] mutableCopy];
        if (mDict[name]) { // 如果这个用户的角标已经存到沙盒
            mDict[name] = [NSString stringWithFormat:@"0"];
        } else {
            if (name) {
                // 创建新的key和初始值
                mDict[name] = @"0";
            }
        }
        [def setObject:mDict forKey:kFriendBadge];
    } else { // 数据还没被创建
        // 创建可变字典
        NSMutableDictionary *mDict = [NSMutableDictionary new];
        // 创建新的key和初始值
        mDict[name] = @"0";
        // 写入沙盒
        [def setObject:mDict forKey:kFriendBadge];
    }
    // 同步数据
    [def synchronize];
}

/**
 *  清空所有消息角标
 */
+ (void)removeAllFriendBadge {
    // 获取沙盒单例
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([def objectForKey:kFriendBadge]) { // 如果好友角标存在
        // 取出原来的字典
        NSMutableDictionary *mDict = [[def objectForKey:kFriendBadge] mutableCopy];
        for (NSString *obj in mDict) {
            [self removeFriendBadge:obj];
        }
    }
}

/**
 *  设置离开时间
 */
- (void)setExitTime {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:[NSDate getNowTime] forKey:kExitTime];
    [def synchronize];
}

/**
 *  获取离开时间(如果没有就返回空字符串)
 */
- (NSString *)getExitTime {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([def objectForKey:kExitTime]) {
        return [def objectForKey:kExitTime];
    }
    
    return @"";
}

/**
 *  判断是不是电话号码
 */
+ (BOOL)isTelphoneNum:(NSString *)phoneText {
    // 创建正则表达式
    NSString *telRegex = @"^1[3578]\\d{9}$";
    NSPredicate *prediate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telRegex];
    
    return [prediate evaluateWithObject:phoneText];
}

@end


















