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
    
    //ijk播放器
    self.ijkPlayer = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:self.urlStr] withOptions:options];
    [self addSubview:self.ijkPlayer.view];
    
    [self.ijkPlayer.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    //填充方式
    [self.ijkPlayer setScalingMode:IJKMPMovieScalingModeAspectFit];
    //如果是直播，最好不让他自动播放，如果YES，那么就会自动播放电影，不需要通过[self.player play];就可以播放了，
    //但是如果NO，我们需要注册通知，然后到响应比较合适的地方去检测通知，然后必须通过[self.player play];手动播放
//    self.ijkPlayer.shouldAutoplay = NO;
    //自动播放
    if(![self.ijkPlayer isPlaying]){
        [self.ijkPlayer prepareToPlay];
    }
    
    //放大缩小手势
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    [self addGestureRecognizer:pinch];
}

- (void)pinchAction:(UIPinchGestureRecognizer *)gesture{
    NSLog(@"scale:%f",gesture.scale);
    if (gesture.state == UIGestureRecognizerStateChanged){
        if (gesture.scale >= 1.5){
            NSLog(@"放大");
            if ([self.delegate respondsToSelector:@selector(playViewScaleWithState:type:)]){
                [self.delegate playViewScaleWithState:PlayerViewScaleStateZoomIn type:self.type];
            }
        }else if (gesture.scale <= 0.8){
            NSLog(@"缩小");
            if ([self.delegate respondsToSelector:@selector(playViewScaleWithState:type:)]){
                [self.delegate playViewScaleWithState:PlayerViewScaleStateZoomOut type:self.type];
            }
        }
    }
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
