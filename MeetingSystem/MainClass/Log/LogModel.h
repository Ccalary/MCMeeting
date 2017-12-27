//
//  LogModel.h
//  MeetingSystem
//
//  Created by chh on 2017/12/27.
//  Copyright © 2017年 caohouhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogModel : NSObject
/** 操作时间 */
@property (nonatomic, copy) NSString *time;
/** 房间号 */
@property (nonatomic, copy) NSString *roomNo;
/** 操作员 */
@property (nonatomic, copy) NSString *operatorId;
/** 操作内容 */
@property (nonatomic, copy) NSString *content;
/** 操作结果 0-失败 1-成功*/
@property (nonatomic, assign) int result;
@end
