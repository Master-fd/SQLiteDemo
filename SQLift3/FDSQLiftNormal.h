//
//  FDSQLiftNormal.h
//  SQLift3
//
//  Created by asus on 16/7/11.
//  Copyright (c) 2016年 asus. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kName       @"name"
#define kAge        @"age"
#define kTableName  @"student"
#define kID         @"ID"


@interface FDSQLiftNormal : NSObject



/**
 *  创建表
 */
- (void)databaseCreateTable;

/**
 *  插入数据
 */
- (void)databaseInsertWithName:(NSString *)name age:(NSInteger )age;

/**
 *  读取数据
 */
- (NSArray *)databaseSelectWithStart:(NSInteger )startID end:(NSInteger )endID;

@end
