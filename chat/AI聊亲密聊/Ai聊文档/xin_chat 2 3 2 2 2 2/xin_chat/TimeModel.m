
//
//  TimeModel.m
//  WeiXinChar
//
//  Created by guan song on 15/11/21.
//  Copyright (c) 2015年 guan song. All rights reserved.
//

#import "TimeModel.h"

@implementation TimeModel
#pragma mark  返回当前北京时间
+ (NSString *)tDate
{
    NSDate *date = [NSDate date];
    //设置时区
    NSDateFormatter  *formatter=[[NSDateFormatter  alloc]init];
    [formatter  setDateFormat:@"yyyyMMddhhmmss"];
    
    NSString  *strDate=[formatter  stringFromDate:date];
    
    return strDate;
}
+ (NSString *)getMonthDate
{
    NSDate *date = [NSDate date];
    //设置时区
    NSDateFormatter  *formatter=[[NSDateFormatter  alloc]init];
    [formatter  setDateFormat:@"MM-dd hh:mm"];
    
    NSString  *strDate=[formatter  stringFromDate:date];
    
    return strDate;
}
+(NSString *)getMsgDate:(NSDate *)date
{
    //设置时区
    NSDateFormatter  *formatter=[[NSDateFormatter  alloc]init];
    [formatter  setDateFormat:@"hh:mm:ss"];
    
    NSString  *strDate=[formatter  stringFromDate:date];
    
    return strDate;
}

@end
