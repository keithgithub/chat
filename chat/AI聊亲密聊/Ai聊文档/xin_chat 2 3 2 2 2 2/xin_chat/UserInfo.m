//
//  UserInfo.m
//  WeiXinChar
//
//  Created by guan song on 15/11/24.
//  Copyright (c) 2015年 guan song. All rights reserved.
//

#import "UserInfo.h"

#define UserKey @"user"
#define LoginStatusKey @"LoginStatus"
#define PwdKey @"pwd"
#define SaveStatusKey @"saveStatus"


//单例对象
static  UserInfo *user=nil;


@implementation UserInfo
/**
 *  实现单例类方法
 *
 *  @return 对象
 */
+(instancetype)shareUser
{
    if (user==nil)
    {
        user=[[UserInfo  alloc]init];
    }
    return user;
}


+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    //只执行一次，多用在类方法中用来返回一个单例
    static  dispatch_once_t  onceToken;
    //该函数接收一个dispatch_once用于检查该代码块是否已经被调度
    //dispatch_once不仅意味着代码仅会被运行一次，而且还是线程安全的
    dispatch_once(&onceToken, ^{
        user=[super  allocWithZone:zone];
    });
    return user;
}
//保存
-(void)saveUserInfoToSanbox
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.loginName forKey:UserKey];
    [defaults setBool:self.loginStatus forKey:LoginStatusKey];
    [defaults setObject:self.loginPwd forKey:PwdKey];
    [defaults setBool:self.SaveStatus forKey:SaveStatusKey];
    [defaults synchronize];
    
}
//读取
-(void)loadUserInfoFromSenbox{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.loginName = [defaults objectForKey:UserKey];
    self.loginStatus = [defaults boolForKey:LoginStatusKey];
    self.loginPwd = [defaults objectForKey:PwdKey];
    self.SaveStatus = [[defaults objectForKey:SaveStatusKey]  boolValue];
}

// 聊天好友名字  保存到沙盒
+ (void)nearestFriend:(NSString *)name {
    // 获取沙盒存储
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([def objectForKey:@"newFriendMessage"]) { // 如果数据已存在
        // 取出原来的数组
        NSMutableArray *mArray = [[def objectForKey:@"newFriendMessage"] mutableCopy];
        if ([mArray containsObject:name]) { // 如果这个用户已经存到沙盒
            // 移到数组最前
            [mArray exchangeObjectAtIndex:[mArray indexOfObject:name] withObjectAtIndex:0];
        } else {
            // 添加数据并插入到第一个位置
            [mArray insertObject:name atIndex:0];
        }
        // 写入沙盒
        [def setObject:mArray forKey:@"newFriendMessage"];
    } else { // 数据还没被创建
        // 创建新的可变数组
        NSMutableArray *mArray = [NSMutableArray new];
        // 添加数据
        [mArray addObject:name];
        // 写入沙盒
        [def setObject:mArray forKey:@"newFriendMessage"];
    }
}

// 获取本地存储的好友信息
+ (NSMutableDictionary*)getFriendInforFromSanBoxAndKey:(NSString*)key
{
    // 获取沙盒存储
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *friendInfo = [NSString stringWithFormat:@"%@_friendInfo",[UserInfo shareUser].loginName];
    // 取出本账号所有好友信息
  
    NSDictionary *dic = [def objectForKey:friendInfo];
    
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    // 取出指定好友所有信息
    NSMutableDictionary *mDic_f = [NSMutableDictionary dictionaryWithDictionary:mDic[key]];
    
    
    return mDic_f;
}

+ (void)SaveFriendInforToSanBox:(NSMutableDictionary*)dic andName:(NSString*)name;
{
    // 获取沙盒存储
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *friendInfo = [NSString stringWithFormat:@"%@_friendInfo",[UserInfo shareUser].loginName];
    // 取出本账号所有好友信息
    NSDictionary *dic_qu = [def objectForKey:friendInfo];
    
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:dic_qu];
    
    if (mDic.count == 0)
    {
      [mDic setObject:dic forKey:name];
 
    }
    else
    {
        // 替换掉好友信息
        [mDic removeObjectForKey:name];
        [mDic setObject:dic forKey:name];
        
    }
   
    NSDictionary *dic_user = [NSDictionary dictionaryWithDictionary:mDic];
    
    NSLog(@"---------%@",friendInfo);
    // 保存到沙盒
    //[def removeObjectForKey:friendInfo];
    [def setObject:dic_user forKey:friendInfo];
    
}



@end
