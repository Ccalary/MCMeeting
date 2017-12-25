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
- (void)reloadWith:(NSString *)url andTag:(int)tag;
@end
