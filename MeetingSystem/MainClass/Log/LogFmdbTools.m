//
//  LogFmdbTools.m
//  MeetingSystem
//
//  Created by chh on 2017/12/27.
//  Copyright © 2017年 caohouhong. All rights reserved.
//

#import "LogFmdbTools.h"
#import <FMDB/FMDB.h>
#import "Migration.h"
#import "ToolsHelper.h"

#define kOperatorSqlite  @"opetator.sqlite" //数据库名字
#define kOperatorLogInfo @"operatorLogInfo" //操作日志信息（表名）
@interface LogFmdbTools()
{
    FMDatabase *fmdb;
    NSString *path;
}
@end

@implementation LogFmdbTools
+ (LogFmdbTools *)shareInstance{
    static LogFmdbTools *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[LogFmdbTools alloc] init];
    });
    return shareInstance;
}

- (instancetype)init{
    if (self = [super init]){
        [self fmdbCreate];
        [self fmdbTableCreate];
        [self updateFMDB];
        //数据保留一周，一周以上的数据删除
        [self deleteDayDateWithCondition:[ToolsHelper getTimestampOffsetDay:-7]];
    }
    return self;
}
#pragma mark - FMDB创建数据库
- (void)fmdbCreate{
    //1.获得数据库文件的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    //和上面那个路径相同
    //    NSString *str = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
    path = [doc stringByAppendingPathComponent:kOperatorSqlite];
    
    //2.数据库打开、创建
    fmdb = [FMDatabase databaseWithPath:path];
}

#pragma mark - FMDB创建表
- (void)fmdbTableCreate{
    
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT,timestamp REAL, time TEXT NOT NULL, roomNo TEXT NOT NULL, operatorId TEXT NOT NULL, content TEXT NOT NULL, result INTEGER NOT NULL);",kOperatorLogInfo];
    
    [self fmdbExecuteUpdate:sql];
}

#pragma mark - 检查数据库更新
- (void)updateFMDB{
    
    FMDBMigrationManager *manager=[FMDBMigrationManager managerWithDatabaseAtPath:path migrationsBundle:[NSBundle mainBundle]];
//    Migration * migration_1=[[Migration alloc]initWithName:[NSString stringWithFormat:@"%@表新增字段dayTime",kOperatorLogInfo] andVersion:1 andExecuteUpdateArray:@[[NSString stringWithFormat:@"ALTER TABLE %@ ADD dayTime TEXT",kOperatorLogInfo]]];//给表添加dayTime字段
//    
//    [manager addMigration:migration_1];
    
    BOOL resultState=NO;
    NSError * error=nil;
    if (!manager.hasMigrationsTable) {
        resultState=[manager createMigrationsTable:&error];
    }
    resultState=[manager migrateDatabaseToVersion:UINT64_MAX progress:nil error:&error];
    
}

//更新操作
- (void)fmdbExecuteUpdate:(NSString *)sql{
    if ([fmdb open]){
        /*
         * 只要sql不是SELECT命令的都视为更新操作(使用executeUpdate方法)。就包括 CREAT,UPDATE,INSERT,ALTER,BEGIN,COMMIT,DETACH,DELETE,DROP,END,EXPLAIN,VACUUM,REPLACE等等。SELECT命令的话，使用executeQuery方法。
         * 执行更新返回一个BOOL值。YES表示 执行成功，否则表示有错误。你可以调用 -lastErrorMessage 和 -lastErrorCode方法来得到更多信息。
         */
        if ([fmdb executeUpdate:sql]){
            DLog(@"fmdb操作表%@成功！",kOperatorLogInfo);
        }else{
            DLog(@"fmdb%@创建失败！ lastErrorMessage：%@，lastErrorCode：%d",kOperatorLogInfo,fmdb.lastErrorMessage,fmdb.lastErrorCode);
        }
    }else{
        DLog(@"fmdb数据库打开失败！");
    }
}

#pragma mark - FMDB增加数据
- (void)insertModel:(LogModel *)model{
    NSString *sql = [NSString stringWithFormat:
                     @"INSERT INTO '%@' ('time', 'timestamp', 'roomNo', 'operatorId', 'content', 'result') VALUES ('%@', '%f' ,'%@', '%@', '%@','%d');",kOperatorLogInfo, model.time, model.timestamp, model.roomNo, model.operatorId, model.content, model.result];
    [self fmdbExecuteUpdate:sql];
}

#pragma mark - FMDB删除数据
//根据时间删除数据
- (void)deleteDayDateWithCondition:(double)condition{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE timestamp<='%f'",kOperatorLogInfo,condition];
    [self fmdbExecuteUpdate:sql];
}
#pragma mark - FMDB更改数据
- (void)updateData{
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET age='%@' WHERE name='张三'",kOperatorLogInfo,@"18"];
    [self fmdbExecuteUpdate:sql];
}

#pragma mark - FMDB查找数据
- (NSArray *)findAllData{
    NSString *sqlSelect = [NSString stringWithFormat:@"SELECT * FROM %@",kOperatorLogInfo];
    //根据条件查询
    FMResultSet *resultSet = [fmdb  executeQuery:sqlSelect];
    NSMutableArray *mArray = [NSMutableArray array];
    //遍历结果
    while ([resultSet next]) {
        double timestamp = [resultSet doubleForColumn:@"timestamp"];
        NSString *time = [resultSet objectForColumn:@"time"];
        NSString *roomNo = [resultSet objectForColumn:@"roomNo"];
        NSString *operatorId = [resultSet objectForColumn:@"operatorId"];
        NSString *content = [resultSet objectForColumn:@"content"];
        int result = [resultSet intForColumn:@"result"];
        LogModel *model = [[LogModel alloc] init];
        model.time = time;
        model.timestamp = timestamp;
        model.roomNo = roomNo;
        model.operatorId = operatorId;
        model.content = content;
        model.result = result;
        [mArray addObject:model];
        NSLog(@"%@",model);
    }
    return mArray;
}

@end
