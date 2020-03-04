
#import "QSlider.h"
#import "UIColor+Common.h"

@implementation QSlider{
    NSArray *valueList;
    UIColor *thumbColor;
    UIColor *lightThumbColor;
    CGSize thumbSize;
    CAShapeLayer *shapeLayer;
    UIView *layerView;
    
}

- (instancetype)initWithFrame:(CGRect)frame list:(NSArray *)list{
    self = [self initWithFrame:frame];
    if(self){
        valueList = list;
        
        self.maximumValue = list.count-1;
        self.minimumValue = 0;
        self.minimumTrackTintColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)setThumbSize:(CGSize)size color:(UIColor*)color highlight:(UIColor*)lightColor{
    thumbSize = size;
    thumbColor = color;
    lightThumbColor = lightColor;
    [self setNeedsLayout];
}

// 返回滑条的frame
- (CGRect)trackRectForBounds:(CGRect)bounds{
    return CGRectMake(bounds.origin.x, bounds.size.height/2 - 2.5 + bounds.origin.y, bounds.size.width, 5); // 这里面的h即为你想要设置的高度。
}
// 返回滑块的frame,滑块滑动不灵敏的话调整它的高度
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value{
    bounds = [super thumbRectForBounds:bounds trackRect:rect value:value]; // 这次如果不调用的父类的方法 Autolayout 倒是不会有问题，但是滑块根本就不动~
    return CGRectMake(bounds.origin.x, bounds.size.height/2 - thumbSize.height/2 + bounds.origin.y, thumbSize.width, thumbSize.height); // w 和 h 是滑块可触摸范围的大小，跟通过图片改变的滑块大小应当一致。
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [super touchesBegan:touches withEvent:event];
   [self sliderTouchBeganMovedEnded:touches withEvent:event isEnd:NO];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [super touchesMoved:touches withEvent:event];
    [self sliderTouchBeganMovedEnded:touches withEvent:event isEnd:NO];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [super touchesEnded:touches withEvent:event];
    [self sliderTouchBeganMovedEnded:touches withEvent:event isEnd:YES];
}

//第三个参数,是否直接回到整点位置(就近取整)
- (void)sliderTouchBeganMovedEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event isEnd:(BOOL)isEnd{
    NSSet *allTouches = event.allTouches;
    UITouch *touch = [allTouches anyObject];;
    CGPoint touchPoint = [touch locationInView:self];
    CGFloat value = (self.maximumValue - self.minimumValue) * ((touchPoint.x- thumbSize.width) / (self.frame.size.width - 2 * thumbSize.width));
    NSInteger finalValue = round(value);   // 对value取整,回到整数位置
   // 我设置的滑条范围是0~4,点击范围外的判断
    finalValue = finalValue <self.minimumValue ? self.minimumValue: finalValue;
    finalValue = finalValue > self.maximumValue ? self.maximumValue :finalValue;
    [UIView animateWithDuration:0.25 animations:^{
        [self setValue:isEnd ? finalValue :value animated:YES];
    }completion:^(BOOL finished) {
        if(finished){
            [self performSelector:@selector(drawDotWithColor:) withObject:thumbColor afterDelay:0.25];
        }
    }];     // 因为加了动画,在ios8,5s下会看到最右边滑动时小范围变白,因为换了滑动条颜色的原因,将滑动条颜色更改为系统颜色,bug消失,或者去掉动画; 或者在互动条下面加一条同等的线条来解决
    if (self.isSliderBallMoved != nil) {
        self.isSliderBallMoved(isEnd,valueList[(int)finalValue]);  // 用来改变界面其他的UI
    }
    if(isEnd){
        UIImage *image = [thumbColor getArcImageWithSize:thumbSize];
        [self setThumbImage:image forState:UIControlStateNormal];
    }else{
        UIImage *imageLight = [lightThumbColor getArcImageWithSize:CGSizeMake(thumbSize.width*1.5, thumbSize.height*1.5)];
        [self setThumbImage:imageLight forState:UIControlStateNormal];
    }
}


- (void)drawDotWithColor:(UIColor*)color{
    if(!shapeLayer){
        layerView = [[UIView alloc]initWithFrame:self.bounds];
        [self addSubview:layerView];
        shapeLayer = [CAShapeLayer layer];
        [layerView.layer addSublayer:shapeLayer];
    }
    [shapeLayer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self bringSubviewToFront:layerView];
    [layerView setFrame:self.bounds];
    [shapeLayer setFrame:self.bounds];
    shapeLayer.fillColor = color.CGColor;

    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (int i = 0; i <= self.maximumValue; i++) {
        CGPoint center = CGPointMake(i* ((self.width) /self.maximumValue), self.height/2);

        NSString *text = [NSString stringWithFormat:@"%@",valueList[i]];
        CATextLayer *layer = [self createTextLayerWithString:text Frame:CGRectMake(center.x - thumbSize.width/2 * (i>0), center.y + thumbSize.height, 30, 20) fontsize:8.0 color:[UIColor whiteColor]];
        [shapeLayer addSublayer:layer];
        
        if(i == self.value){
            continue;
        }
        [path moveToPoint:center];
        [path addArcWithCenter:center radius:thumbSize.width/3 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        [path closePath];
    }

    shapeLayer.path = path.CGPath;
    
}
@end
