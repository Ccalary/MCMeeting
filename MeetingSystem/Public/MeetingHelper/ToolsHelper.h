//
//  ToolsHelper.h
//  MeetingSystem
//
//  Created by chh on 2017/12/22.
//  Copyright © 2017年 caohouhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ToolsHelper : NSObject
/** 设备是否是iPad */
+ (BOOL)getIsIpad;

#pragma mark - NSDate
/** 获得当前的时间(yyyy.MM.dd HH:mm:ss) */
+ (NSString *)getCurrentTime;

/** 获得当前的时间戳 */
+ (double)getCurrentTimestamp;

/** 得到当前的之前之后的时间戳 (-1前一天 1后一天)*/
+ (double)getTimestampOffsetDay:(NSInteger)day;
@end
