//
//  FDSQLiftNormal.m
//  SQLift3
//
//  Created by asus on 16/7/11.
//  Copyright (c) 2016年 asus. All rights reserved.
//

#import "FDSQLiftNormal.h"
#import "FMDatabase.h"


@interface FDSQLiftNormal()

@property (nonatomic, strong) FMDatabase *database;

@end

@implementation FDSQLiftNormal

- (FMDatabase *)database
{
    if (!_database) {
        
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        path = [path stringByAppendingPathComponent:@"sql.db"];   //这里不能拼接带有新建文件夹的路径，这样子会导致无法创建数据库
        _database = [FMDatabase databaseWithPath:path];  //有数据库就连接，没有就创建
        
    }
    
    return _database;
}

- (void)databaseCreateTable
{
   
    if ([self.database open]) {
        
        NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ (%@ integer primary key autoincrement, %@ text, %@ integet)", kTableName, kID, kName, kAge];
        
        [self.database executeUpdate:sql];
    }
    
    [self.database close];
}


- (void)databaseInsertWithName:(NSString *)name age:(NSInteger )age
{
    if ([self.database open]) {
        NSString *sql = [NSString stringWithFormat:@"insert into %@ (%@, %@) values ('%@', '%ld')", kTableName, kName, kAge, name, (long)age];
       
        [self.database executeUpdate:sql];
    }
    
    [self.database close];
}

- (NSArray *)databaseSelectWithStart:(NSInteger )startID end:(NSInteger )endID
{
    NSMutableArray *arrayM = [NSMutableArray array];
    
    if ([self.database open]) {
        
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@>=%ld and %@<%ld ", kTableName, kID, startID, kID, endID];
        FMResultSet *results = [self.database executeQuery:sql];
        
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
    }
    
    [self.database close];
    
    return [NSArray arrayWithArray:arrayM];
}



@end
