//
//  HomeVideoCollectionCell.h
//  MeetingSystem
//
//  Created by chh on 2017/12/25.
//  Copyright © 2017年 caohouhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeVideoCollectionCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) NSUInteger indexRow;
@property (nonatomic, assign, getter=isVisible) BOOL visible; //是否可见
- (void)reloadCell;
- (void)reloadWithUrl:(NSString *)url andRow:(NSUInteger)row;
@end
