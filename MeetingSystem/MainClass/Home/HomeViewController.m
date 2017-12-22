//
//  HomeViewController.m
//  MeetingSystem
//
//  Created by chh on 2017/12/22.
//  Copyright © 2017年 caohouhong. All rights reserved.
//

#import "HomeViewController.h"
#import "PlayerView.h"
#import "HomePlayerModel.h"

#define url_0 @"http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8"
#define url_1 @"rtsp://184.72.239.149/vod/mp4://BigBuckBunny_175k.mov"
#define url_2 @"rtmp://live.hkstv.hk.lxdns.com/live/hks"
#define url_4 @"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4"

@interface HomeViewController ()<PlayViewDelegate>
@property (nonatomic, strong) UIView *videoView; //视频区域
@property (nonatomic, strong) PlayerView *playView0, *playView1, *playView2, *playView3;//播放器
@property (nonatomic, strong) NSMutableArray *playerArray;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playerArray = [NSMutableArray array];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView{
    _videoView = [[UIView alloc] init];
    _videoView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_videoView];
    [_videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.top.offset(100);
        make.height.mas_equalTo(_videoView.mas_width);
    }];
    _playView0 = [[PlayerView alloc] initWithFrame:CGRectZero url:url_4 type:0];
    _playView0.delegate = self;
    [self.videoView addSubview:_playView0];
    [_playView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(10);
        make.right.equalTo(_videoView.mas_centerX).offset(-1);
        make.bottom.equalTo(_videoView.mas_centerY).offset(-1);
    }];
    HomePlayerModel *model0 = [[HomePlayerModel alloc] init];
    model0.playView = self.playView0;
    [self.playerArray addObject:model0];
    
    _playView1 = [[PlayerView alloc] initWithFrame:CGRectZero url:url_2 type:1];
    _playView1.delegate = self;
    [self.videoView addSubview:_playView1];
    [_playView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_videoView.mas_centerX).offset(1);
        make.top.offset(10);
        make.right.offset(-10);
        make.bottom.equalTo(_videoView.mas_centerY).offset(-1);
    }];
    HomePlayerModel *model1 = [[HomePlayerModel alloc] init];
    model1.playView = self.playView1;
    [self.playerArray addObject:model1];
    
    _playView2 = [[PlayerView alloc] initWithFrame:CGRectZero url:url_2 type:2];
    _playView2.delegate = self;
    [self.videoView addSubview:_playView2];
    [_playView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.equalTo(_videoView.mas_centerY).offset(1);
        make.right.equalTo(_videoView.mas_centerX).offset(-1);
        make.bottom.offset(-10);
    }];
    HomePlayerModel *model2 = [[HomePlayerModel alloc] init];
    model2.playView = self.playView2;
    [self.playerArray addObject:model2];
    
    _playView3 = [[PlayerView alloc] initWithFrame:CGRectZero url:url_4 type:3];
    _playView3.delegate = self;
    [self.videoView addSubview:_playView3];
    [_playView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_videoView.mas_centerX).offset(1);
        make.top.equalTo(_videoView.mas_centerY).offset(1);
        make.right.offset(-10);
        make.bottom.offset(-10);
    }];
    HomePlayerModel *model3 = [[HomePlayerModel alloc] init];
    model3.playView = self.playView3;
    [self.playerArray addObject:model3];
}

- (void)playViewScaleWithState:(PlayerViewScaleState)state type:(int)type{
    
    if (self.playerArray.count <= type) return; //判断越界
    HomePlayerModel *model = self.playerArray[type];
    PlayerView *playView = model.playView;
    
    switch (state) {
        case PlayerViewScaleStateZoomIn://放大
        {
            if (model.isBig) return;
            [playView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10);
                make.top.offset(10);
                make.right.offset(-10);
                make.bottom.offset(-10);
            }];
            [UIView animateWithDuration:0.5f animations:^{
                [playView.superview layoutIfNeeded];//这里是关键
            }];
            model.big = YES;
            [self.videoView bringSubviewToFront:playView];
        }
            break;
        case PlayerViewScaleStateZoomOut://缩小
        {
            if (!model.isBig) return;
            model.big = NO;
            
            if ([playView isEqual:self.playView0]){
                [playView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset(10);
                    make.top.offset(10);
                    make.right.equalTo(_videoView.mas_centerX).offset(-1);
                    make.bottom.equalTo(_videoView.mas_centerY).offset(-1);
                }];
            }else if ([playView isEqual:self.playView1]){
                [playView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_videoView.mas_centerX).offset(1);
                    make.top.offset(10);
                    make.right.offset(-10);
                    make.bottom.equalTo(_videoView.mas_centerY).offset(-1);
                }];
            }else if ([playView isEqual:self.playView2]){
                [playView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset(10);
                    make.top.equalTo(_videoView.mas_centerY).offset(1);
                    make.right.equalTo(_videoView.mas_centerX).offset(-1);
                    make.bottom.offset(-10);
                }];
            }else if ([playView isEqual:self.playView3]){
                [playView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_videoView.mas_centerX).offset(1);
                    make.top.equalTo(_videoView.mas_centerY).offset(1);
                    make.right.offset(-10);
                    make.bottom.offset(-10);
                }];
            }
            [UIView animateWithDuration:0.5f animations:^{
                [playView.superview layoutIfNeeded];//这里是关键
            }];
        }
            break;
        default:
            break;
    }
}
@end
