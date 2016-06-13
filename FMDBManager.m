//
//  FMDBManager.m
//  19UILessonFMDB
//
//  Created by 蒋晨成 on 16/4/29.
//  Copyright © 2016年 蒋晨成. All rights reserved.
//

#import "FMDBManager.h"
#import <FMDB.h>
@interface FMDBManager ()



@end

// 相当于我们之前sqlite3 *指针 用于链接沙盒中数据库的地址
static FMDatabase *db = nil;

@implementation FMDBManager


#pragma mark --- 单例 ---
+ (FMDBManager *)shareInstance {
    static FMDBManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FMDBManager alloc] init];
    });
    return manager;
    
}

#pragma mark --- 打开数据库 ---
- (void)openDB {
    
    if (db != nil) {
        return;
    }
    
    NSString *filePath = [self createSqliteWithSqliteName:@"FMDB.sqlite"];
    NSLog(@"filePath ==== %@", filePath);
    db = [FMDatabase databaseWithPath:filePath];
    if ([db open]) {
        NSLog(@"打开数据库成功");
    }else {
        NSLog(@"打开数据库失败");
    }
}

#pragma mark --- 设置数据库路径 ---
- (NSString *)createSqliteWithSqliteName:(NSString *)sqliteName {
    return [[NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:sqliteName];
}

#pragma  mark --- 在数据库中创建表 ---
- (void)createTableWithTableName:(NSString *)tableName {
    // 1、打开数据库
    [db open];
    // 2、创建sql语句
    NSString *sqlString = [NSString stringWithFormat:@"create table if not exists %@ (ID integer primary key autoincrement, name text, gender text, age integer, image blob, myID integer)", tableName];
    // 3、执行命令
    BOOL flag = [db executeUpdate:sqlString];
    NSLog(@"flag == %d", flag);
    [db close];
}


#pragma mark --- 在指定的表中插入数据 ---
- (void)insertDataWithTableName:(NSString *)tableName name:(NSString *)name gender:(NSString *)gender age:(NSInteger)age image:(UIImage *)image myID:(NSString *)myID {
    [db open];
    NSString *sqlString = [NSString stringWithFormat:@"insert into %@ (name, gender, age, image, myID) values (?, ?, ?, ?, ?)", tableName];
    
    // 不支持传入非对象类型参数
    // 如果是UIImage 如果直接传入image 会是以data形式存储，如果用UIImagePNGRepresentation 在数据库内部能够直观的看到图片
    BOOL flag = [db executeUpdate:sqlString, name, gender, @(age), image, myID];
    NSLog(@"flag === %d", flag);
    [db close];
}

#pragma mark --- 在指定的表中删除数据 ---
- (void)deleteDataWithTableName:(NSString *)tableName forMyID:(NSString *)myID {
    [db open];
    NSString *string = [NSString stringWithFormat:@"delete from %@ where myID = ?", tableName];
    
   
    BOOL flag = [db executeUpdate:string, myID];
    NSLog(@"flag === %d", flag);
    [db close];
}


#pragma mark --- 在指定的表中修改数据 ---
- (void)updateDataWithTableName:(NSString *)tableName name:(NSString *)name gender:(NSString *)gender age:(NSInteger)age image:(UIImage *)image myID:(NSString *)myID forMyID:(NSString *)forMyID {
    [db open];
    NSString *sqlString = [NSString stringWithFormat:@"update %@ set name = ?, gender = ?, age = ?, image = ?, myID = ? where myID = ?",tableName];
    BOOL flag = [db executeUpdate:sqlString, name, gender, @(age), image, myID, forMyID];
    NSLog(@"flag == %d", flag);
    [db close];

}

#pragma mark --- 在指定的表中查询一条数据
- (Model *)selectOneDataWithTableName:(NSString *)tableName forMyID:(NSString *)myID {
    [db open];
    NSString *sqlString = [NSString stringWithFormat:@"select * from %@ where myID = ?", tableName];
    
    FMResultSet *result = [db executeQuery:sqlString, myID];
    Model *model = [[Model alloc] init];
    while ([result next]) {
        model.name = [result stringForColumn:@"name"];
        model.gender = [result stringForColumn:@"gender"];
        model.age =  [[result stringForColumn:@"age"] integerValue];
        model.image = [result dataForColumn:@"image"];
        model.myID = [result stringForColumn:@"myID"];
    }
    return model;
}


#pragma mark --- 在指定的表中查询所有数据
- (NSArray *)selectOneDataWithTableName:(NSString *)tableName {
    [db open];
    NSString *sqlString = [NSString stringWithFormat:@"select * from %@", tableName];
    FMResultSet *result = [db executeQuery:sqlString];
    NSMutableArray *array = [NSMutableArray array];
    while ([result next]) {
        Model *model = [[Model alloc] init];
        model.name = [result stringForColumn:@"name"];
        model.gender = [result stringForColumn:@"gender"];
        model.age =  [[result stringForColumn:@"age"] integerValue];
        model.image = [result dataForColumn:@"image"];
        model.myID = [result stringForColumn:@"myID"];
        [array addObject:model];
    }
    return array;
}

@end
