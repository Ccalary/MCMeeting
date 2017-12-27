//
//  LogModel.m
//  MeetingSystem
//
//  Created by chh on 2017/12/27.
//  Copyright © 2017年 caohouhong. All rights reserved.
//

#import "LogModel.h"
#import "ToolsHelper.h"

@implementation LogModel
- (instancetype)init{
    if (self = [super init]){
        self.time = [ToolsHelper getCurrentTime];
    }
    return self;
}
@end
