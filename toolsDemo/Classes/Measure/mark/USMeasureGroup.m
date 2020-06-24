//
//  USMeasureGroup.m
//  WirelessUSG3
//
//  Created by mrq on 2017/6/8.
//  Copyright © 2017年 SonopTek. All rights reserved.
//

#import "USMeasureGroup.h"
#import "USMeasureLength.h"
#import "USMeasureArea.h"
#import "USMeasureAngle.h"

static USRect const *topResultRect;

@interface USMeasureGroup (){
    BOOL _isEFW;
}

@end
@implementation USMeasureGroup

- (instancetype)init
{
    self = [super init];
    if (self) {
        validAnchorTypeCount = 4;
        topResultRect = [[USRect alloc]initWithLeft:0 top:0 width:0 height:0];
    }
    return self;
}

- (int)rentAnchorType{
    if (validAnchorTypeCount > 0) {
        validAnchorTypeCount--;
        return anchorTypeStore[validAnchorTypeCount];
    }
    return -1;
}

- (void)returnAnchorType:(ANCHOR_TYPE)type{
    if (type < ANCHOR_TYPE0 || type > ANCHOR_TYPE3) {
        return;
    }
    if (validAnchorTypeCount > 0) {
        for (int i=0;i<validAnchorTypeCount;i++) {
            if (type == anchorTypeStore[i]) {
                return;
            }
        }
    }
    anchorTypeStore[validAnchorTypeCount] = type;
    validAnchorTypeCount++;
}

- (USMeasure*)getMeasure:(int)index{
    if (!measureList || index < 0 || index > measureList.count-1) {
        return nil;
    }
    return measureList[index];
}

- (void)addMeasure:(USMeasure *)measure{
    if (!measureList) {
        measureList = [NSMutableArray new];
    }
    if (measure) {
        [measure setAnchorType:[self rentAnchorType]];
        [measureList addObject:measure];
    }
}

- (void)removeMeasure:(USMeasure *)measure{
    if (!measure) {
        return;
    }
    if (!measureList) {
        return;
    }
    for (int i=0;i<measureList.count;i++) {
        USMeasure *mea = measureList[i];
        if (mea == measure) {
            [self returnAnchorType:[measure getAnchorType]];
            [measureList removeObject:mea];
            break;
        }
    }
//    if ([measure isKindOfClass:[USMeasureEFW class]]) {
//        _isEFW = NO;
//    }
}

- (void)clear{
    if (measureList) {
        for (USMeasure *mr in measureList) {
            [self returnAnchorType:[mr getAnchorType]];
        }
        [measureList removeAllObjects];
    }
    _isEFW = NO;
}

- (int)measureCount{
    if (measureList) {
        return (int)measureList.count;
    }
    return 0;
}

+ (void)setTopResultRect:(USRect *)rect{
    topResultRect = rect;
}

+ (USRect const *)getTopResultRect{
    return topResultRect;
}

- (void)draw:(CAShapeLayer*)layer{
    int x = (topResultRect->top>200 && topResultRect->width==150) ? -1 : 1;
    if (measureList) {
        USRect const  *firstRect = topResultRect;
        float height = topResultRect->height;
        for (int i = 0; i < measureList.count; i++) {
            USMeasure *measure = measureList[i];
            if([measure resultRowCount]==4){
                height = 80;
            }else if ([measure resultRowCount]==2) {
                height = 43+(x+1)*4;
            }else{
                height = topResultRect->height;
            }
            USRect *preRect;
            if ((!_isEFW && i>0) || (_isEFW && i>1)) {
                preRect = measureList[i-1].getResultRect;
            }else{
                preRect = [firstRect offsetDx:0 dy:0];
                preRect->top -= x*height;
            }
            
            CGFloat margin = x>0 ? preRect->height : height;
            USRect *rect = [preRect offsetDx:0 dy:x*(margin+6)];
            rect->height = height;
//            if ([measure isKindOfClass:[USMeasureEFW class]]) {
//                rect->height = 3*topResultRect->height + height;
//                rect->top = topResultRect->top;
//            }
            
            [measure setResultRect:rect];
            
//            if (_isEFW) {
//                if(i==3){
//                    float HC = [(USMeasureHC *)measureList[1] calcCircum];
//                    float AC = [(USMeasureAC *)measureList[2] calcCircum];
//                    float FL = [(USMeasureFL *)measureList[3] calcLength];
//                    [(USMeasureEFW *)measureList[0] setHC:HC AC:AC FL:FL];
//                }
//                if(i!=0) [measure cancelResultSelected];
//            }
            
            [measure draw:layer];
        }
    }
}

- (USMark *)hitTest:(USPoint *)point{
    USMeasure *ret = nil;
    USMeasure *resultMeasure = nil;
    if (measureList) {
        for (int i=0;i<measureList.count;i++) {
            USMeasure *mea = measureList[i];
            USMeasure *temp = (USMeasure*)[mea hitTest:point];
            if (temp) {
                ret = temp;
                if (!temp.isResultSelected) {
                    [resultMeasure cancelResultSelected];
                    break;
                }else{
//                    if (_isEFW){
//                        if([temp isKindOfClass:[USMeasureEFW class]])
//                            resultMeasure = temp;
//                    }else{
                        resultMeasure = temp;
//                    }
                }
            }
        }
        if (ret.isResultSelected) {
            ret = resultMeasure;
        }
    }
    return ret;
}

- (void)deSelect{
    if (measureList) {
        for (int i=0;i<measureList.count;i++) {
            USMeasure *mea = measureList[i];
            [mea deSelect];
        }
    }
}

- (BOOL)isCreatYet{
    if(measureList) {
        for (int i=0;i<measureList.count;i++) {
            USMeasure *meas = measureList[i];
            if (![meas isCreatYet]) {
                return NO;
            }
        }
    }
    return YES;
}


@end
