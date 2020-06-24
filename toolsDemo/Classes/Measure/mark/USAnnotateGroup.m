//
//  USAnnotateGroup.m
//  WirelessUSG3
//
//  Created by mrq on 2017/6/8.
//  Copyright © 2017年 SonopTek. All rights reserved.
//

#import "USAnnotateGroup.h"

@implementation USAnnotateGroup

- (void)addAnnotate:(USAnnotate *)annotate{
    if (!annotateList) {
        annotateList = [NSMutableArray array];
    }
    if (annotate) {
        [annotateList addObject:annotate];
    }
}

- (void)removeAnnotate:(USAnnotate *)annotate{
    if (!annotate) {
        return;
    }
    if (!annotateList) {
        return;
    }
    for (int i = 0; i<annotateList.count; i++) {
        USAnnotate *ann = annotateList[i];
        if (ann == annotate) {
            [annotateList removeObject:annotate];
            break;
        }
    }
    
}

- (void)clear{
    if (annotateList) {
        [annotateList removeAllObjects];
    }
}

- (int)annotateCount{
    if (annotateList) {
        return (int)annotateList.count;
    }
    return 0;
}

-(void)draw:(CAShapeLayer*)layer{
    if (annotateList) {
        for (int i =0; i<annotateList.count; i++) {
            USAnnotate *ann = annotateList[i];
            [ann draw:layer];
        }
        
    }
}

- (USMark *)hitTest:(USPoint *)point{
    if (annotateList) {
        for (int i=0;i<annotateList.count;i++) {
            USAnnotate *ann = annotateList[i];
            USMark *ret = [ann hitTest:point];
            if (ret) {
                return ret;
            }
        }
    }
    return nil;
}


- (void)deSelect{
    if (annotateList) {
        for (int i=0;i<annotateList.count;i++) {
            USAnnotate *ann = annotateList[i];
            [ann deSelect];
        }
    }
}

- (BOOL)isCreatYet{
    if(annotateList) {
        for (int i=0;i<annotateList.count;i++) {
            USAnnotate *ann = annotateList[i];
            if (![ann isCreatYet]) {
                return NO;
            }
        }
    }
    return YES;
}


@end
