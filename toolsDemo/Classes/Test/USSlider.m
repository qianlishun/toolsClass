//
//  USSlider.m
//  toolsDemo
//
//  Created by mrq on 2020/1/10.
//  Copyright © 2020 钱立顺. All rights reserved.
//

#import "USSlider.h"

@implementation USSlider{
    NSArray *valueList;
    UIColor *thumbColor;
    UIColor *lightThumbColor;
    CGSize thumbSize;
    CAShapeLayer *shapeLayer;
    CAShapeLayer *leftLayer;
    CAShapeLayer *rightLayer;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapGesture:)];
    [self addGestureRecognizer:tapGesture];
    
    [self addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
    
    [self addTarget:self action:@selector(sliderTouchUp:) forControlEvents:UIControlEventTouchDown];
    
    [self addTarget:self action:@selector(onSliderChange:) forControlEvents:UIControlEventValueChanged];
    
    self.minimumTrackTintColor = [UIColor clearColor];
    self.maximumTrackTintColor = [UIColor clearColor];
}

- (void)actionTapGesture:(UITapGestureRecognizer *)sender{
    CGPoint touchPoint = [sender locationInView:self];
    CGFloat value = (self.maximumValue - self.minimumValue) * (touchPoint.x / self.frame.size.width );
    
    [UIView animateWithDuration:0.25 animations:^{
        [self setValue:(int)(value+0.5) animated:YES];
    }completion:^(BOOL finished) {
        [self drawDotWithColor: [UIColor blackColor]];
    }];
}

- (void)onSliderChange:(UISlider*)slider{
    [UIView animateWithDuration:0.25 animations:^{
        [slider setValue:(int)(slider.value+0.5) animated:NO];
    }completion:^(BOOL finished) {
        [self drawDotWithColor: [UIColor blackColor]];
    }];
}

- (void)sliderTouchDown:(UISlider *)sender {
    self.gestureRecognizers.firstObject.enabled = NO;
}

- (void)sliderTouchUp:(UISlider *)sender {
    self.gestureRecognizers.firstObject.enabled = YES;
}

- (void)drawDotWithColor:(UIColor*)color{
    if(!shapeLayer){
//        layerView = [[UIView alloc]initWithFrame:self.bounds];
//        [self addSubview:layerView];
        leftLayer = [CAShapeLayer layer];
        leftLayer.strokeColor = [UIColor yellowColor].CGColor;
        rightLayer = [CAShapeLayer layer];
        rightLayer.strokeColor = [UIColor grayColor].CGColor;
        leftLayer.lineWidth = rightLayer.lineWidth = 2.0;
        [self.layer addSublayer:leftLayer];
        [self.layer addSublayer:rightLayer];
        shapeLayer = [CAShapeLayer layer];
        [self.layer addSublayer:shapeLayer];
        thumbSize = CGSizeMake(10, 10);
    }
    [shapeLayer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
//    [self sendSubviewToBack:layerView];
//    [layerView setFrame:self.bounds];
    [shapeLayer setFrame:self.bounds];
    shapeLayer.fillColor = color.CGColor;

    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (int i = 0; i <= self.maximumValue; i++) {
        CGPoint center = CGPointMake(i* ((self.width) /self.maximumValue), self.height/2);
        float offset = -thumbSize.width/2;

//        NSString *text = [NSString stringWithFormat:@"%@",valueList[i]];
        NSString *text = [NSString stringWithFormat:@"%d",i];
        CATextLayer *layer = [self createTextLayerWithString:text Frame:CGRectMake(center.x + offset, center.y + thumbSize.height, 30, 20) fontsize:8.0 color:[UIColor whiteColor]];
        [shapeLayer addSublayer:layer];
        
       if(i == self.value || i == 0 || i==self.maximumValue){
          continue;
       }
        [path moveToPoint:center];
        [path addArcWithCenter:center radius:thumbSize.width/3 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        [path closePath];
    }
    
    shapeLayer.path = path.CGPath;
    
    path = [UIBezierPath bezierPath];
    
    CGFloat selX = (self.value/self.maximumValue)*self.width;
    [path moveToPoint:CGPointMake(0, self.height/2)];
    [path addLineToPoint:CGPointMake(selX, self.height/2)];
    
    leftLayer.path = path.CGPath;
    
    path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(selX, self.height/2)];
    [path addLineToPoint:CGPointMake(self.width, self.height/2)];
    
    rightLayer.path = path.CGPath;
    
}

@end
