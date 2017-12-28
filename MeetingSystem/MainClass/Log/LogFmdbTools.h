//
//  LogFmdbTools.h
//  MeetingSystem
//
//  Created by chh on 2017/12/27.
//  Copyright © 2017年 caohouhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogModel.h"
@interface LogFmdbTools : NSObject
+ (LogFmdbTools *)shareInstance;
/** 插入数据 */
- (void)insertModel:(LogModel *)model;

/**
 根据时间(时间戳)删除某一体数据
 @param condition 某一天的时间戳
 */
- (void)deleteDayDateWithCondition:(double)condition;

/** 数据查找 */
- (NSArray *)findAllData;
@end
