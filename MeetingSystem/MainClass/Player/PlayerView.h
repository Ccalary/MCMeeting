//
//  PlayerView.h
//  MeetingSystem
//
//  Created by chh on 2017/12/21.
//  Copyright © 2017年 caohouhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePlayerModel.h"
/** 手势状态 */
typedef NS_ENUM(NSUInteger, PlayerViewScaleState){
    /** 放大 */
    PlayerViewScaleStateZoomIn,
    /** 缩小 */
    PlayerViewScaleStateZoomOut,
};
/** 协议 */
@protocol PlayViewDelegate <NSObject>
/** 视频放大缩小 */
- (void)playViewScaleWithState:(PlayerViewScaleState)state type:(int)type;
/** 长按拖动 */
- (void)playViewLongPressWithGesture:(UILongPressGestureRecognizer *)gesture centerRect:(CGRect)rect type:(int)type;
@end


@interface PlayerView : UIView
@property (nonatomic, weak) id<PlayViewDelegate> delegate;
@property (nonatomic, strong) HomePlayerModel *playModel;
@property (nonatomic, strong) UIView *ijkPlayerView; //播放器View
- (instancetype)initWithFrame:(CGRect)frame url:(NSString *)url type:(int)type;
@end
