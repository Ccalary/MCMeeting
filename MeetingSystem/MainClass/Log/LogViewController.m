//
//  LogViewController.m
//  MeetingSystem
//
//  Created by chh on 2017/12/27.
//  Copyright © 2017年 caohouhong. All rights reserved.
//

#import "LogViewController.h"
#import "LogModel.h"
#import <FMDB/FMDB.h>
#import "LogFmdbTools.h"
#import "ToolsHelper.h"
#define KTBUserInfo @"userInfo"//用户信息表

@interface LogViewController ()
{
    FMDatabase *fmdb;
}
@end

@implementation LogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self fmdbTest];
    LogFmdbTools *tools = [LogFmdbTools shareInstance];
    LogModel *model = [[LogModel alloc] init];
    model.operatorId = @"00000";
    model.roomNo = @"1000";
    model.content = @"操作成功";
    model.result = 1;
    [tools insertModel:model];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)fmdbTest{
    [self fmdbCreate];
    [self fmdbTableCreate];
    [self fmdbInsertData];
    [self fmdbSelectData];
}
#pragma mark - FMDB创建数据库
- (void)fmdbCreate{
    //1.获得数据库文件的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    //和上面那个路径相同
    //    NSString *str = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
    NSString *fileName = [doc stringByAppendingPathComponent:@"testFMDB.sqlite"];
    
    //2.数据库打开、创建
    fmdb = [FMDatabase databaseWithPath:fileName];
    
}
#pragma mark - FMDB创建表
- (void)fmdbTableCreate{
    
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR, age INTEGER, weigth INTEGER, sex INTEGER, phoneNum VARCHAR);",KTBUserInfo];
    
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
            NSLog(@"fmdb操作表%@成功！",KTBUserInfo);
        }else{
            NSLog(@"%@%@%@ lastErrorMessage：%@，lastErrorCode：%d",@"fmdb创建",KTBUserInfo,@"失败！",fmdb.lastErrorMessage,fmdb.lastErrorCode);
        }
    }else{
        NSLog(@"fmdb数据库打开失败！");
    }
}

#pragma mark - FMDB增加数据
- (void)fmdbInsertData{
    NSString *sql = [NSString stringWithFormat:
                     @"INSERT INTO '%@' ('name', 'age', 'weigth', 'sex', 'phoneNum') VALUES ('%@', '%@', '%@', '%@','%@');",KTBUserInfo, @"张三", @"23", @"100", @"1",@"18875022022"];
    [self fmdbExecuteUpdate:sql];
}
#pragma mark - FMDB删除数据
- (void)fmdbDeleteData{
    NSString *sql = [NSString stringWithFormat:@"DELETE from %@ Where age='18'",KTBUserInfo];
    [self fmdbExecuteUpdate:sql];
}
#pragma mark - FMDB更改数据
- (void)fmdbUpdateData{
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ set age='%@' WHERE name='张三'",KTBUserInfo,@"18"];
    [self fmdbExecuteUpdate:sql];
}
#pragma mark - FMDB查找数据
- (void)fmdbSelectData{
    NSString *sqlSelect = [NSString stringWithFormat:@"SELECT * FROM %@",KTBUserInfo];
    //根据条件查询
    FMResultSet *resultSet = [fmdb  executeQuery:sqlSelect];
    //遍历结果
    while ([resultSet next]) {
        NSString *name = [resultSet objectForColumn:@"name"];
        int age = [resultSet intForColumn:@"age"];
        int weigth = [resultSet intForColumn:@"weigth"];
        int sex = [resultSet intForColumn:@"sex"];
        NSString *phoneNum = [resultSet objectForColumn:@"phoneNum"];
        NSLog(@"name:%@-age:%d-weigth:%d-sex:%d-phoneNum:%@",name,age,weigth,sex,phoneNum);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self fmdbUpdateData];
//    [self fmdbSelectData];
    NSArray *array = [[LogFmdbTools shareInstance] selectData];
}

@end
