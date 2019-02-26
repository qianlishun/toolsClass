//
//  QGestureRecognizer.m
//  toolsDemo
//
//  Created by mrq on 2019/1/10.
//  Copyright © 2019 钱立顺. All rights reserved.
//

#import "USGestureRecognizer.h"

@interface USGestureRecognizer()<UIGestureRecognizerDelegate>{
    CGPoint _pinchPoint1; // 缩放手势时的坐标点
    CGPoint _pinchPoint2;
}

@property (nonatomic,strong) UIView *theView;

@property (nonatomic,weak) id theDelegate;

@property (nonatomic,strong) UIPanGestureRecognizer *panGes;
@property (nonatomic,strong) UIPinchGestureRecognizer *pinchGes;

@end

@implementation USGestureRecognizer

- (instancetype)initWithTarget:(id)target action:(SEL)action{
    self = [super initWithTarget:target action:action];
    if(self){
        [self initGes];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initGes];
    }
    return self;
}

- (void)initGes{
    _panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    _pinchGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    
    [_panGes setDelegate:self];
    [_pinchGes setDelegate:self];
}

- (void)setView:(UIView *)view{
    if(view && view != _theView){
        [view addGestureRecognizer:_panGes];
        [view addGestureRecognizer:_pinchGes];
        if(_theView){
            [_theView removeGestureRecognizer:_panGes];
            [_theView removeGestureRecognizer:_pinchGes];
            [_theView removeGestureRecognizer:self];
        }
    }
    _theView = view;
}

- (void)setDelegate:(id)delegate{
    _theDelegate = delegate;
}

- (void)setEnabled:(BOOL)enabled{
    [_panGes setEnabled:enabled];
    [_pinchGes setEnabled:enabled];
}

- (BOOL)isEnabled{
    return NO;
}

- (void)onUSGestureTranslation:(CGPoint)translation withUSGestureType:(USGestureType)gestureType{
    if([_theDelegate respondsToSelector:@selector(onUSGestureTranslation:withUSGestureType:)]){
        [_theDelegate onUSGestureTranslation:translation withUSGestureType:gestureType];
    }
}

#pragma mark - GestureRecognizer Action
/**
 *  平移手势响应事件
 *
 *  @param swipe swipe description
 */
- (void)panAction:(UIPanGestureRecognizer *)panGes{

    if(panGes.state == UIGestureRecognizerStateBegan){
        
    }else if (panGes.state == UIGestureRecognizerStateChanged) {
        NSInteger touchNumber = [panGes numberOfTouches];
        CGPoint point = [panGes translationInView:panGes.view];
        if(touchNumber==1){
            [self onUSGestureTranslation:point withUSGestureType:USGestureTypeSinglePan];
        }else if(touchNumber==2){
            [self onUSGestureTranslation:point withUSGestureType:USGestureTypeDoublePan];
        }
        [panGes setTranslation:CGPointZero inView:panGes.view];
    }
}

// 缩放手势响应事件
- (void)pinchAction:(UIPinchGestureRecognizer*)pinchGes{
    if(pinchGes.state == UIGestureRecognizerStateBegan){
        _pinchPoint1 = [pinchGes locationOfTouch:0 inView: pinchGes.view];
        _pinchPoint2 = [pinchGes locationOfTouch:1 inView: pinchGes.view];
        return;
    }else if(pinchGes.numberOfTouches == 2){
        CGPoint point1 = [pinchGes locationOfTouch:0 inView: pinchGes.view];
        CGPoint point2 = [pinchGes locationOfTouch:1 inView: pinchGes.view];
        
        CGFloat diffX = fabs(point1.x - point2.x) - fabs(_pinchPoint1.x - _pinchPoint2.x);
        CGFloat diffY = fabs(point1.y - point2.y) - fabs(_pinchPoint1.y - _pinchPoint2.y);
        
        if(fabs(diffX)>3 || fabs(diffY)>3){
            CGPoint diff = CGPointMake(diffX, diffY);
            [self onUSGestureTranslation:diff withUSGestureType:USGestureTypePinch];
        }
        _pinchPoint1 = [pinchGes locationOfTouch:0 inView: pinchGes.view];
        _pinchPoint2 = [pinchGes locationOfTouch:1 inView: pinchGes.view];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void)dealloc{
    NSLog(@"QGestureRecognizer dealloc");
}

@end
