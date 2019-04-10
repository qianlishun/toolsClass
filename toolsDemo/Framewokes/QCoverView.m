//
//  QCoverView.m
//  WirelessUS2
//
//  Created by mrq on 16/10/14.
//  Copyright © 2016年 Sonoptek. All rights reserved.
//

#import "QCoverView.h"

@implementation QCoverView

static QCoverView   *_cover;
static UIView    *_fromView;
static UIView    *_contentView;
static BOOL      _animated;
static BOOL      _notclick;
static showBlock _showBlock;
static hideBlock _hideBlock;


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        // 自动伸缩
//        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _animated = NO;
    }
    return self;
}

+ (instancetype)cover
{
    static QCoverView* shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[QCoverView alloc]init];
    });
    return shared;
}

+ (void)transparentCoverFrom:(UIView *)fromView content:(UIView *)contentView animated:(BOOL)animated
{
    [self transparentCoverFrom:fromView content:contentView animated:animated notClick:NO];
}

+ (void)transparentNotTouchHideCoverFrom:(UIView *)fromView content:(UIView *)contentView{
    contentView.tag = -1001;
    [self transparentCoverFrom:fromView content:contentView animated:NO notClick:NO];
}
/**
 *  全透明遮罩
 *
 *  @param fromView    显示在此view上
 *  @param contentView 遮罩上面显示的内容view
 *  @param animated    是否有显示动画
 *  @param notClick    是否不能点击，默认是NO，即能点击
 */
+ (void)transparentCoverFrom:(UIView *)fromView content:(UIView *)contentView animated:(BOOL)animated notClick:(BOOL)notClick{
    [self transparentCoverFrom:fromView content:contentView animated:animated notClick:nil touchHideBlock:nil];

}

+ (void)transparentCoverFrom:(UIView *)fromView content:(UIView *)contentView animated:(BOOL)animated touchHideBlock:(hideBlock)block{
    [self transparentCoverFrom:fromView content:contentView animated:animated notClick:nil touchHideBlock:block];
}


+ (void)transparentCoverFrom:(UIView *)fromView content:(UIView *)contentView animated:(BOOL)animated notClick:(BOOL)notClick touchHideBlock:(hideBlock)block{
    
    // 创建遮罩
    QCoverView *cover = [self cover];
    cover.frame = fromView.bounds;
    cover.backgroundColor = [UIColor clearColor];
    [fromView addSubview:cover];
    _cover = cover;
    
    // 赋值
    _fromView  = fromView;
    _contentView = contentView;
    _animated  = animated;
    _notclick  = notClick;
    _hideBlock = block;
    
    // 显示内容view
    [self showContentView];
    
}

+ (void)showContentView
{
        _contentView.center = _cover.center;
        [_fromView addSubview:_contentView];
}

/**
 *  隐藏
 */
+ (void)hide{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_cover removeFromSuperview];
        [_contentView removeFromSuperview];
        
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(_contentView.tag==-1001){
        return;
    }else{
        [QCoverView hide];
    }
}
@end
