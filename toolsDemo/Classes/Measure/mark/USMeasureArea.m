//
//  USMeasureArea.m
//  WirelessUSG3
//
//  Created by mrq on 2017/6/8.
//  Copyright © 2017年 SonopTek. All rights reserved.
//

#import "USMeasureArea.h"
#import "MeasureHeader.h"

@implementation USMeasureArea

- (void)draw:(CAShapeLayer*)layer{
    
    if (firstAnchor && secondAnchor && thirdAnchor) {
        [self drawArea:layer];
    }
    [self drawResult:layer];

    if (firstAnchor) {
        [firstAnchor drawWith:layer selected:firstAnchor==selectedAnchor];
    }
    if (secondAnchor) {
        [secondAnchor drawWith:layer selected:secondAnchor==selectedAnchor];
    }
    if (thirdAnchor) {
        thirdAnchor->positionX = backPoint.x;
        thirdAnchor->positionY = backPoint.y;
        [thirdAnchor drawWith:layer selected:thirdAnchor==selectedAnchor];
    }
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
    
    float area = [self calcArea];
    float circum = [self calcCircum];
    NSString *strArea = [NSString stringWithFormat:@"%@: %.2fcm²",NSLocalizedString(@"AREA", nil),area];
    NSString *strCircum = [NSString stringWithFormat:@"%@:%.2fmm",NSLocalizedString(@"CIRCUM", nil),circum];
    
    CGFloat margin =  (kPointSize) +3;

    UIColor *color = [UIColor whiteColor];
    
    CATextLayer *textLayer1 = [self createTextLayerWithString:strArea Frame:CGRectMake(resultRect->left+ margin,resultRect->top+3, resultRect->width, 20) color:color fontsize:fontSize];
    [resultLayer addSublayer:textLayer1];
    
    CATextLayer *textLayer2 = [self createTextLayerWithString:strCircum Frame:CGRectMake(resultRect->left+ margin,resultRect->top+23, resultRect->width, 20) color:color fontsize:fontSize];
    [resultLayer addSublayer:textLayer2];
    
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

- (void)drawArea:(CAShapeLayer*)layer{
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:layer.path];

    CGPoint point1 = CGPointMake(firstAnchor->positionX, firstAnchor->positionY);
    CGPoint point2 = CGPointMake(secondAnchor->positionX, secondAnchor->positionY);
    CGPoint point3 = CGPointMake(thirdAnchor->positionX, thirdAnchor->positionY);

    float a, b, distance;
    float length =(float) sqrt((point2.x - point1.x) * (point2.x - point1.x) +
                                    (point2.y - point1.y) * (point2.y - point1.y)) / 2;
    float Xlength = point2.x - point1.x;
    float Ylength = point2.y- point1.y;
    float angle =(float) atan(Ylength / Xlength);
    float halfX = (point1.x + point2.x) / 2;
    float halfY = (point1.y + point2.y) / 2;
    if (point2.x == point1.x)
    {
        distance = fabs(point3.x - point1.x);
    } else
    {
        a = (point2.y - point1.y) / (point2.x - point1.x);
        b = (point1.y * point2.x- point1.x* point2.y) / (point2.x - point1.x);
        distance = (float) fabs((a*point3.x - point3.y + b) / sqrt(a * a + 1));
    }
    
    //返回点
    if (!backPoint) {
        backPoint = [USPoint new];
    }
    backPoint.x=(float) (length * cos(-M_PI / 2) * cos(angle) - distance * sin(-M_PI / 2) * sin(angle) + halfX);
    backPoint.y=(float) (length * cos(-M_PI / 2) * sin(angle) + distance * sin(-M_PI / 2) * cos(angle) + halfY);
    
    if (Xlength>0) {
        [path moveToPoint:point2];
    }else {
        [path moveToPoint:point1];
    }
    for (float ti = 0.0; ti < 2 * M_PI; ti += M_PI / 100)
    {
        float pointX = (float) (length * cos(ti) * cos(angle) - distance * sin(ti) * sin(angle) + halfX);
        float pointY = (float) (length * cos(ti) * sin(angle) + distance * sin(ti) * cos(angle) + halfY);
    
        [path addLineToPoint:CGPointMake(pointX, pointY)];
    }
    
    layer.path = path.CGPath;
}

- (float)calcArea{
    if (firstAnchor && secondAnchor && thirdAnchor) {
        float p4X = (firstAnchor->positionX + secondAnchor->positionX) / 2;
        float p4Y = (firstAnchor->positionY + secondAnchor->positionY) / 2;
        
        float longR;
        float shortR;
        longR = (float) sqrt((firstAnchor->positionX - secondAnchor->positionX) *
                                  (firstAnchor->positionX - secondAnchor->positionX)
                                  + (firstAnchor->positionY - secondAnchor->positionY) *
                                  (firstAnchor->positionY - secondAnchor->positionY))/2;
        shortR = (float) sqrt((thirdAnchor->positionX - p4X) * (thirdAnchor->positionX - p4X) +
                                   (thirdAnchor->positionY - p4Y) * (thirdAnchor->positionY - p4Y));
        float area = (float) (M_PI * longR * shortR*scale*scale/100);
        return area;
    }
    return 0.0f;
}

- (float)calcCircum{
    if (firstAnchor && secondAnchor && thirdAnchor) {
        float p4X = (firstAnchor->positionX + secondAnchor->positionX) / 2;
        float p4Y = (firstAnchor->positionY + secondAnchor->positionY) / 2;
        
        float longR;
        float shortR;
        longR = (float) sqrt((firstAnchor->positionX - secondAnchor->positionX) *
                                  (firstAnchor->positionX - secondAnchor->positionX)
                                  + (firstAnchor->positionY - secondAnchor->positionY) *
                                  (firstAnchor->positionY - secondAnchor->positionY))/2;
        shortR = (float) sqrt((thirdAnchor->positionX - p4X) * (thirdAnchor->positionX - p4X) +
                                   (thirdAnchor->positionY - p4Y) * (thirdAnchor->positionY - p4Y));
        float sr=0;
        if (longR>shortR) {
            sr=shortR;
        }else{
            sr=longR;
        }
        float circum = (float) ((2 * M_PI * sr + 4 * fabs(longR - shortR))*scale);
        return circum;
    }
    return 0.0f;
}
@end
