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
        self.timestamp = [ToolsHelper getCurrentTimestamp];
        self.time = [ToolsHelper getCurrentTime];
    }
    return self;
}
//打印model
- (NSString *)description{
    
    return [NSString stringWithFormat:@"\ntimestamp:%f\ntime:%@\nroomNo:%@\noperatorId:%@\ncontent:%@\nresult:%d\n",self.timestamp,self.time,self.roomNo,self.operatorId,self.content,self.result];
}
@end
