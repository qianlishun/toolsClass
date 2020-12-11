//
//  QScrollView.h
//  toolsDemo
//
//  Created by mrq on 2020/12/11.
//  Copyright © 2020 钱立顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QScrollView : UIScrollView

- (void)showsCustomHoriScrollIndicator:(BOOL)isShow;
- (void)showsCustomVertiScrollIndicator:(BOOL)isShow;
- (void)setVerIndicatorX:(CGFloat)x;
- (void)setHorIndicatorY:(CGFloat)y;

- (void)setScrollIndicatorBgColor:(UIColor*)bgColor sliderColor:(UIColor*)sColor;
@end
