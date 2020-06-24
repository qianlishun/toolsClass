//
//  USMeasure.m
//  WirelessUSG3
//
//  Created by mrq on 2017/6/8.
//  Copyright © 2017年 SonopTek. All rights reserved.
//

#import "USMeasure.h"
#import "USMarkGroup.h"
#import "MeasureHeader.h"

@implementation Anchor

- (instancetype)initWithX:(float)x Y:(float)y anchorType:(ANCHOR_TYPE)type{
    self = [super init];
    positionX = x;
    positionY = y;
    anchorType = type;
    
    return self;
}
- (CGPoint)CGPoint{
    return CGPointMake(positionX, positionY);
}
- (Anchor *)hitTest:(USPoint *)point{
    float deltaX = point.x - positionX; deltaX = fabs(deltaX);
    float deltaY = point.y - positionY; deltaY = fabs(deltaY);
    if (deltaX<30 && deltaY< 30) {
        return self;
    }
    return nil;
}

- (void)drawWith:(CAShapeLayer*)layer selected:(BOOL)selected{
    CALayer *imgLayer = [CALayer layer];
    [imgLayer setFrame:CGRectMake(positionX-10, positionY-10, 20, 20)];
    if (selected) {
        imgLayer.contents = (id)selectedImage.CGImage;

    }else{
        imgLayer.contents = (id)anchorImage.CGImage;
    }
    [layer addSublayer:imgLayer];
}

@end

@implementation USRect

- (instancetype)initWithLeft:(float)l top:(float)t width:(float)w height:(float)h{
    self = [super init];

    left = l;   top = t;    width = w;  height = h;
    
    return self;
}
- (USRect *)offsetDx:(float)dx dy:(float)dy{
    USRect *newRect = [[USRect alloc]initWithLeft:left+dx top:top+dy width:width height:height];
    return newRect;
}
- (BOOL)pointInRectX:(float)x y:(float)y{
    if (    (x>=left && x<left+width)
        &&  (y>=top && y<top+height) ){
        return YES;
    }
    return NO;
}

@end

@implementation USMeasure

- (instancetype)init
{
    self = [super init];
    if (self) {
        scale = 1.0f;
        fontSize = M_FONT_SMALLSIZE_FLOAT;
    }
    return self;
}

- (void)setResultFontSize:(float)size{
    fontSize = size;
}

- (USMark *)hitTest:(USPoint *)point{
    return nil;
}
- (int)markType{
    return MARK_MEASURE;
}
- (void)addAnchor:(USPoint *)point{
    
}

- (void)setAnchorType:(ANCHOR_TYPE)type{
    anchorType = type;
}

- (ANCHOR_TYPE)getAnchorType{
    return anchorType;
}

- (void)setAnchorImage:(UIImage *)image selectedImage:(UIImage *)selectedImg{
    anchorImage = image;
    selectedImage = selectedImg;
}

- (void)setResultRect:(USRect *)rect{
    resultRect = rect;
}

- (USRect *)getResultRect{
    return resultRect;
}

- (BOOL)isCreatYet{
    return YES;
}

- (Anchor *)getSelectedAnchor{
    return nil;
}

- (BOOL)isResultSelected{
    return resultSelected;
}

- (void)cancelResultSelected{
    resultSelected = NO;
}

- (BOOL)resultHitTest:(USPoint *)point{
    BOOL ret = NO;
    if (resultRect != nil) {
        if ([resultRect pointInRectX:point.x y:point.y]) {
            ret = YES;
        }
    }
    return ret;
}

- (void)setScale:(float)s{
    scale = s;
}

- (int)calGa:(float)value index:(NSArray *)index ga:(NSArray *)ga{
    if(!index || !ga)
        return 0;
    
    float min=10;
    int nearIndex = 0;
    
    float minValue = [index[0] intValue] - ([index[1] intValue] - [index[0] intValue])/2.0;
    float maxValue = [index.lastObject intValue] +  ([index.lastObject intValue] - [index[index.count-2] intValue] )/2.0;
    
    if(value < minValue ||
       value > maxValue){
        return 0;
    }
    
    for (int i=0; i<index.count; i++) {
        float diff = value - [index[i] floatValue];
        if (fabsf(diff)<min) {
            min = fabs(diff);
            nearIndex = i;
        }
    }
    
    int gaValue = [ga[nearIndex] intValue];
    
    return gaValue;
}


- (int)resultRowCount{
    return 2;
}
@end

