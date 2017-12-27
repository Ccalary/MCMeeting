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

//获得当前的时间
+ (NSString *)getCurrentTime{
    //时间格式
    //实例化一个NSDateFormatter对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置日期格式
    [formatter setDateFormat:@"yyyy.MM.dd hh:MM:ss"];
    NSDate *date = [NSDate date]; // 获得时间对象
    NSTimeZone *zone = [NSTimeZone systemTimeZone]; // 获得系统的时区
    NSTimeInterval time = [zone secondsFromGMTForDate:date];// 以秒为单位返回当前时间与系统格林尼治时间的差
    NSDate *dateNow = [date dateByAddingTimeInterval:time];// 然后把差的
    //将时间转化为当前时区当前样式
    NSString *dateStr = [formatter stringFromDate:dateNow];
    return dateStr;
}
@end
