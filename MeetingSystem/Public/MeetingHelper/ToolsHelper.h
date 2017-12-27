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

/** 获得当前的时间 */
+ (NSString *)getCurrentTime;
@end
