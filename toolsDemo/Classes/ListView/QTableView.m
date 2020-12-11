//
//  QTableView.m
//  toolsDemo
//
//  Created by mrq on 2020/12/11.
//  Copyright © 2020 钱立顺. All rights reserved.
//

#import "QTableView.h"
#import "QTableViewCell.h"

@implementation QTableView{
    BOOL isShowHor;
    BOOL isShowVer;

    CGFloat verX;
    CGFloat horY;
    CAShapeLayer *sliderLayer;
    CAShapeLayer *backLayer;


}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.delaysContentTouches = NO;
        for (id view in self.subviews)
        {
           // looking for a UITableViewWrapperView
           if ([NSStringFromClass([view class]) isEqualToString:@"UITableViewWrapperView"])
           {
               if([view isKindOfClass:[UIScrollView class]])
               {
                   // turn OFF delaysContentTouches in the hidden subview
                   UIScrollView *scroll = (UIScrollView *) view;
                   scroll.delaysContentTouches = NO;
               }
               break;
           }
        }
        self.bounces = NO;
        self.clipsToBounds = YES;
        [self setScrollEnabled:YES];
        [self setShowsVerticalScrollIndicator:NO];
//        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        
        backLayer = [CAShapeLayer layer];
        backLayer.frame = self.bounds;
        backLayer.strokeColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0] .CGColor;
        backLayer.lineWidth = 2.0;
        
        sliderLayer = [CAShapeLayer layer];
        sliderLayer.backgroundColor = [UIColor clearColor].CGColor;
        [sliderLayer setFrame:self.bounds];
        sliderLayer.strokeColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0] .CGColor;
        sliderLayer.fillColor = [UIColor clearColor].CGColor;
        sliderLayer.lineCap = kCALineCapRound;
        sliderLayer.lineJoin = kCALineJoinRound;
        sliderLayer.lineWidth = 2.0;
    }
    return self;
}


- (void)setScrollIndicatorBgColor:(UIColor *)bgColor sliderColor:(UIColor *)sColor{
    backLayer.strokeColor = bgColor.CGColor;
    sliderLayer.strokeColor = sColor.CGColor;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    if([view isKindOfClass:[UISlider class]]){
    }else if ([view isKindOfClass:[UIControl class]] || [view.superclass isKindOfClass:[UIControl class]] ) {
        return YES;
    }
    else if([view isKindOfClass:[UIButton class]]){
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *view = [super hitTest:point withEvent:event];
    
    if([view isKindOfClass:[UISlider class]] || [view.superclass isKindOfClass:[UISlider class]])
    {
        self.delaysContentTouches = YES;
    }
    else
    {
        self.delaysContentTouches = NO;
    }
    return view;
}

- (void)showsCustomHoriScrollIndicator:(BOOL)isShow{
    if(isShow){
        self.showsHorizontalScrollIndicator = NO;
    }
    isShowHor = isShow;
    [self setContentOffset:self.contentOffset];
}

- (void)showsCustomVertiScrollIndicator:(BOOL)isShow{
    if(isShow){
        self.showsVerticalScrollIndicator = NO;
    }
    isShowVer = isShow;
    [self setContentOffset:self.contentOffset];
}

- (void)setVerIndicatorX:(CGFloat)x{
    verX = x;
    [self setContentOffset:self.contentOffset];
}

- (void)setHorIndicatorY:(CGFloat)y{
    horY = y;
    [self setContentOffset:self.contentOffset];
}

static float sliderSpacing = 5;
static float sliderLineWidth = 8;

- (void)setContentOffset:(CGPoint)contentOffset{
    [super setContentOffset:contentOffset];
    
    UIBezierPath *backPath = [UIBezierPath bezierPath];
    UIBezierPath *path = [UIBezierPath bezierPath];
        
    if(isShowHor && self.contentSize.width > self.width){
        CGFloat width = self.width - 2 * sliderSpacing;
        
        CGFloat w =  (self.width / self.contentSize.width) * width;
        CGFloat x =  (contentOffset.x / (self.contentSize.width - self.width)) * (width - w) + contentOffset.x;
        
        [path moveToPoint:
         CGPointMake(sliderSpacing + x, horY + sliderLineWidth/2)];
        
        [path addLineToPoint:
         CGPointMake(sliderSpacing+ x + w , horY + sliderLineWidth/2)];
        
        [backPath moveToPoint:CGPointMake(sliderSpacing+contentOffset.x, horY + sliderLineWidth/2)];
        [backPath addLineToPoint:CGPointMake(self.width-sliderSpacing+contentOffset.x, horY + sliderLineWidth/2)];
    }
    
    if(isShowVer && self.contentSize.height > self.height){
        CGFloat height = self.height - 2 * sliderSpacing;
        
        CGFloat h =  (self.height / self.contentSize.height) * height;
        CGFloat y =  (contentOffset.y / (self.contentSize.height - self.height)) * (height - h) + contentOffset.y;
        
        [path moveToPoint:
         CGPointMake(verX + sliderLineWidth/2, sliderSpacing + y)];
        
        [path addLineToPoint:
         CGPointMake(verX + sliderLineWidth/2, sliderSpacing + y + h )];
        
        
        [backPath moveToPoint:CGPointMake(verX + sliderLineWidth/2, sliderSpacing + contentOffset.y)];
        [backPath addLineToPoint:CGPointMake(verX + sliderLineWidth/2, self.height-sliderSpacing + contentOffset.y)];
    }
    backLayer.path = backPath.CGPath;
    sliderLayer.path = path.CGPath;
}


@end
