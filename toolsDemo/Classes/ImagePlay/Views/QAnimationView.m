//
//  QAnimationView.m
//  toolsDemo
//
//  Created by mrq on 2018/4/12.
//  Copyright © 2018年 钱立顺. All rights reserved.
//

#import "QAnimationView.h"

@implementation QAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        [self addSubview:_imageView];
    }
    return self;
}


- (void)setContentX:(CGFloat)contentX{
    _contentX = contentX;
    
    _imageView.frame = CGRectMake(contentX, 0, self.frame.size.width, self.frame.size.height);
    
}

@end
