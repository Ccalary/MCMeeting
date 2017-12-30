//
//  HomeVideoCollectionCell.m
//  MeetingSystem
//
//  Created by chh on 2017/12/25.
//  Copyright © 2017年 caohouhong. All rights reserved.
//

#import "HomeVideoCollectionCell.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
@interface HomeVideoCollectionCell()
@property (nonatomic, strong) IJKFFMoviePlayerController *ijkPlayer; //播放器
@property (nonatomic, strong) IJKFFOptions *options;
@end

@implementation HomeVideoCollectionCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

- (void)initView{
    self.backgroundColor = [UIColor blackColor];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    _titleLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_titleLabel];
    //调整参数
    _options = [IJKFFOptions optionsByDefault];
    //静音设置(1静音)
    [_options setPlayerOptionValue:@"1" forKey:@"an"];
}

- (void)reloadCell{
    DLog(@"reloadCell:%lu",(unsigned long)self.indexRow);
  
    self.visible = NO;
    [self destroyPlayer];
}

- (void)reloadWithUrl:(NSString *)url andRow:(NSUInteger)row{
    DLog(@"刷新cell:%lu",(unsigned long)row);
    self.visible = YES;
    [self destroyPlayer];
   
    _ijkPlayer = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:url] withOptions:self.options];
    [_ijkPlayer prepareToPlay];
    _ijkPlayer.scalingMode = IJKMPMovieScalingModeAspectFit;
    [self.contentView addSubview:self.ijkPlayer.view];
    self.ijkPlayer.view.frame = self.contentView.bounds;
    
    [self.contentView bringSubviewToFront:self.titleLabel];
}

//销毁播放器
- (void)destroyPlayer{
    if (self.ijkPlayer){
        [self.ijkPlayer shutdown];
        self.ijkPlayer = nil;
    }
}
@end
