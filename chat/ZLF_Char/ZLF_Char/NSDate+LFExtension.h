//
//  NSDate+LFExtension.h
//  ZLF_Char
//
//  Created by 郑卢峰 on 15/11/29.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LFExtension)

/**
 *  获取消息的时间
 *
 *  @param date 从XMPP消息对象中获取的事件date
 *
 *  @return 编辑过的时间
 */
+(NSString *)getMsgDate:(NSDate *)date;

/**
 *  获取当前的时间
 */
+ (NSString *)getNowTime;

/**
 *  获取消息的时间(没有分隔)
 *
 *  @param date 从XMPP消息对象中获取的事件date
 *
 *  @return 编辑过的时间
 */
+ (NSString *)getMsgDateNotSeparate:(NSDate *)date;
@end
