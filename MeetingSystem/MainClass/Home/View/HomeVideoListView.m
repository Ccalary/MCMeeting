//
//  HomeVideoListView.m
//  MeetingSystem
//
//  Created by chh on 2017/12/25.
//  Copyright © 2017年 caohouhong. All rights reserved.
//

#import "HomeVideoListView.h"
#import "HomeVideoCollectionCell.h"

@interface HomeVideoListView()<UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate>
{
    CGFloat itemWidth; //item宽度
    CGFloat itemSpacing;//item 间隔
}
@property (nonatomic, strong) UICollectionView *mCollectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *visibleArray; //可见cell的数组
@end
@implementation HomeVideoListView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        _visibleArray = [NSMutableArray array];
        _dataArray = [NSMutableArray array];
        [self initView];
        //加载可见cell的播放器
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self reloadVisibleCellsWithOffset:CGPointMake(0, 0)];
        });
       
    }
    return self;
}

- (void)initView{
    itemSpacing = 5.0;
    itemWidth = (self.frame.size.width - 3*itemSpacing)/4.0;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    layout.minimumLineSpacing = itemSpacing;
    layout.minimumInteritemSpacing = 0;
    
    _mCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    [_mCollectionView registerClass:[HomeVideoCollectionCell class] forCellWithReuseIdentifier:@"CellIdentifier"];
    _mCollectionView.delegate = self;
    _mCollectionView.dataSource = self;
    _mCollectionView.pagingEnabled = NO;
    _mCollectionView.backgroundColor = [UIColor bgColorMain];
    [self addSubview:_mCollectionView];
    [_mCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //    return self.dataArray.count;
    return 50;
}

//cell的记载
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeVideoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    cell.titleLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    cell.indexRow = indexPath.row;
    [cell reloadCell];
    return cell;
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeVideoCollectionCell *cell = (HomeVideoCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell reloadCell];
}

#pragma mark - UIScrollViewDelegate
//预计出大概位置，经过精确定位获得准备位置
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    CGPoint targetOffset = [self nearestTargetOffsetForOffset:*targetContentOffset];
    targetContentOffset->x = targetOffset.x;
    targetContentOffset->y = targetOffset.y;
}
//计算落在哪个item上
- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset
{
    CGFloat pageSize = itemSpacing + itemWidth;
    //四舍五入
    NSInteger page = roundf(offset.x / pageSize);
    CGFloat targetX = pageSize * page;
    return CGPointMake(targetX, offset.y);
}

/**
* Called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
* 松手时已经静止, 只会调用scrollViewDidEndDragging
*/
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (decelerate == NO)//没有减速动画时
    {
      DLog(@"endDrag");
      [self reloadVisibleCellsWithOffset:scrollView.contentOffset];
    }
}

/**
 * Called on tableView is static after finger up if the user dragged and tableView is scrolling.
 * 松手时还在运动, 先调用scrollViewDidEndDragging, 再调用scrollViewDidEndDecelerating
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // scrollView已经完全静止
    DLog(@"endDecelerating");
    [self reloadVisibleCellsWithOffset:scrollView.contentOffset];
}

- (void)reloadVisibleCellsWithOffset:(CGPoint)offset{
    NSArray *array = [self.mCollectionView visibleCells];
    for (HomeVideoCollectionCell *cell in array){
        BOOL canReload = YES;
        for (NSString *indexRow in self.visibleArray){//如果是还是原来可见的,并且在滑动期间没有销毁，则不刷新
            if ([indexRow intValue] == (int)cell.indexRow && cell.isVisible){
                canReload = NO;
                break;
            }
        }
        if (canReload){
            DLog(@"刷新");
            [cell reloadWithUrl:@"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4" andRow:cell.indexRow];
        }
    }
    [self.visibleArray removeAllObjects];
    for (HomeVideoCollectionCell *cell in array){
        [self.visibleArray addObject:[NSString stringWithFormat:@"%lu",(unsigned long)cell.indexRow]];
    }
}
@end
