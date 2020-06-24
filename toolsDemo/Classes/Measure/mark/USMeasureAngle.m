//
//  USMeasureAngle.m
//  WirelessUSG3
//
//  Created by mrq on 2017/11/20.
//  Copyright © 2017年 SonopTek. All rights reserved.
//

#import "USMeasureAngle.h"
#import "MeasureHeader.h"

@implementation USMeasureAngle

- (void)draw:(CAShapeLayer*)layer{
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:layer.path];

    if (firstAnchor && secondAnchor && thirdAnchor) {
        [path moveToPoint:secondAnchor.CGPoint];
        [path addLineToPoint:firstAnchor.CGPoint];
        [path addLineToPoint:thirdAnchor.CGPoint];
    }else if(firstAnchor && secondAnchor){
        [path moveToPoint:firstAnchor.CGPoint];
        [path addLineToPoint:secondAnchor.CGPoint];
    }
    layer.path = path.CGPath;
    
    if (firstAnchor) {
        [firstAnchor drawWith:layer selected:firstAnchor==selectedAnchor];
    }
    if (secondAnchor) {
        [secondAnchor drawWith:layer selected:secondAnchor==selectedAnchor];
    }
    if (thirdAnchor) {
        [thirdAnchor drawWith:layer selected:thirdAnchor==selectedAnchor];
    }
    
    [self drawResult:layer];
}

- (void)drawResult:(CAShapeLayer*)layer{
    CAShapeLayer *resultLayer = [CAShapeLayer layer];

    if (resultSelected) {
        [resultLayer setFillColor:[UIColor colorWithRed:40/255.0 green:100/255.0 blue:40/255.0 alpha:0.7].CGColor];
        UIBezierPath *path = [UIBezierPath bezierPathWithRect: CGRectMake(resultRect->left,resultRect->top,  resultRect->width, resultRect->height)];
        [path closePath];
        resultLayer.path = path.CGPath;
    }
    
    CALayer *imgLayer = [CALayer layer];
    [imgLayer setFrame:CGRectMake(resultRect->left, resultRect->top, kPointSize, kPointSize)];
    imgLayer.contents = (id)anchorImage.CGImage;
    [resultLayer addSublayer:imgLayer];
    
    float angle = [self calcAngle];
    NSString *strArea = [NSString stringWithFormat:@"%@: %.1f°", NSLocalizedString(@"ANGLE", nil),angle];
    
    CGFloat margin =  (kPointSize) + 3;

    UIColor *color = [UIColor whiteColor];

    CATextLayer *textLayer = [self createTextLayerWithString:strArea Frame:CGRectMake(resultRect->left+ margin,resultRect->top+kPointSize, resultRect->width, 20) color:color fontsize:fontSize];
    [resultLayer addSublayer:textLayer];
    
    [layer addSublayer:resultLayer];
}

- (float)calcAngle{
    if (firstAnchor && secondAnchor && thirdAnchor) {

        float x1 = secondAnchor->positionX - firstAnchor->positionX;
        float y1 = secondAnchor->positionY - firstAnchor->positionY;
        float x2 = thirdAnchor->positionX - firstAnchor->positionX;
        float y2 = thirdAnchor->positionY - firstAnchor->positionY;
        
        float x = x1 * x2 + y1 * y2;
        float y = x1 * y2 - x2 * y1;
        
        float angle = acos(x/sqrt(x*x+y*y));
        
        return angle/M_PI*180;
    }
    return 0.0f;
}

- (void)addAnchor:(USPoint *)point{
    if (!firstAnchor) {
        firstAnchor = [[Anchor alloc]initWithX:point.x Y:point.y anchorType:anchorType];
        firstAnchor->anchorImage = anchorImage;
        firstAnchor->selectedImage = selectedImage;
        
        selectedAnchor = nil;
    }else if(!secondAnchor){
        secondAnchor = [[Anchor alloc]initWithX:point.x Y:point.y anchorType:anchorType];
        secondAnchor->anchorImage = anchorImage;
        secondAnchor->selectedImage = selectedImage;
        
        selectedAnchor = nil;
    }else if(!thirdAnchor){
        thirdAnchor = [[Anchor alloc]initWithX:point.x Y:point.y anchorType:anchorType];
        thirdAnchor->anchorImage = anchorImage;
        thirdAnchor->selectedImage = selectedImage;
        
        selectedAnchor = nil;
    }
}

- (BOOL)isCreatYet{
    if (firstAnchor && secondAnchor && thirdAnchor) {
        return YES;
    }
    return NO;
}

- (USMark *)hitTest:(USPoint *)point{
    if (thirdAnchor) {
        selectedAnchor = [thirdAnchor hitTest:point];
        if (selectedAnchor) {
            return self;
        }
    }
    if (secondAnchor) {
        selectedAnchor = [secondAnchor hitTest:point];
        if (selectedAnchor) {
            return self;
        }
    }
    if (firstAnchor) {
        selectedAnchor = [firstAnchor hitTest:point];
        if (selectedAnchor) {
            return self;
        }
    }
    if ([super resultHitTest:point]) {
        resultSelected = YES;
        return self;
    }else{
        resultSelected = NO;
    }
    
    selectedAnchor = nil;
    resultSelected = NO;
    return nil;
}

- (void)deSelect{
    selectedAnchor = nil;
    resultSelected = NO;
}

-(void)setAnchorImage:(UIImage*)image selectedImage:(UIImage*)selectedImg{
    [super setAnchorImage:image selectedImage:selectedImg];
    if (firstAnchor) {
        firstAnchor->anchorImage = anchorImage;
    }
    if (secondAnchor) {
        secondAnchor->anchorImage = anchorImage;
    }
    if(thirdAnchor){
        thirdAnchor->anchorImage = anchorImage;
    }
}

- (Anchor *)getSelectedAnchor{
    return selectedAnchor;
}

@end
