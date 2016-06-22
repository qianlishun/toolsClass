//
//  PreView.m
//  toolsDemo
//
//  Created by Mr.Q on 16/6/22.
//  Copyright © 2016年 钱立顺. All rights reserved.
//

#import "PreView.h"

@interface PreView()

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIImageView *lineImageView;
@property (nonatomic,strong) NSTimer *timer;

@end


@implementation PreView


+ (Class)layerClass{
    return [AVCaptureVideoPreviewLayer class];

}

- (void)setSession:(AVCaptureSession *)session{
    _session = session;

    AVCaptureVideoPreviewLayer *layer = (AVCaptureVideoPreviewLayer *)self.layer;
    layer.session = session;

}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUIConfig];
    }
    return self;
}

- (void)initUIConfig{

    _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pick_bg"]];

    _imageView.frame = CGRectMake(self.bounds.size.width * 0.5 - 140, self.bounds.size.height * 0.5 - 140, 280, 280);

    [self addSubview:_imageView];

    _lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 240, 2)];
    _lineImageView.image = [UIImage imageNamed:@"line"];
    [_imageView addSubview:_lineImageView];

    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(animation) userInfo:nil repeats:YES];
}

- (void)animation{
    [UIView animateWithDuration:2.8 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _lineImageView.frame = CGRectMake(20, 265, 240, 2);
    } completion:^(BOOL finished) {
        _lineImageView.frame = CGRectMake(20, 5, 240, 2);
    }];
    
}


@end
