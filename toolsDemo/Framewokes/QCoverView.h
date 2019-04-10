//
//  QCoverView.h
//  WirelessUS2
//
//  Created by mrq on 16/10/14.
//  Copyright © 2016年 Sonoptek. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KScreenW [UIScreen mainScreen].bounds.size.width
#define KScreenH [UIScreen mainScreen].bounds.size.height
typedef void(^showBlock)();
typedef void(^hideBlock)(UIView *view);

@interface QCoverView : UIView


/**
 *  隐藏
 */
+ (void)hide;

+ (void)transparentCoverFrom:(UIView *)fromView content:(UIView *)contentView animated:(BOOL)animated touchHideBlock:(hideBlock)block;

+ (void)transparentCoverFrom:(UIView *)fromView content:(UIView *)contentView animated:(BOOL)animated;

+ (void)transparentNotTouchHideCoverFrom:(UIView *)fromView content:(UIView *)contentView;

@end
