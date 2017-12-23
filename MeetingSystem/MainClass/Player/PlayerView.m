//
//  PlayerView.m
//  MeetingSystem
//
//  Created by chh on 2017/12/21.
//  Copyright © 2017年 caohouhong. All rights reserved.
//

#import "PlayerView.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
@interface PlayerView()
{
    CGPoint startPoint;
    CGPoint originPoint;
}
@property (nonatomic, strong) IJKFFMoviePlayerController *ijkPlayer; //播放器
@property (nonatomic, strong) NSString *urlStr; //播放地址
@property (nonatomic, assign) int type; //编号
@end
@implementation PlayerView
- (instancetype)initWithFrame:(CGRect)frame url:(NSString *)url type:(int)type{
    if (self = [super initWithFrame:frame]){
        self.urlStr = url;
        self.type = type;
        [self initView];
    }
    return self;
}

- (void)initView{
    self.backgroundColor = [UIColor blackColor];
    
    //调整参数
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    //静音设置(1静音)
    [options setPlayerOptionValue:@"1" forKey:@"an"];
    // 帧速率(fps) （可以改，确认非标准桢率会导致音画不同步，所以只能设定为15或者29.97）
    [options setPlayerOptionIntValue:29.97 forKey:@"r"];
    // -vol——设置音量大小，256为标准音量。（要设置成两倍音量时则输入512，依此类推）
    [options setPlayerOptionIntValue:512 forKey:@"vol"];
    [options setPlayerOptionIntValue:30  forKey:@"max-fps"];
    //跳帧开关
    [options setPlayerOptionIntValue:1  forKey:@"framedrop"];
    [options setPlayerOptionIntValue:0  forKey:@"start-on-prepared"];
    [options setPlayerOptionIntValue:0  forKey:@"http-detect-range-support"];
    [options setPlayerOptionIntValue:48  forKey:@"skip_loop_filter"];
    [options setPlayerOptionIntValue:0  forKey:@"packet-buffering"];
    [options setPlayerOptionIntValue:2000000 forKey:@"analyzeduration"];
    [options setPlayerOptionIntValue:25  forKey:@"min-frames"];
    [options setPlayerOptionIntValue:1  forKey:@"start-on-prepared"];
    [options setCodecOptionIntValue:8 forKey:@"skip_frame"];
    [options setFormatOptionValue:@"nobuffer" forKey:@"fflags"];
    [options setFormatOptionValue:@"8192" forKey:@"probsize"];
    //自动转屏开关
    [options setFormatOptionIntValue:0 forKey:@"auto_convert"];
    //重连次数
    [options setFormatOptionIntValue:1 forKey:@"reconnect"];
    //开启硬解码
    [options setPlayerOptionIntValue:1  forKey:@"videotoolbox"];
    
    [IJKFFMoviePlayerController setLogReport:NO]; //是否打印日志
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_FATAL];//日志等级

    // ijk播放器
    self.ijkPlayer = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:self.urlStr] withOptions:options];
    [self addSubview:self.ijkPlayer.view];
    self.ijkPlayerView = self.ijkPlayer.view;
    self.ijkPlayer.view.frame = self.bounds;
    
    //填充方式
    [self.ijkPlayer setScalingMode:IJKMPMovieScalingModeAspectFit];
    //如果是直播，最好不让他自动播放，如果YES，那么就会自动播放电影，不需要通过[self.player play];就可以播放了，
    //但是如果NO，我们需要注册通知，然后到响应比较合适的地方去检测通知，然后必须通过[self.player play];手动播放
//    self.ijkPlayer.shouldAutoplay = NO;
    //自动播放
    if(![self.ijkPlayer isPlaying]){
        [self.ijkPlayer prepareToPlay];
    }
  
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    label.text = [NSString stringWithFormat:@"%d",self.type];
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];
    
    //放大缩小手势
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    [self addGestureRecognizer:pinch];
    
    //长按拖动
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self addGestureRecognizer:longPress];
}

#pragma mark - Action
//放大缩小
- (void)pinchAction:(UIPinchGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateChanged){
        if (gesture.scale >= 1.5){
            DLog(@"放大");
            if ([self.delegate respondsToSelector:@selector(playViewScaleWithState:type:)]){
                [self.delegate playViewScaleWithState:PlayerViewScaleStateZoomIn type:self.type];
            }
        }else if (gesture.scale <= 0.8){
            DLog(@"缩小");
            if ([self.delegate respondsToSelector:@selector(playViewScaleWithState:type:)]){
                [self.delegate playViewScaleWithState:PlayerViewScaleStateZoomOut type:self.type];
            }
        }
    }
}
////拖拽
//- (void)panAction:(UIPanGestureRecognizer *)gesture{
//    //获取拖拽手势在view 的拖拽姿态
//    CGPoint translation = [gesture translationInView:self];
//    //改变gesture.view的中心点
//    gesture.view.center = CGPointMake(gesture.view.center.x + translation.x, gesture.view.center.y + translation.y);
//    //重置拖拽手势的姿态
//    [gesture setTranslation:CGPointZero inView:self];
//    DLog(@"拖拽point:%@",NSStringFromCGPoint(translation));
//    DLog(@"center:%@",NSStringFromCGPoint(gesture.view.center));
//}

//长按拖动
- (void)longPressAction:(UILongPressGestureRecognizer *)gesture{
    if (self.playModel.isBig) return;
    if (gesture.state == UIGestureRecognizerStateBegan){
        [self.superview bringSubviewToFront:self];
        //手指按压的点
        startPoint = [gesture locationInView:gesture.view];
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformMakeScale(1.1, 1.1);
            self.alpha = 0.8;
        }];
    }else if (gesture.state == UIGestureRecognizerStateChanged){
        CGPoint newPoint = [gesture locationInView:gesture.view];
        CGFloat deltaX = newPoint.x-startPoint.x;
        CGFloat deltaY = newPoint.y-startPoint.y;
        self.center = CGPointMake(self.center.x+deltaX,self.center.y+deltaY);
        //以中点为中心创建一个正方形区域40x40
        CGRect centerRect = CGRectMake(self.center.x - 20, self.center.y - 20, 40, 40);
        if ([self.delegate respondsToSelector:@selector(playViewLongPressWithGesture:centerRect:type:)]){
            [self.delegate playViewLongPressWithGesture:gesture centerRect:centerRect type:self.type];
        }

    }else if (gesture.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            self.alpha = 1;
        }];
        if ([self.delegate respondsToSelector:@selector(playViewLongPressWithGesture:centerRect:type:)]){
            [self.delegate playViewLongPressWithGesture:gesture centerRect:CGRectZero type:self.type];
        }
    }
}

//判断中点是否在自己内部
- (BOOL)viewInsideWithOriginPoint:(CGPoint)originPoint newPoint:(CGPoint)newPoint{
    CGFloat c = sqrt(pow(originPoint.x - newPoint.x, 2) + pow(originPoint.y - newPoint.y, 2));
    CGFloat r = self.frame.size.width/2.0;
    return c <= r;
}

//network load state changes
- (void)loadStateDidChange:(NSNotification *)notification{
    IJKMPMovieLoadState loadState = self.ijkPlayer.loadState;
    NSLog(@"LoadStateDidChange : %d",(int)loadState);
}

//when movie playback ends or a user exits playback.
- (void)moviePlayBackFinish:(NSNotification *)notification{
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    NSLog(@"playBackFinish : %d",reason);
}

//
- (void)mediaIsPreparedToPlayDidChange:(NSNotification *)notification{
    NSLog(@"mediaIsPrepareToPlayDidChange");
}

// when the playback state changes, either programatically or by the user
- (void)moviePlayBackStateDidChange:(NSNotification *)notification{
    switch (_ijkPlayer.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"playBackState %d: stoped", (int)self.ijkPlayer.playbackState);
            break;
        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"playBackState %d: playing", (int)self.ijkPlayer.playbackState);
            break;
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"playBackState %d: paused", (int)self.ijkPlayer.playbackState);
            break;
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"playBackState %d: interrupted", (int)self.ijkPlayer.playbackState);
            break;
        case IJKMPMoviePlaybackStateSeekingForward:
            break;
        case IJKMPMoviePlaybackStateSeekingBackward:
            break;
        default:
            break;
    }
}


- (void)installMovieNotificationObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:self.ijkPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:self.ijkPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:self.ijkPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:self.ijkPlayer];
}

- (void)removeMovieNotificationObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:self.ijkPlayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:self.ijkPlayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:self.ijkPlayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:self.ijkPlayer];
}

@end
