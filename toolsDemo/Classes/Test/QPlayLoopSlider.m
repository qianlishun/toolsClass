//
//  QPlayLoopView.m
//  toolsDemo
//
//  Created by Qianlishun on 2021/8/31.
//  Copyright © 2021 钱立顺. All rights reserved.
//

#import "QPlayLoopSlider.h"
#import "UIImage+AssetUrl.h"

@interface QPlayLoopSlider()
@property (nonatomic,strong) CAShapeLayer *bgLayer;

@property (nonatomic,strong) CAShapeLayer *selLayer;

@property (nonatomic,strong) CAShapeLayer *markLayer;

@end
@implementation QPlayLoopSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionPanGesture:)];
        [self addGestureRecognizer:panGes];
        
        _bgLayer = [CAShapeLayer layer];
        [_bgLayer setFrame:self.bounds];
        _bgLayer.backgroundColor = [UIColor clearColor].CGColor;
        _bgLayer.lineWidth = self.height/2;
        [self.layer addSublayer:_bgLayer];
        
        
        _selLayer = [CAShapeLayer layer];
        [_selLayer setFrame:self.bounds];
        _selLayer.backgroundColor = [UIColor clearColor].CGColor;
        _selLayer.lineWidth = self.height/2;
        [self.layer addSublayer:_selLayer];
        
        self.minimumTrackTintColor = [UIColor grayColor];
        self.maximumTrackTintColor = [UIColor lightGrayColor];
        
        _markLayer = [CAShapeLayer layer];
        [_markLayer setFrame:self.bounds];
        _markLayer.backgroundColor = [UIColor clearColor].CGColor;
        _markLayer.lineWidth = self.height/2;
        _markLayer.fillColor = [UIColor colorWithRed:10/255.0 green:110/255.0 blue:155/255.0 alpha:1.0].CGColor;
        [self.layer addSublayer:_markLayer];

    }
    return self;
}


- (void)actionPanGesture:(UIPanGestureRecognizer *)sender{
    if(sender.state == UIGestureRecognizerStateCancelled ||
       sender.state == UIGestureRecognizerStateFailed){
        return;
    }
    float textWidth = kISiPad ? 80 : 60;
    float width = self.width - textWidth;
    
    CGPoint touchPoint = [sender locationInView:self];
    if(touchPoint.x <= 0){
        touchPoint.x = 0;
    }else if(touchPoint.x >= width){
        touchPoint.x = width;
    }

    // 先默认为水平样式
    CGFloat value = (self.maximumValue - self.minimumValue) * (touchPoint.x / width );

    value = self.minimumValue + value;
        
    if(sender.state == UIGestureRecognizerStateEnded && self.playLoopChange){
        self.playLoopChange(value);
    }
    if((int)value != (int)self.value){
        self.value = (int)value;
    }
}

- (void)setValue:(float)value{
    _value = value;
    [self updateLayer];
}

- (void)setMinimumValue:(float)minimumValue{
    _minimumValue = minimumValue;
    if(self.value < minimumValue){
        self.value = minimumValue;
    }
}

- (void)setMaximumValue:(float)maximumValue{
    _maximumValue = maximumValue;
    if(self.value > maximumValue){
        self.value = maximumValue;
    }
}

- (void)setMinimumTrackTintColor:(UIColor *)minimumTrackTintColor{
    _minimumTrackTintColor = minimumTrackTintColor;
    self.bgLayer.strokeColor = minimumTrackTintColor.CGColor;
}

- (void)setMaximumTrackTintColor:(UIColor *)maximumTrackTintColor{
    _maximumTrackTintColor = maximumTrackTintColor;
    self.selLayer.strokeColor = maximumTrackTintColor.CGColor;
}

- (void)updateLayer{
    [self.markLayer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];

    float fontSize = kISiPad  ? 15 : 12;
    float textWidth = kISiPad ? 80 : 60;
    float width = self.width - textWidth;

    float x = (self.value - self.minimumValue) / (self.maximumValue - self.minimumValue) * width;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(0, self.height/4)];
    [path addLineToPoint:CGPointMake(x, self.height/4)];
    _selLayer.path = path.CGPath;
    
    path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(x, self.height/4)];
    [path addLineToPoint:CGPointMake(width, self.height/4)];
    _bgLayer.path = path.CGPath;
    
    CGFloat markWidth = 0.577 * self.height/2;
    path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(x-markWidth, self.height)];
    [path addLineToPoint:CGPointMake(x, self.height/2)];
    [path addLineToPoint:CGPointMake(x+markWidth, self.height)];
    [path addLineToPoint:CGPointMake(x-markWidth, self.height)];
    [path closePath];
    _markLayer.path = path.CGPath;
    
    NSString *text = [NSString stringWithFormat:@"%.f/%.f",self.value, self.maximumValue];
    UIFont *font = [UIFont boldSystemFontOfSize:fontSize];

    CATextLayer *textLayer = [self createTextLayerWithString:text Frame:CGRectMake(width, self.height/4, textWidth, self.height) font:font  color:[UIColor colorWithRed:10/255.0 green:110/255.0 blue:155/255.0 alpha:1.0]];
    [_markLayer addSublayer:textLayer];
}


@end
