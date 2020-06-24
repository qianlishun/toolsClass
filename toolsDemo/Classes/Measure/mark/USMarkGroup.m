//
//  USMarkGroup.m
//  WirelessUSG3
//
//  Created by mrq on 2017/6/8.
//  Copyright © 2017年 SonopTek. All rights reserved.
//

#import "USMarkGroup.h"

@implementation USMarkGroup

- (instancetype)init
{
    self = [super init];
    if (self) {
        measureGroup = [USMeasureGroup new];
        annotateGroup = [USAnnotateGroup new];
        scrawlGroup = [USScrawlGroup new];
    }
    return self;
}
- (USMark *)hitTest:(USPoint *)point{
    USMark *ret = [annotateGroup hitTest:point];
    if (ret != nil) {
        return ret;
    }
    ret = [measureGroup hitTest:point];
    return ret;
}

- (void)deSelect{
    [measureGroup deSelect];
    [annotateGroup deSelect];
}

- (void)addMark:(USMark *)marker{
    if (marker.markType == MARK_ANNOTATE) {
        [annotateGroup addAnnotate:(USAnnotate*)marker];
    } else if (marker.markType == MARK_MEASURE) {
        [measureGroup addMeasure:(USMeasure*)marker];
    }else if(marker.markType == MARK_SCRAWL){
        [scrawlGroup addScraw:(USScrawl*)marker];
    }
}

- (void)removeMark:(USMark *)marker{
    if (marker.markType == MARK_ANNOTATE) {
        [annotateGroup removeAnnotate:(USAnnotate*)marker];
    }else if(marker.markType == MARK_MEASURE){
        [measureGroup removeMeasure:(USMeasure*)marker];
    }else if(marker.markType == MARK_SCRAWL){
        [scrawlGroup removeScraw:(USScrawl*)marker];
    }
}
- (void)clear{
    [measureGroup clear];
    [annotateGroup clear];
    [scrawlGroup clear];
}

- (int)markCount:(MARK_TYPE)markType{
    if (markType == MARK_ANNOTATE) {
        return [annotateGroup annotateCount];
    } else if (markType == MARK_MEASURE) {
        return [measureGroup measureCount];
    } else if(markType == MARK_SCRAWL){
        return [scrawlGroup scrawCount];
    }else{
        return [annotateGroup annotateCount] + [measureGroup measureCount];
    }
}

- (void)draw:(CAShapeLayer*)layer{
    [measureGroup draw:layer];
    [annotateGroup draw:layer];
    [scrawlGroup draw:layer];
}

- (BOOL)isCreatYet{
    if (![measureGroup isCreatYet]) {
        return NO;
    }else if(![scrawlGroup isCreatYet]){
        return NO;
    }
    return [annotateGroup isCreatYet];
}

@end
