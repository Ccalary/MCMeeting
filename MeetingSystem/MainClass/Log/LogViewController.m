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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   
    NSArray *array = [[LogFmdbTools shareInstance] findAllData];
}

@end
