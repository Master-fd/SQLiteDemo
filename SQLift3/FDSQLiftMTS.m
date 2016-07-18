//
//  FDSQLiftMTS.m
//  SQLift3
//
//  Created by asus on 16/7/12.
//  Copyright (c) 2016年 asus. All rights reserved.
//

#import "FDSQLiftMTS.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
/**
 *  多线程模式
 */
@interface FDSQLiftMTS()

@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;


@end


@implementation FDSQLiftMTS


- (FMDatabaseQueue *)databaseQueue
{
    if (!_databaseQueue) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        path = [path stringByAppendingPathComponent:@"sqlMTS.db"];
        
        _databaseQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    }
    
    return _databaseQueue;
}
- (void)dealloc
{
    NSLog(@"dealloc");
}
/**
 *  创建表
 */
- (BOOL)databaseCreateTable
{
    __weak typeof(self) _weakSelf = self;
    __block BOOL result = NO;
    
    //需要使用同步，返回才有效,如果是异步，直接就返回了
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __strong typeof(_weakSelf) _strongSelf = _weakSelf;   //必须加入strong，反正代码会崩溃
        [_strongSelf.databaseQueue inDatabase:^(FMDatabase *db) {
            //执行代码
            NSString *sql = [NSString stringWithFormat:@"create table if not exists %@(%@ integer primary key autoincrement, %@ text, %@ integer)  ", kTableName, kID, kName, kAge];
            if ([db executeUpdate:sql]) {
                result = YES;
                NSLog(@"create table OK");
            }
        }];
    });
    
    return result;
}

/**
 *  插入数据
 */
- (void)databaseInsertWithName:(NSString *)name age:(NSInteger )age
{
    __weak typeof(self) _weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        __strong typeof(_weakSelf) _strongSelf = _weakSelf;
        [_strongSelf.databaseQueue inDatabase:^(FMDatabase *db) {
            NSString *sql = [NSString stringWithFormat:@"insert into %@ (%@, %@) values ('%@', '%ld')", kTableName, kName, kAge, name, (long)age];
            [db executeUpdate:sql];
            NSLog(@"insert");
        }];
    });
}

/**
 *  读取数据
 */
- (void)databaseSelectWithStart:(NSInteger )startID end:(NSInteger )endID didSelectBlock:(didSelectBlock )didBlock
{
    __weak typeof(self) _weakSelf = self;
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        __strong typeof(_weakSelf) _strongSelf = _weakSelf;
        [_strongSelf.databaseQueue inDatabase:^(FMDatabase *db) {
            NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@>=%d and %@<%d", kTableName, kID, startID, kID, endID];
            FMResultSet *results = [db executeQuery:sql];
            NSMutableArray *arrayM = [NSMutableArray array];
            
            while ([results next]) {
                @autoreleasepool {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    int ID = [results intForColumn:kID];
                    NSString *name = [results stringForColumn:kName];
                    int age = [results intForColumn:kAge];
                    
                    [dict setObject:[NSNumber numberWithInt:ID] forKey:kID];
                    [dict setObject:name forKey:kName];
                    [dict setObject:[NSNumber numberWithInt:age] forKey:kAge];
              
                    [arrayM addObject:dict];
                }
            }
            
            if (didBlock) {
                didBlock([NSArray arrayWithArray:arrayM]);
            }
        }];
        
    });
    
}

@end












