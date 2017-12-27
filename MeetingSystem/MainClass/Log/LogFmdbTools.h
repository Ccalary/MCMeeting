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
/** 数据查找 */
- (NSArray *)selectData;
@end
