//
//  LogFmdbTools.m
//  MeetingSystem
//
//  Created by chh on 2017/12/27.
//  Copyright © 2017年 caohouhong. All rights reserved.
//

#import "LogFmdbTools.h"
#import <FMDB/FMDB.h>

#define kOperatorSqlite  @"opetator.sqlite" //数据库名字
#define kOperatorLogInfo @"operatorLogInfo" //操作日志信息（表名）
@interface LogFmdbTools()
{
    FMDatabase *fmdb;
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
    }
    return self;
}
#pragma mark - FMDB创建数据库
- (void)fmdbCreate{
    //1.获得数据库文件的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    //和上面那个路径相同
    //    NSString *str = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
    NSString *fileName = [doc stringByAppendingPathComponent:kOperatorSqlite];
    
    //2.数据库打开、创建
    fmdb = [FMDatabase databaseWithPath:fileName];
}

#pragma mark - FMDB创建表
- (void)fmdbTableCreate{
    
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT, time TEXT NOT NULL, roomNo TEXT NOT NULL, operatorId TEXT NOT NULL, content TEXT NOT NULL, result INTEGER NOT NULL);",kOperatorLogInfo];
    
    [self fmdbExecuteUpdate:sql];
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
                     @"INSERT INTO '%@' ('time', 'roomNo', 'operatorId', 'content', 'result') VALUES ('%@', '%@', '%@', '%@','%d');",kOperatorLogInfo, model.time, model.roomNo, model.operatorId, model.content, model.result];
    [self fmdbExecuteUpdate:sql];
}

#pragma mark - FMDB删除数据
- (void)deleteData{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE age='18'",kOperatorLogInfo];
    [self fmdbExecuteUpdate:sql];
}
#pragma mark - FMDB更改数据
- (void)updateData{
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET age='%@' WHERE name='张三'",kOperatorLogInfo,@"18"];
    [self fmdbExecuteUpdate:sql];
}

#pragma mark - FMDB查找数据
- (NSArray *)selectData{
    NSString *sqlSelect = [NSString stringWithFormat:@"SELECT * FROM %@",kOperatorLogInfo];
    //根据条件查询
    FMResultSet *resultSet = [fmdb  executeQuery:sqlSelect];
    NSMutableArray *mArray = [NSMutableArray array];
    //遍历结果
    while ([resultSet next]) {
        NSString *time = [resultSet objectForColumn:@"time"];
        NSString *roomNo = [resultSet objectForColumn:@"roomNo"];
        NSString *operatorId = [resultSet objectForColumn:@"operatorId"];
        NSString *content = [resultSet objectForColumn:@"content"];
        int result = [resultSet intForColumn:@"result"];
        DLog(@"time:%@--content:%@",time,content);
        LogModel *model = [[LogModel alloc] init];
        model.time = time;
        model.roomNo = roomNo;
        model.operatorId = operatorId;
        model.content = content;
        model.result = result;
        [mArray addObject:model];
    }
    return mArray;
}

@end
