//
//  USScrawlGroup.m
//  toolsDemo
//
//  Created by mrq on 2020/6/24.
//  Copyright © 2020 钱立顺. All rights reserved.
//

#import "USScrawlGroup.h"

@implementation USScrawlGroup

- (void)addScraw:(USScrawl *)scraw{
    if (!scrawlList) {
        scrawlList = [NSMutableArray array];
    }
    if (scraw) {
        [scrawlList addObject:scraw];
    }
}

- (void)removeScraw:(USScrawl *)scraw{
    if (scraw && scrawlList && [scrawlList containsObject:scraw]) {
        [scrawlList removeObject:scraw];
    }
}

- (void)removeLastScraw{
    if(scrawlList)
        [scrawlList removeLastObject];
}

- (void)clear{
    if(scrawlList)
        [scrawlList removeAllObjects];
}

- (int)scrawCount{
    if(scrawlList)
        return (int)scrawlList.count;
    return 0;
}

- (void)draw:(CAShapeLayer *)layer{
    if(scrawlList){
        for (int i =0; i<scrawlList.count; i++) {
            USScrawl *scrawl = scrawlList[i];
            [scrawl draw:layer];
        }
        
    }
}

- (USMark *)hitTest:(USPoint *)point{

    return nil;
}

- (BOOL)isCreatYet{
    if(scrawlList) {
        for (int i=0;i<scrawlList.count;i++) {
            USScrawl *scrawl = scrawlList[i];
            if (![scrawl isCreatYet]) {
                return NO;
            }
        }
    }
    return YES;
}

@end
