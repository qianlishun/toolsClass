//
//  USMeasureGroup.h
//  WirelessUSG3
//
//  Created by mrq on 2017/6/8.
//  Copyright © 2017年 SonopTek. All rights reserved.
//

#import "USMeasure.h"

static int anchorTypeStore[4] = {0,1,2,3};

@class USMeasureTrace;

@interface USMeasureGroup : USMeasure{
    @protected
    NSMutableArray<USMeasure*> *measureList;
    int validAnchorTypeCount;
}

- (int)rentAnchorType;
- (void)returnAnchorType:(ANCHOR_TYPE)type;

- (void)addMeasure:(USMeasure*)measure;

- (USMeasure*)getMeasure:(int)index;

- (void)removeMeasure:(USMeasure*)measure;

- (void)clear;

- (int)measureCount;

+ (void)setTopResultRect:(USRect*)rect;
+ (const USRect*)getTopResultRect;

@end
