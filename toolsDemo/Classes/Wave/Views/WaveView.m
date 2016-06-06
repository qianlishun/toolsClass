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


@property (nonatomic,copy) NSMutableArray  *points;

@property (nonatomic,assign) int index;

@end

@implementation WaveView

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

    [self setNeedsDisplay];

}


// 绘图
- (void)drawRect:(CGRect)rect{
    [ super drawRect:rect];

    if (self.points.count == 0) {
        return;
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    for (int i = 0; i < self.points.count; i++) {
        NSValue *valueOfPoint = self.points[i];

        CGPoint point = [valueOfPoint CGPointValue];

        float x = point.x;
        float y = point.y;

        if (i == 0) {
            CGContextMoveToPoint(ctx, x, y);
        }

        CGContextAddLineToPoint(ctx, x, y);
    }

    CGContextSetLineWidth(ctx, 1);
    CGContextDrawPath(ctx, kCGPathStroke);

    NSLog(@"pointIndex:%zd", self.index);

}
@end
