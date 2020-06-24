//
//  USMarkGroup.h
//  WirelessUSG3
//
//  Created by mrq on 2017/6/8.
//  Copyright © 2017年 SonopTek. All rights reserved.
//

#import "USMark.h"
#import "USMeasureGroup.h"
#import "USAnnotateGroup.h"
#import "USScrawlGroup.h"
@class USMeasureTrace;

@interface USMarkGroup : USMark{
    @public
    USMeasureGroup *measureGroup;
    USAnnotateGroup *annotateGroup;
    USScrawlGroup *scrawlGroup;
}

- (void)addMark:(USMark*)marker;
- (void)removeMark:(USMark*)marker;
- (void)clear;
- (int)markCount:(MARK_TYPE)markType;

@end
