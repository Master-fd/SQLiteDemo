//
//  FDSQLiftMTS.h
//  SQLift3
//
//  Created by asus on 16/7/12.
//  Copyright (c) 2016年 asus. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kName       @"name"
#define kAge        @"age"
#define kTableName  @"student"
#define kID         @"ID"


typedef void(^didSelectBlock)(NSArray *data);


@interface FDSQLiftMTS : NSObject



/**
 *  创建表
 */
- (BOOL)databaseCreateTable;

/**
 *  插入数据
 */
- (void)databaseInsertWithName:(NSString *)name age:(NSInteger )age;

/**
 *  读取数据
 */
- (void)databaseSelectWithStart:(NSInteger )startID end:(NSInteger )endID didSelectBlock:(didSelectBlock )didBlock;

@end
