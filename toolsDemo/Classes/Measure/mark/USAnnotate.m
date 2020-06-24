//
//  USAnnotate.m
//  WirelessUSG3
//
//  Created by mrq on 2017/6/8.
//  Copyright © 2017年 SonopTek. All rights reserved.
//

#import "USAnnotate.h"
#import "USMeasure.h"
#import "MeasureHeader.h"

@implementation USAnnotate{
    UIColor *textColor;
    float fSize;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        textColor = [UIColor whiteColor];
        fSize = M_FONT_SMALLSIZE_FLOAT;
    }
    return self;
}

- (void)setColor:(UIColor *)color{
    textColor = color;
}

- (void)setFontSize:(float)size{
    fSize = size;
}

-(USMark *)hitTest:(USPoint *)point{
    if (rectPos && point) {
        if ([rectPos pointInRectX:point.x y:point.y]) {
            selected = YES;
            return self;
        }
    }
    return nil;
}

- (void)setRect:(USRect *)rect{
    rectPos = rect;
}

- (USRect *)getRect{
    return rectPos;
}

- (NSString *)getString{
    return annotateString;
}

- (void)setString:(NSString *)str{
    annotateString = str;
}

- (void)deSelect{
    selected = NO;
}

- (void)select{
    selected = YES;
}

- (int)markType{
    return MARK_ANNOTATE;
}

-(BOOL)isCreatYet{
    if (rectPos) {
        return YES;
    }
    return NO;
}

- (void)draw:(CAShapeLayer*)layer{
    if (!rectPos) {
        return;
    }
    if (selected) {
        return;
    }
    NSString *text = @"ANNOTATE";
    if (annotateString && annotateString.length>0) {
        text = annotateString;
    }
    
    CATextLayer *textLayer = [self createTextLayerWithString:text Frame:CGRectMake(rectPos->left,rectPos->top, rectPos->width, rectPos->height)
                                                       color:textColor fontsize:fSize];
    [layer addSublayer:textLayer];
    
}

@end
