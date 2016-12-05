//
//  LFSQLTool.m
//  电商页面跳转导航栏部分
//
//  Created by ibokan on 15/11/18.
//  Copyright (c) 2015年 zlf. All rights reserved.
//

#import "LFSQLTool.h"
#import "FMDB.h"

@interface LFSQLTool()
@end

@implementation LFSQLTool

static FMDatabase *_db;

/**
 *  获取沙盒路径(没有文件就从配置文件复制过去)
 *
 *  @param sqlName 文件名
 *
 *  @return 沙盒路径
 */
+ (NSString *)copySqlite:(NSString *)sqlName {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:sqlName];

    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:path]) {
        return path;
    } else {
        NSString *oldPath = [[NSBundle mainBundle] pathForResource:sqlName ofType:nil];
        [manager copyItemAtPath:oldPath toPath:path error:nil];
        
        return path;
    }
}

+ (void)open:(NSString *)sqlName {
    // 打开数据库
    NSString *path = [self copySqlite:sqlName];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
}

+ (NSMutableArray *)infos:(NSString *)str {
    // 得到结果集
    FMResultSet *set = [_db executeQuery:str];
    NSMutableArray *infos = [NSMutableArray new];
    while (set.next) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"id"] = [set stringForColumn:@"id"];
        dict[@"name"] = [set stringForColumn:@"name"];
        dict[@"pid"] = [set stringForColumn:@"pid"];
        [infos addObject:dict];
    }
    
    return infos;
}

@end







