//
//  USRingView.m
//  WirelessKUS3
//
//  Created by Qianlishun on 2021/6/18.
//  Copyright © 2021 MrQ. All rights reserved.
//

#import "USRingView.h"
#import "UIColor+Common.h"

typedef enum : NSUInteger {
    RingCenterLoc_left,
    RingCenterLoc_right,
    RingCenterLoc_top,
    RingCenterLoc_bottom
} RingCenterLoc;

@interface USRingView (){
    CAShapeLayer *outerLayer;
    CAShapeLayer *centerLayer;
    CAShapeLayer *lineLayer;
}

@property (nonatomic,assign) CGPoint arcCenter;
@property (nonatomic,assign) CGFloat arcRadius;

@property (nonatomic,assign) RingCenterLoc centerLoc;


@end

@implementation USRingView

//- (instancetype)initWithFrame:(CGRect)frame center:(CGPoint)center radius:(CGFloat)radius outerColor:(UIColor*)outerColor centerColor:(UIColor*)centerColor lineColor:(UIColor*)lineColor{

- (void)awakeFromNib{
    [super awakeFromNib];
    
}


- (void)initForNib{
    CGPoint center = CGPointMake(0, self.height/2);
    float radius = self.width;

    if(kISiPhone){
        center = CGPointMake(self.width/2.0, self.height);
        radius = self.height;
    }
    self.backgroundColor = [UIColor clearColor];
    [self initUIWithFrame:self.frame center:center radius:radius];
}

- (instancetype)initWithFrame:(CGRect)frame center:(CGPoint)center radius:(CGFloat)radius{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUIWithFrame:frame center:center radius:radius];
        
    }
    return self;
}

- (void)initUIWithFrame:(CGRect)frame center:(CGPoint)center radius:(CGFloat)radius{
    self.clipsToBounds = YES;
    
    self.arcCenter = center;
    self.arcRadius = radius;
    
    outerLayer = [CAShapeLayer layer];
//    outerLayer.frame = self.bounds;
    outerLayer.fillColor = [UIColor colorWithRGBA:@[@66,@66,@66]].CGColor;

    lineLayer = [CAShapeLayer layer];
//    lineLayer.frame = self.bounds;
    lineLayer.lineWidth = 2.0;
    lineLayer.strokeColor = [UIColor colorWithRGBA:@[@244,@244,@244]].CGColor;
    
    centerLayer = [CAShapeLayer layer];
//    centerLayer.frame = self.bounds;
    centerLayer.fillColor = [UIColor colorWithRGBA:@[@33,@33,@33]].CGColor;

    
    [self.layer addSublayer:outerLayer];
    [self.layer addSublayer:lineLayer];
    [self.layer addSublayer:centerLayer];

    
    /*
              1.5PI
                |
         1PI -     - 0PI
                |
              0.5PI
     */
    
    float startAngle = 0, endAngle = 0;
    CGPoint p1 = center; CGPoint p2 = center;
    if(self.arcCenter.x == 0 && self.arcCenter.y == self.height/2){
        self.centerLoc = RingCenterLoc_left;
        
        startAngle = M_PI * 1.5; endAngle = M_PI * 0.5;

        p1 = CGPointMake(center.x + sqrt(3 * radius*radius)/2, center.y - radius/2);
        p2 = CGPointMake(center.x + sqrt(3 * radius*radius)/2, center.y + radius/2);
        
    }else if(self.arcCenter.x == self.arcRadius && self.arcCenter.y == self.height){
        self.centerLoc = RingCenterLoc_bottom;
        
        startAngle = M_PI; endAngle = 0;

        p1 = CGPointMake( center.x - radius/2, center.y - sqrt(3 * radius*radius)/2);
        p2 = CGPointMake( center.x + radius/2, center.y - sqrt(3 * radius*radius)/2);

    }else if(self.arcCenter.x == self.width && self.arcCenter.y == self.arcRadius){
        self.centerLoc = RingCenterLoc_right;
        
        startAngle = M_PI * 0.5; endAngle = M_PI*1.5;

        p1 = CGPointMake(center.x - sqrt(3 * radius*radius)/2, center.y - radius/2);
        p2 = CGPointMake(center.x - sqrt(3 * radius*radius)/2, center.y + radius/2);
        
    }else if(self.arcCenter.x == self.arcRadius && self.arcCenter.y == 0){
        self.centerLoc = RingCenterLoc_top;
        
        startAngle = 0; endAngle = M_PI;

        p1 = CGPointMake( center.x - radius/2, center.y + sqrt(3 * radius*radius)/2);
        p2 = CGPointMake( center.x + radius/2, center.y + sqrt(3 * radius*radius)/2);
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    outerLayer.path = path.CGPath;

    path = [UIBezierPath bezierPathWithArcCenter:center radius:radius/2 startAngle:startAngle endAngle:endAngle clockwise:YES];
    centerLayer.path = path.CGPath;
    
    path = [UIBezierPath bezierPath];
    [path moveToPoint:center];
    [path addLineToPoint:p1];

    [path moveToPoint:p2];
    [path addLineToPoint:center];
    
    lineLayer.path = path.CGPath;
}

- (void)setOuterColor:(UIColor *)color{
    outerLayer.fillColor = color.CGColor;
}

- (void)setCenterColor:(UIColor *)color{
    centerLayer.fillColor = color.CGColor;
}

- (void)setLineColor:(UIColor *)color{
    lineLayer.strokeColor = color.CGColor;
}

- (void)setCenterView:(UIView *)view{

    if(_centerView && _centerView != view && _centerView.superview != self){
        [_centerView removeFromSuperview];
    }else{
        _centerView = view;
        [self addSubview:view];
        
        // (0, radius)   (width,radius)   (radius,height)   (radius,0)
        if(self.centerLoc == RingCenterLoc_left){
            
            [view setFrame:CGRectMake(self.arcCenter.x, self.arcCenter.y - self.arcRadius/4*0.86, self.arcRadius/2*0.86, self.arcRadius/2*0.86)];
            
        }else if(self.centerLoc == RingCenterLoc_bottom){
            
            [view setFrame:CGRectMake(self.arcCenter.x - self.arcRadius/4*0.86, self.arcCenter.y - self.arcRadius/2*0.86, self.arcRadius/2*0.86, self.arcRadius/2*0.86)];
            
        }else if(self.centerLoc == RingCenterLoc_right){
            
            [view setFrame:CGRectMake(self.arcCenter.x - self.arcRadius/2*0.86 , self.arcCenter.y - self.arcRadius/4*0.86, self.arcRadius/2*0.86, self.arcRadius/2*0.86)];

        }else if(self.centerLoc == RingCenterLoc_top){
            
            [view setFrame:CGRectMake(self.arcCenter.x - self.arcRadius/4*0.86, self.arcCenter.y, self.arcRadius/2*0.86, self.arcRadius/2*0.86)];
            
        }
    }
}

- (void)setViewList:(NSArray<UIView *> *)views{
    for (UIView *view in views) {
        if([_viewList containsObject:view] && view.superview != self){
            [view removeFromSuperview];
        }else{
            [self addSubview:view];
        }
    }
    _viewList = views;
    if(_viewList.count<3)
        return;
    
    CGFloat radius = self.arcRadius*0.75;

    CGFloat angelMargin = -M_PI / 3;
    float startPoint = 3.5;
    
    if(self.centerLoc == RingCenterLoc_left){
        angelMargin = -M_PI / 3;
        startPoint = 3.5;
    }else if(self.centerLoc == RingCenterLoc_right){
        angelMargin = M_PI / 3;
        startPoint = 3.5;
    }else if(self.centerLoc == RingCenterLoc_bottom){
        angelMargin = -M_PI / 3;
        startPoint = 2;
    }else if(self.centerLoc == RingCenterLoc_top){
        angelMargin = M_PI / 3;
        startPoint = 5;
    }
    
    int offsetX = 0;
    if(self.centerLoc == RingCenterLoc_bottom ||
       self.centerLoc == RingCenterLoc_right){
        offsetX = radius/20;
    }else{
        offsetX = -radius/20;
    }
    
    int width = radius/2*1.15;
    
    for (int i = 0; i < 3 ; i ++) {
        UIView *view = views[i];

        CGFloat x = sin( (i+startPoint) * angelMargin) * radius;
        CGFloat y = cos( (i+startPoint) * angelMargin) * radius;

        // 矫正一下位置
        if(i == 0){
            x -= offsetX;
        }else if(i == 2){
            x += offsetX;
        }
        
        [view setBounds:CGRectMake(0, 0, width, width)];
        view.center = CGPointMake(self.arcCenter.x + x, self.arcCenter.y + y);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    // 通过计算落点与中心点距离及夹角判断在哪一块区域
//    CGPoint p1 = [[touches anyObject]locationInView:self];

    if(![self pointInside:point withEvent:event])
        return nil;
    
    UIView* result = [super hitTest:point withEvent:event];
    if(result == nil)
        return nil;
    
    CGPoint p1 = point;

    float  distance = [self calcDistance:p1 p2:self.arcCenter];
    if(distance < self.arcRadius/2.0){
        if([_centerView isKindOfClass:[UIControl class]]){
            [(UIControl*)_centerView sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        return _centerView;
    }else if(distance > self.arcRadius){
        return nil;
    }
    
    CGPoint p2 = CGPointMake(0, 0);
    
    if(self.centerLoc == RingCenterLoc_top || self.centerLoc == RingCenterLoc_bottom){
        p2 = CGPointMake(0, self.arcCenter.y);
    }else if(self.centerLoc == RingCenterLoc_left || self.centerLoc == RingCenterLoc_right){
        p2 = CGPointMake(self.arcCenter.x, 0);
    }
    
    float angle = [self calcAngleP1:p1 p2:p2 center:self.arcCenter];
        
    NSUInteger index = -1;
    if(angle > 0 && angle < 60){
        index = 0;
    }else if(angle >= 60 && angle <= 120){
        index = 1;
    }else if(angle > 120 && angle < 180){
        index = 2;
    }else{
        return result;
    }
    
    UIView *view = _viewList[index];
    
//    if([view isKindOfClass:[UIControl class]]){
//        [(UIControl*)view sendActionsForControlEvents:UIControlEventTouchUpInside];
//    }
    
    return view;
}

- (float)calcAngleP1:(CGPoint)p1 p2:(CGPoint)p2  center:(CGPoint)center{
    
    float x1 = p1.x - center.x;
    float y1 = p1.y - center.y;
    float x2 = p2.x - center.x;
    float y2 = p2.y - center.y;
    
    float x = x1 * x2 + y1 * y2;
    float y = x1 * y2 - x2 * y1;
    
    float angle = acos(x/sqrt(x*x+y*y));
    
    return angle/M_PI*180;
}

- (float)calcDistance:(CGPoint)p1 p2:(CGPoint)p2{
    
    float deltaX = p1.x - p2.x;
    float deltaY = p1.y - p2.y;
    
    float distance = (float)sqrt(deltaX * deltaX + deltaY * deltaY);

    return distance;
}

- (void)layoutSubviews{
    if(self.arcRadius == 0 && centerLayer == nil){
        [self initForNib];
        [self setCenterView:self.centerView];
        [self setViewList:self.viewList];
    }
}
@end
