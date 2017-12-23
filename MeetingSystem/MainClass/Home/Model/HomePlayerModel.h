//
//  HomePlayerModel.h
//  MeetingSystem
//
//  Created by chh on 2017/12/22.
//  Copyright © 2017年 caohouhong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PlayerView;
@interface HomePlayerModel : NSObject
/** 播放器 */
@property (nonatomic, strong) PlayerView *playView;
/** 是否大窗口*/
@property (nonatomic, assign, getter=isBig) BOOL big;
/** view的布局 */
@property (nonatomic, assign) CGRect frame;
/** 标签 */
@property (nonatomic, assign) int type;
@end
