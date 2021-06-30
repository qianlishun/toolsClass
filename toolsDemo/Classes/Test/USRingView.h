//
//  USRingView.h
//  WirelessKUS3
//
//  Created by Qianlishun on 2021/6/18.
//  Copyright © 2021 MrQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface USRingView : UIView

- (instancetype)initWithFrame:(CGRect)frame center:(CGPoint)center radius:(CGFloat)radius;

- (void)setOuterColor:(UIColor*)color;
- (void)setCenterColor:(UIColor*)color;
- (void)setLineColor:(UIColor*)color;

@property (nonatomic,strong) UIView *centerView;
@property (nonatomic,strong) NSArray<UIView*> *viewList;

@end

NS_ASSUME_NONNULL_END
