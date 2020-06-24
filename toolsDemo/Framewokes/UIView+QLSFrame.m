//
//  UIView+HMCategory.m
//
//
//  Created by AndyDev on 15/9/5.
//  Copyright © 2015年 AndyDev. All rights reserved.
//

#import "UIView+QLSFrame.h"

@implementation UIView (QLSFrame)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (CGFloat)right{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setRight:(CGFloat)right{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)addLineWithRect:(CGRect)rect color:(UIColor *)color{
    CAShapeLayer *l = [CAShapeLayer layer];
    l.strokeColor = color.CGColor;
    l.lineWidth = rect.size.height;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y)];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width , rect.origin.y)];
    l.path = path.CGPath;
    [self.layer addSublayer:l];
}


- (CATextLayer*)createTextLayerWithString:(NSString*)string Frame:(CGRect)frame fontsize:(float)fontsize color:(UIColor*)color{
    CATextLayer *textLayer = [CATextLayer layer];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 1;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName:color,NSParagraphStyleAttributeName:paragraph}];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontsize] range:NSMakeRange(0, string.length)];
    textLayer.string = attributedStr;
    textLayer.bounds = [attributedStr boundingRectWithSize:CGSizeMake(frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    [textLayer setPosition:CGPointMake(frame.origin.x + textLayer.bounds.size.width/2+2,  frame.origin.y)];
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.backgroundColor = [UIColor clearColor].CGColor;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    return textLayer;
}
@end
