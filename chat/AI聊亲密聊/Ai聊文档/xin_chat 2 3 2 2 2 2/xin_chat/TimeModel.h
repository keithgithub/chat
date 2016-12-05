//
//  TimeModel.h
//  WeiXinChar
//
//  Created by guan song on 15/11/21.
//  Copyright (c) 2015年 guan song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeModel : NSObject
+ (NSString *)tDate;
+ (NSString *)getMonthDate;
+(NSString *)getMsgDate:(NSDate *)date;

@end
