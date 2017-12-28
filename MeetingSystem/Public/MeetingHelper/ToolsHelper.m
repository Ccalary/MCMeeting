//
//  ToolsHelper.m
//  MeetingSystem
//
//  Created by chh on 2017/12/22.
//  Copyright © 2017年 caohouhong. All rights reserved.
//

#import "ToolsHelper.h"

@implementation ToolsHelper
//如果想要判断设备是ipad，要用如下方法
+ (BOOL)getIsIpad
{
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType isEqualToString:@"iPhone"]) {
        //iPhone
        return NO;
    }
    else if([deviceType isEqualToString:@"iPod touch"]) {
        //iPod Touch
        return NO;
    }
    else if([deviceType isEqualToString:@"iPad"]) {
        //iPad
        return YES;
    }
    return NO;
}

#pragma mark - NSDate
//获得当前的时间
+ (NSString *)getCurrentTime{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置日期格式
    [formatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    NSDate *date = [NSDate date]; // 获得时间对象
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

//获得当前的时间戳
+ (double)getCurrentTimestamp{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0]; // 获得时间对象
    NSTimeInterval timestamp = [date timeIntervalSince1970];
    return timestamp;
}

//得到当前的时间戳 之前之后的日期-1 前一天 1 后一天
+ (double)getTimestampOffsetDay:(NSInteger)day{
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];//-1 前一年 1 后一年
    [adcomps setMonth:0];
    [adcomps setDay:day];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:nowDate options:0];
    NSTimeInterval timestamp = [newdate timeIntervalSince1970];
    return timestamp;
}
@end
