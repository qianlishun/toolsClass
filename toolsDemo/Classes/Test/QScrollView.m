//
//  QScrollView.m
//  toolsDemo
//
//  Created by mrq on 2020/1/10.
//  Copyright © 2020 钱立顺. All rights reserved.
//

#import "QScrollView.h"

@implementation QScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    /*
     直接拖动UISlider，此时touch时间在150ms以内，UIScrollView会认为是拖动自己，从而拦截了event，导致UISlider接受不到滑动的event。但是只要按住UISlider一会再拖动，此时此时touch时间超过150ms，因此滑动的event会发送到UISlider上。
     */
    UIView *view = [super hitTest:point withEvent:event];

    if([view isKindOfClass:[UISlider class]] || [view.superclass isKindOfClass:[UISlider class]]) {
        self.delaysContentTouches = YES;
    } else {
        self.delaysContentTouches = NO;
    }
    return view;
}

@end
