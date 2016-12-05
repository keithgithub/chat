//
//  LFSQLTool.h
//  电商页面跳转导航栏部分
//
//  Created by ibokan on 15/11/18.
//  Copyright (c) 2015年 zlf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LFSQLTool : NSObject

+ (void)open:(NSString *)sqlName;
+ (NSMutableArray *)infos:(NSString *)str;

@end
