//
//  QScalableNav.h
//  toolsDemo
//
//  Created by Mr.Q on 16/7/19.
//  Copyright © 2016年 钱立顺. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat MaxHeight = 200;
static const CGFloat navHeight = 0;

@interface QScalableNav : UIView

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, copy) void(^imgActionBlock)();

- (id)initWithFrame:(CGRect)frame backgroundImage:(NSString *)backgroudImage headerImage:(NSString *)headerImage title:(NSString *)title subTitle:(NSString *)subTitle;

-(void)updateSubViewsWithScrollOffset:(CGPoint)newOffset;

- (void)removeObserver;
@end
