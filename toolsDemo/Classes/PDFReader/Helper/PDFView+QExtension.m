//
//  PDFView+QExtension.m
//  toolsDemo
//
//  Created by Qianlishun on 2022/2/17.
//  Copyright © 2022 钱立顺. All rights reserved.
//

#import "PDFView+QExtension.h"

@implementation PDFView (QExtension)

- (UIScrollView *)scrollView{
   
    for (UIView *view in self.subviews) {
        if([view isKindOfClass:[UIScrollView class]]){
            return (UIScrollView*)view;
        }
    }
    return nil;
}

- (void)setBounces:(BOOL)bounces{
    self.scrollView.bounces = bounces;
}
@end
