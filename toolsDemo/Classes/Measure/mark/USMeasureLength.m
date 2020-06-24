//
//  USMeasureLength.m
//  WirelessUSG3
//
//  Created by mrq on 2017/6/8.
//  Copyright © 2017年 SonopTek. All rights reserved.
//

#import "USMeasureLength.h"
#import "MeasureHeader.h"

@implementation USMeasureLength

- (void)draw:(CAShapeLayer*)layer{
    //  绘制直线
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:layer.path];
    if (firstAnchor && secondAnchor) {
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
    
    NSString *str = [NSString stringWithFormat:@"%@: %.2fmm",NSLocalizedString(@"LENGTH", nil),[self calcLength]];
    CGFloat margin = (kPointSize) + 3;

    UIColor *color = [UIColor whiteColor];
    
    CATextLayer *textLayer = [self createTextLayerWithString:str Frame:CGRectMake(resultRect->left+ margin,resultRect->top + (kPointSize), resultRect->width, 20) color:color fontsize:fontSize];
    [resultLayer addSublayer:textLayer];
    
    [layer addSublayer:resultLayer];
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
    }
}

- (BOOL)isCreatYet{
    if (firstAnchor && secondAnchor) {
        return YES;
    }
    return NO;
}

- (USMark *)hitTest:(USPoint *)point{
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
}

- (Anchor *)getSelectedAnchor{
 
    return selectedAnchor;
}

- (float)calcLength{
    float length = 0.0f;
    if (firstAnchor && secondAnchor) {
        float deltaX = firstAnchor->positionX - secondAnchor->positionX;
        float deltaY = firstAnchor->positionY - secondAnchor->positionY;
        length = (float)sqrt(deltaX * deltaX + deltaY * deltaY)*scale;
    }
    return length;
}

@end
