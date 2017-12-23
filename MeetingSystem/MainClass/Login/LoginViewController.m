//
//  LoginViewController.m
//  MeetingSystem
//
//  Created by chh on 2017/12/23.
//  Copyright © 2017年 caohouhong. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
{
    BOOL contain;
    CGPoint startPoint;
    CGPoint originPoint;
}
@property (strong , nonatomic) NSMutableArray *itemArray;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    for (NSInteger i = 0;i<8;i++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor redColor];
        btn.frame = CGRectMake(50+(i%2)*100, 64+(i/2)*100, 90, 90);
        btn.tag = i;
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [btn setTitle:[NSString stringWithFormat:@"%ld",1+i] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPressed:)];
        [btn addGestureRecognizer:longGesture];
        [self.itemArray addObject:btn];
            
}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)buttonLongPressed:(UILongPressGestureRecognizer *)sender
{
  UIButton *btn = (UIButton *)sender.view;
    if (sender.state == UIGestureRecognizerStateBegan)
        {
            startPoint = [sender locationInView:sender.view];
            originPoint = btn.center;
            [UIView animateWithDuration:1 animations:^{
                btn.transform = CGAffineTransformMakeScale(1.1, 1.1);
                btn.alpha = 0.7;
                }];
            }
    else if (sender.state == UIGestureRecognizerStateChanged)
        {
            CGPoint newPoint = [sender locationInView:sender.view];
            CGFloat deltaX = newPoint.x-startPoint.x;
            CGFloat deltaY = newPoint.y-startPoint.y;
            btn.center = CGPointMake(btn.center.x+deltaX,btn.center.y+deltaY);
            NSLog(@"center = %@",NSStringFromCGPoint(btn.center));
            NSInteger index = [self indexOfPoint:btn.center withButton:btn];
            if (index<0)
                {
                    contain = NO;
                    }
            else
                {
                    [UIView animateWithDuration:1 animations:^{
                        CGPoint temp = CGPointZero;
                        UIButton *button = _itemArray[index];
                        temp = button.center;
                        button.center = originPoint;
                        btn.center = temp;
                        originPoint = btn.center;
                        contain = YES;
                        }];
                    }
            }
    else if (sender.state == UIGestureRecognizerStateEnded)
        {
//            [UIView animateWithDuration:1 animations:^{
//                btn.transform = CGAffineTransformIdentity;
//                btn.alpha = 1.0;
//                if (!contain)
//                    {
//                        btn.center = originPoint;
//                        }
//                }];
            }
    }
- (NSInteger)indexOfPoint:(CGPoint)point withButton:(UIButton *)btn
{
    for (NSInteger i = 0;i<_itemArray.count;i++)
        {
            UIButton *button = _itemArray[i];
            if (button != btn)
                {
                    if (CGRectContainsPoint(button.frame, point))
                        {
                            return i;
                            }
                    }
            }
    return -1;
}


@end
