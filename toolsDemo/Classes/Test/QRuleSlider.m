//
//  QRuleSlder.m
//  toolsDemo
//
//  Created by Qianlishun on 2021/8/31.
//  Copyright © 2021 钱立顺. All rights reserved.
//

#import "QRuleSlider.h"

static float layerLineWidth = 2;

@interface QRuleSlider()

@property (nonatomic,strong) CAShapeLayer *bgLayer;

@property (nonatomic,strong) CAShapeLayer *selLayer;

//@property (nonatomic,strong) UILabel *textLabel;

@end

@implementation QRuleSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionPanGesture2:)];
        [self addGestureRecognizer:panGes];
        
        _bgLayer = [CAShapeLayer layer];
        [_bgLayer setFrame:self.bounds];
        _bgLayer.backgroundColor = [UIColor clearColor].CGColor;
        _bgLayer.lineWidth = layerLineWidth;
        [self.layer addSublayer:_bgLayer];
        
        
        _selLayer = [CAShapeLayer layer];
        [_selLayer setFrame:self.bounds];
        _selLayer.backgroundColor = [UIColor clearColor].CGColor;
        _selLayer.lineWidth = layerLineWidth;
        [self.layer addSublayer:_selLayer];
        
//        _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width-16, 15)];
//        _textLabel.textColor = [UIColor whiteColor];
//        _textLabel.textAlignment = NSTextAlignmentLeft;
//        [self addSubview:_textLabel];
                
        self.minimumTrackTintColor = [UIColor grayColor];
        self.maximumTrackTintColor =  [UIColor orangeColor];
    }
    return self;
}

- (void)actionPanGesture:(UIPanGestureRecognizer *)sender{
    if(sender.state == UIGestureRecognizerStateCancelled ||
       sender.state == UIGestureRecognizerStateFailed){
        return;
    }
    
    CGPoint touchPoint = [sender locationInView:self];
    if(touchPoint.y <= 0){
        touchPoint.y = 0;
    }else if(touchPoint.y >= self.height){
        touchPoint.y = self.height;
    }

    // 先默认为垂直样式
    CGFloat value = (self.maximumValue - self.minimumValue) * (touchPoint.y / self.frame.size.height );
//    CGFloat value = (self.maximumValue - self.minimumValue) * (touchPoint.x / self.frame.size.width );

    value = self.minimumValue + value;
        
    if(sender.state == UIGestureRecognizerStateEnded && self.ruleSliderChange){
        self.ruleSliderChange(value);
    }
    if((int)value != (int)self.value){
        self.value = (int)value;
    }
}

- (void)actionPanGesture2:(UIPanGestureRecognizer *)sender{
    CGPoint touchPoint = [sender translationInView:sender.view];

    if(sender.state == UIGestureRecognizerStateCancelled ||
       sender.state == UIGestureRecognizerStateFailed ||
       sender.state == UIGestureRecognizerStateBegan){
        return;
    }
    [sender setTranslation:CGPointZero inView:sender.view];

    NSLog(@"%.2f",touchPoint.y);
    
    CGFloat value = (self.maximumValue - self.minimumValue) * (touchPoint.y / self.frame.size.height );
    if(value>0) value = value*2;
    if(value<0) value = value;
    value = self.value + value;

    if(value <= self.minimumValue){
        value = self.minimumValue;
    }else if(value >= self.maximumValue){
        value = self.maximumValue;
    }
    
    if(sender.state == UIGestureRecognizerStateEnded && self.ruleSliderChange){
//        _text = self.ruleSliderChange(value);
    }
    if((int)value != self.value){
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
    [self.selLayer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    float lineWidth = 5;
    int bigRow = 6; int row = 5;
    float allRow = bigRow * row;

    float currentValue = (self.value - self.minimumValue ) / (self.maximumValue - self.minimumValue) * allRow;
    
    UIBezierPath *bgPath = [UIBezierPath bezierPath];
    UIBezierPath *selPath = [UIBezierPath bezierPath];
    
    for (int i = 0; i <= allRow; i++) {
        
        float y = i / allRow * self.height - layerLineWidth/2;
        
        if(y > self.height)
            break;
        
        
        if( i%row == 0){
            lineWidth = 10;
        }else{
            lineWidth = 5;
        }
        
        if(i == (int)currentValue){
            lineWidth = 15;
        }
        
        CGPoint p1 = CGPointMake(0, y);
        CGPoint p2 = CGPointMake(lineWidth, y);
        
        if(i <= currentValue){
            [selPath moveToPoint:p1];
            [selPath addLineToPoint:p2];
        }else{
            [bgPath moveToPoint:p1];
            [bgPath addLineToPoint:p2];
        }
    }
    
    CGFloat fontSize = kISiPhone ? 10 : 12;
    
    CGFloat textY = currentValue/allRow*self.height - 8;
    if(textY < 0) textY = 0;
    NSString *text = [NSString stringWithFormat:@"%.f",self.value];
    UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
    CATextLayer *layer = [self createTextLayerWithString:text Frame:CGRectMake(16, textY, self.width-16, 15) font:font color:[UIColor whiteColor]];
    [self.selLayer addSublayer:layer];
//    _textLabel.text = [NSString stringWithFormat:@"%.f",self.value];
//    _textLabel.y = textY;
    
    self.selLayer.path = selPath.CGPath;
    self.bgLayer.path = bgPath.CGPath;
}


@end
