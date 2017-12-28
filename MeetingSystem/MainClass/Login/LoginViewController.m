//
//  LoginViewController.m
//  MeetingSystem
//
//  Created by chh on 2017/12/23.
//  Copyright © 2017年 caohouhong. All rights reserved.
//

#import "LoginViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
@interface LoginViewController ()
@property (nonatomic, strong) IJKFFMoviePlayerController *ijkPlayer; //播放器
@property (nonatomic, strong) IJKFFOptions *options;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    NSLog(@"销毁了");
}

- (void)initView{
    //调整参数
    _options = [IJKFFOptions optionsByDefault];
    //静音设置(1静音)
    [_options setPlayerOptionValue:@"1" forKey:@"an"];
    _ijkPlayer = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4"] withOptions:_options];
    [_ijkPlayer prepareToPlay];
    _ijkPlayer.scalingMode = IJKMPMovieScalingModeAspectFit;
    [self.view addSubview:self.ijkPlayer.view];
    self.ijkPlayer.view.frame = CGRectMake(10, 100, ScreenWidth - 20, 300);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.ijkPlayer shutdown];
}
@end
