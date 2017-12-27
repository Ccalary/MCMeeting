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
#import "LogViewController.h"
#import "HomeVideoListView.h"

#define url_0 @"rtsp://218.204.223.237:554/live/1/66251FC11353191F/e7ooqwcfbqjoo80j.sdp"
#define url_1 @"rtsp://184.72.239.149/vod/mp4://BigBuckBunny_175k.mov"
#define url_2 @"rtmp://live.hkstv.hk.lxdns.com/live/hks"
#define url_4 @"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4"

@interface HomeViewController ()<PlayViewDelegate>
{
    CGFloat playWidth;//宽度
    CGFloat playPadding;//边距
    CGFloat playMargin;//间距
    CGFloat totalLen;//上面3个的和
    
    int moveType;
    int tempType;//临时存储改变的type
}
@property (nonatomic, strong) UIView *videoView; //视频区域
@property (nonatomic, strong) PlayerView *playView0, *playView1, *playView2, *playView3;//播放器
@property (nonatomic, strong) NSMutableArray *playerArray;
@property (nonatomic, strong) HomeVideoListView *listView;//视频列表
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tempType = -1;
    moveType = -1;
    self.playerArray = [NSMutableArray array];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView{
    _videoView = [[UIView alloc] initWithFrame:CGRectMake(30, 100, ScreenWidth - 60, ScreenWidth - 60)];
    _videoView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_videoView];
   
    playWidth = (_videoView.frame.size.width - 22)/2.0;//宽高
    playPadding = 10;//边距
    playMargin = 2;//间距
    totalLen = playPadding + playWidth + playMargin;
    
    _playView0 = [[PlayerView alloc] initWithFrame:CGRectMake(playPadding, playPadding, playWidth, playWidth) url:url_0 type:0];
    _playView0.delegate = self;
    [self.videoView addSubview:_playView0];
   
    _playView1 = [[PlayerView alloc] initWithFrame:CGRectMake(totalLen, playPadding, playWidth, playWidth) url:url_2 type:1];
    _playView1.delegate = self;
    [self.videoView addSubview:_playView1];
    
    _playView2 = [[PlayerView alloc] initWithFrame:CGRectMake(playPadding, totalLen, playWidth, playWidth) url:url_2 type:2];
    _playView2.delegate = self;
    [self.videoView addSubview:_playView2];
    
    _playView3 = [[PlayerView alloc] initWithFrame:CGRectMake(totalLen, totalLen, playWidth, playWidth) url:url_4 type:3];
    _playView3.delegate = self;
    [self.videoView addSubview:_playView3];
    
    //Model
    HomePlayerModel *model0 = [[HomePlayerModel alloc] init];
    model0.playView = self.playView0;
    model0.type = 0;
    model0.frame = self.playView0.frame;
    self.playView0.playModel = model0;
    [self.playerArray addObject:model0];
    
    HomePlayerModel *model1 = [[HomePlayerModel alloc] init];
    model1.playView = self.playView1;
    model1.type = 1;
    model1.frame = self.playView1.frame;
    self.playView1.playModel = model1;
    [self.playerArray addObject:model1];
    
    HomePlayerModel *model2 = [[HomePlayerModel alloc] init];
    model2.playView = self.playView2;
    model2.type = 2;
    model2.frame = self.playView2.frame;
    self.playView2.playModel = model2;
    [self.playerArray addObject:model2];
    
    HomePlayerModel *model3 = [[HomePlayerModel alloc] init];
    model3.playView = self.playView3;
    model3.type = 3;
    model3.frame = self.playView3.frame;
    self.playView3.playModel = model3;
    [self.playerArray addObject:model3];
    
    self.listView = [[HomeVideoListView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 20, 110)];
    [self.view addSubview:self.listView];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.top.equalTo(_videoView.mas_bottom).offset(20);
        make.height.mas_equalTo(110);
    }];
   
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundColor:[UIColor blueColor]];
    [button setTitle:@"push" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.bottom.offset(-50);
        make.height.mas_equalTo(50);
    }];
}

- (void)buttonAction{
    [self.navigationController pushViewController:[LogViewController new] animated:YES];
}

#pragma mark - 播放器界面代理
//放大缩小手势
- (void)playViewScaleWithState:(PlayerViewScaleState)state type:(int)type{
    if (self.playerArray.count <= type) return; //判断越界
    HomePlayerModel *model = self.playerArray[type];
    PlayerView *playView = model.playView;
    switch (state) {
        case PlayerViewScaleStateZoomIn://放大
        {
            if (model.isBig) return;
            CGFloat width = self.videoView.frame.size.width - 2*playPadding;
            [UIView animateWithDuration:0.5f animations:^{
                playView.frame = CGRectMake(playPadding, playPadding, width, width);
                playView.ijkPlayerView.frame = playView.bounds;
            }];
            model.big = YES;
            [self.videoView bringSubviewToFront:playView];
        }
            break;
        case PlayerViewScaleStateZoomOut://缩小
        {
            if (!model.isBig) return;
            model.big = NO;
            [UIView animateWithDuration:0.5f animations:^{
                playView.frame = model.frame;
                playView.ijkPlayerView.frame = playView.bounds;
            }];
        }
            break;
        default:
            break;
    }
}

//长按拖动
- (void)playViewLongPressWithGesture:(UILongPressGestureRecognizer *)gesture centerRect:(CGRect)rect type:(int)type{
    if (self.playerArray.count <= type) return; //判断越界
    HomePlayerModel *model = self.playerArray[type];
    if (gesture.state == UIGestureRecognizerStateChanged){
        __weak typeof (self) weakSelf = self;
        [self.playerArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (weakSelf.playerArray.count <= idx) return;
            HomePlayerModel *playModel = (HomePlayerModel *)obj;
            //如果移动到了其他View位置
            if (CGRectContainsRect(playModel.frame, rect)){
                //如果移动过则不处理
                if (moveType == playModel.type) return;
                moveType = playModel.type;
                
                //如果是自己，不处理
                if (type != playModel.type){
                    [UIView animateWithDuration:0.3 animations:^{
                        playModel.playView.frame = model.frame;
                    }];
                }
            }
        }];
        //临时temp和当前移动的type比较
        if (tempType == moveType) return;
        tempType = moveType;
        HomePlayerModel *moveModel = self.playerArray[moveType];
        //长按的view
        CGRect pressFrame = model.frame;
        //自己移动的view
        CGRect moveFrame = moveModel.frame;
        //移动的view的frame和拖动的交换
        [self.playerArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HomePlayerModel *objModel = (HomePlayerModel *)obj;
            if ((int)idx == type){
                objModel.frame = moveFrame;
            }else if ((int)idx == moveType){
                objModel.frame = pressFrame;
            }
        }];
    }
}
@end
