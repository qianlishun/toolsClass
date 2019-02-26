//
//  WaveView.m
//  toolsDemo
//
//  Created by Mr.Q on 16/5/25.
//  Copyright © 2016年 钱立顺. All rights reserved.
//

#import "WaveView.h"

#define MAXVALUE 200
#define ACCURACY 4

#define selfSize self.bounds.size
@interface WaveView ()

@property (nonatomic,strong) CAShapeLayer *shapeLayer;

@property (nonatomic,copy) NSMutableArray  *points;

@property (nonatomic,assign) int index;

@end

@implementation WaveView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        if(!_shapeLayer){
            _shapeLayer = [CAShapeLayer layer];
            _shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
            [_shapeLayer setFrame:self.bounds];
            _shapeLayer.strokeColor = [UIColor blackColor].CGColor;
            _shapeLayer.fillColor = [UIColor clearColor].CGColor;
            [self.layer addSublayer:_shapeLayer];
        }
    }
    return self;
}

- (NSMutableArray *)points{
    if (!_points) {
        NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:selfSize.width / ACCURACY];

        for (int i = 0; i <= selfSize.width / ACCURACY; i++) {
            CGPoint point = CGPointMake(i * ACCURACY , selfSize.height * 0.5);

            [arrM addObject:[NSValue valueWithCGPoint:point]];
        }
        _points = arrM;
    }
    return _points;
}

- (void)refreshWaveWithValue:(float)value{
    if (self.index >= selfSize.width / ACCURACY) {
        self.index = 0;
    }else{
        self.index ++;
    }

    CGPoint point = CGPointMake(self.index * ACCURACY, value / MAXVALUE * selfSize.height);

    self.points[self.index] = [NSValue valueWithCGPoint:point];

    if (self.points.count >= selfSize.width / ACCURACY) {
        // 在这里保存数据
    }

    [self updateLayer];
}

// 绘图
- (void)updateLayer{
    if (self.points.count == 0) {
        return;
    }

    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (int i = 0; i < self.points.count; i++) {
        NSValue *valueOfPoint = self.points[i];
        
        CGPoint point = [valueOfPoint CGPointValue];
    
        if (i == 0) {
            [path moveToPoint:point];
        }else{
            [path addLineToPoint:point];
        }
    }
    self.shapeLayer.path = path.CGPath;
}

- (void)dealloc{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

@end
