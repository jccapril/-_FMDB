//
//  FMDBManager.h
//  19UILessonFMDB
//
//  Created by 蒋晨成 on 16/4/29.
//  Copyright © 2016年 蒋晨成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Model.h"

@interface FMDBManager : NSObject
+ (FMDBManager *)shareInstance;
// 打开数据库
- (void)openDB;
#pragma  mark --- 在数据库中创建表 ---
- (void)createTableWithTableName:(NSString *)tableName;

#pragma mark --- 在指定的表中插入数据 ---
- (void)insertDataWithTableName:(NSString *)tableName name:(NSString *)name gender:(NSString *)gender age:(NSInteger)age image:(UIImage *)image myID:(NSString *)myID;

#pragma mark --- 在指定的表中删除数据 ---
- (void)deleteDataWithTableName:(NSString *)tableName forMyID:(NSString *)myID;

#pragma mark --- 在指定的表中修改数据 --- 
- (void)updateDataWithTableName:(NSString *)tableName name:(NSString *)name gender:(NSString *)gender age:(NSInteger)age image:(UIImage *)image myID:(NSString *)myID forMyID:(NSString *)forMyID;

#pragma mark --- 在指定的表中查询一条数据
- (Model *)selectOneDataWithTableName:(NSString *)tableName forMyID:(NSString *)myID;
#pragma mark --- 在指定的表中查询所有数据
- (NSArray *)selectOneDataWithTableName:(NSString *)tableName;

@end
