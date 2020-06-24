//
//  USScrawl.m
//  toolsDemo
//
//  Created by mrq on 2020/6/24.
//  Copyright © 2020 钱立顺. All rights reserved.
//

#import "USScrawl.h"

@implementation USScrawl{
    NSMutableArray<USPoint*> *pointList;
    UIColor *lineColor;
    BOOL end;
    float lWidth;
}

- (void)addPoint:(USPoint *)point{
    [pointList addObject:point];
}

- (USPoint*)getPoint:(int)index{
    if(index < pointList.count-1)
        return pointList[index];
    return nil;
}

- (int)pointCount{
    return (int)pointList.count;
}

- (void)scrawlEnd{
    end = YES;
}

-(void)setColor:(UIColor *)color{
    lineColor = color;
}

- (void)setLineWidth:(float)lineWidth{
    lWidth = lineWidth;
}
- (float)getLineWidth{
    return lWidth;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        lineColor = [UIColor whiteColor];
        pointList = [NSMutableArray arrayWithCapacity:10];
        lWidth = 2.0;
    }
    return self;
}

- (void)draw:(CAShapeLayer *)layer{
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    [lineLayer setLineWidth:lWidth];
    [lineLayer setStrokeColor:lineColor.CGColor];
    lineLayer.lineDashPattern = @[@1,@0];
    [lineLayer setFillColor:[UIColor clearColor].CGColor];
    
    if ([pointList count]>=2){
        UIBezierPath *path = [UIBezierPath bezierPath];
     
        [path moveToPoint:pointList[0].CGPoint];
        for (int i=1;i<[pointList count];i++) {
            USPoint *point = pointList[i];
            USPoint *lastPoint = pointList[i-1];

            if(lastPoint.x == -1 && lastPoint.y == -1){
                [path moveToPoint:point.CGPoint];
            }else if(point.x != -1 && point.y != -1){
                [path addLineToPoint:point.CGPoint];
            }
        }
        
        lineLayer.path = path.CGPath;
    }
    
    [layer addSublayer:lineLayer];
}

- (int)markType{
    return MARK_SCRAWL;
}

- (BOOL)isCreatYet{
    return end;
}

- (USMark *)hitTest:(USPoint *)point{
    return nil;
}
@end
