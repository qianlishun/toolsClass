
#import "QSlider.h"
#import "UIColor+Common.h"

@implementation QSlider{
    NSArray *valueList;
    UIColor *thumbColor;
    UIColor *lightThumbColor;
    CGSize thumbSize;
    CAShapeLayer *shapeLayer;
    CAShapeLayer *leftLayer;
    CAShapeLayer *rightLayer;
}

- (instancetype)initWithFrame:(CGRect)frame list:(NSArray *)list{
    self = [self initWithFrame:frame];
    if(self){
        self.minimumValue = 0;
        self.minimumTrackTintColor = [UIColor clearColor];
        self.maximumTrackTintColor = [UIColor clearColor];
        [self addTarget:self action:@selector(onSliderChange:) forControlEvents:UIControlEventValueChanged];
        [self addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(sliderTouchUp:) forControlEvents:UIControlEventTouchDown];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapGesture:)];
        [self addGestureRecognizer:tapGesture];
        
    }
    return self;
}

- (void)updateValue:(int)value{
    int minDiff = 100;
    int index = 0;
    for(int i = 0; i < valueList.count-1; i++){
        int diff = abs(value - [valueList[i] intValue]);
        if ( diff < minDiff ) {
            minDiff = diff;
            index = i;
        }
    }
    [self setValue:index];
}

- (void)setList:(NSArray *)list{
    valueList = list;
    
    self.maximumValue = list.count-1;
        
    [self drawDotWithColor:thumbColor];
}

- (void)setThumbSize:(CGSize)size color:(UIColor*)color highlight:(UIColor*)lightColor{
    thumbSize = size;
    thumbColor = color;
    lightThumbColor = lightColor;
    UIImage *image = [lightThumbColor getArcImageWithSize:thumbSize];
    [self setThumbImage:image forState:UIControlStateNormal];

    UIImage *imageL = [lightThumbColor getArcImageWithSize:CGSizeMake(thumbSize.width*1.5, thumbSize.height*1.5)];
    [self setThumbImage:imageL forState:UIControlStateHighlighted];

    [self setNeedsLayout];
}

// 返回滑条的frame
- (CGRect)trackRectForBounds:(CGRect)bounds{
    return CGRectMake(bounds.origin.x, bounds.size.height/2 - 2.5 + bounds.origin.y, bounds.size.width, 5); // 这里面的h即为你想要设置的高度。
}
// 返回滑块的frame,滑块滑动不灵敏的话调整它的高度
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value{
    // 如果不调用的父类的方法 滑块无法操作~
    bounds = [super thumbRectForBounds:bounds trackRect:rect value:value];
        
    // w 和 h 是滑块可触摸范围的大小，跟通过图片改变的滑块大小应当一致
    rect = CGRectMake(bounds.origin.x, bounds.size.height/2 - thumbSize.height/2 + bounds.origin.y, thumbSize.width, thumbSize.height);

    return rect;
}


- (void)actionTapGesture:(UITapGestureRecognizer *)sender{
    CGPoint touchPoint = [sender locationInView:self];
    CGFloat value = (self.maximumValue - self.minimumValue) * (touchPoint.x / self.frame.size.width );
    [self onSliderValueChange:value];
}

- (void)onSliderChange:(UISlider*)slider{
   [self onSliderValueChange:slider.value];
}

- (void)onSliderValueChange:(float)sliderValue{
    int index = (int)(sliderValue + 0.5);
    [UIView animateWithDuration:0.25 animations:^{
        [self setValue:index animated:NO];
    }completion:^(BOOL finished) {
        [self drawDotWithColor:nil];
//        int value = [self->valueList[index] intValue];
//        if(self.delegate && [self.delegate respondsToSelector:@selector(onQSliderValueChange:value:)]){
//                 [self.delegate onQSliderValueChange:self value:value];
//           }
        if (self.isSliderBallMoved != nil) {
            NSNumber *num = [NSNumber numberWithInt:index];
            if(self->valueList){
                num = self->valueList[index];
            }
            self.isSliderBallMoved(YES,num);  // 用来改变界面其他的UI
        }
       }];
}

- (void)sliderTouchDown:(UISlider *)sender {
    self.gestureRecognizers.firstObject.enabled = NO;
}

- (void)sliderTouchUp:(UISlider *)sender {
    self.gestureRecognizers.firstObject.enabled = YES;
}

- (void)drawDotWithColor:(UIColor*)color{
    if(!color)
        color = thumbColor;
        
    if(!shapeLayer){
        leftLayer = [CAShapeLayer layer];
        rightLayer = [CAShapeLayer layer];
        leftLayer.strokeColor = kButtonBgColor.CGColor;
        rightLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        leftLayer.lineWidth = rightLayer.lineWidth = 2;
        shapeLayer = [CAShapeLayer layer];
        
        CALayer *slayer = self.layer;
        if (@available(iOS 14.0, *)) {
            slayer = self.layer.sublayers.firstObject;
        }
        [slayer addSublayer:rightLayer];
        [slayer addSublayer:leftLayer];
        [slayer addSublayer:shapeLayer];
    }
    [shapeLayer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [shapeLayer setFrame:self.bounds];
    shapeLayer.fillColor = color.CGColor;

    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (int i = 0; i <= self.maximumValue; i++) {
        CGPoint center = CGPointMake(i* ((self.width) /self.maximumValue), self.height/2);
        float offset = -thumbSize.width/2;
        NSString *text = [NSString stringWithFormat:@"%@",valueList[i]];
        UIFont *font = [UIFont systemFontOfSize:8.0];
        CATextLayer *layer = [self createTextLayerWithString:text Frame:CGRectMake(center.x + offset, center.y + thumbSize.height, 30, 20) font:font color:[UIColor whiteColor]];
        [shapeLayer addSublayer:layer];
        
        if(i == self.value || i == 0 || i==self.maximumValue){
            continue;
        }
        [path moveToPoint:center];
        [path addArcWithCenter:center radius:thumbSize.width/3 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        [path closePath];
    }

    shapeLayer.path = path.CGPath;
    
    CGFloat selX = (self.value/self.maximumValue)*self.width;
    
    path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, self.height/2)];
    [path addLineToPoint:CGPointMake(selX, self.height/2)];
    
    leftLayer.path = path.CGPath;
    
    path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(selX, self.height/2)];
    [path addLineToPoint:CGPointMake(self.width, self.height/2)];
    
    rightLayer.path = path.CGPath;
    
}
    
@end
