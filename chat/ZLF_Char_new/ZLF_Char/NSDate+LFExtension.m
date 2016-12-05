//
//  NSDate+LFExtension.m
//  ZLF_Char
//
//  Created by 郑卢峰 on 15/11/29.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "NSDate+LFExtension.h"

@implementation NSDate (LFExtension)

/**
 *  获取消息的时间
 *
 *  @param date 从XMPP消息对象中获取的事件date
 *
 *  @return 编辑过的时间
 */
+ (NSString *)getMsgDate:(NSDate *)date {
    //设置时区
    NSDateFormatter  *formatter=[[NSDateFormatter  alloc]init];
    [formatter  setDateFormat:@"HH:mm:ss"];
    
    NSString  *strDate=[formatter  stringFromDate:date];
    
    return strDate;
}

/**
 *  获取消息的时间(没有分隔)
 *
 *  @param date 从XMPP消息对象中获取的事件date
 *
 *  @return 编辑过的时间
 */
+ (NSString *)getMsgDateNotSeparate:(NSDate *)date {
    //设置时区
    NSDateFormatter  *formatter=[[NSDateFormatter  alloc]init];
    [formatter  setDateFormat:@"yyyyMMddHHmmss"];
    
    NSString  *strDate=[formatter  stringFromDate:date];
    
    return strDate;
}

/**
 *  获取当前时间
 */
+ (NSString *)getNowTime
{
    NSDate *date = [NSDate date];
    //设置时区
    NSDateFormatter  *formatter=[[NSDateFormatter  alloc]init];
    [formatter  setDateFormat:@"yyyyMMddHHmmss"];
    
    NSString  *strDate=[formatter  stringFromDate:date];
    
    return strDate;
}
@end
