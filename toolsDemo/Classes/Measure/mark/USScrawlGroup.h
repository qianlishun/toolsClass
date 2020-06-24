//
//  USScrawlGroup.h
//  toolsDemo
//
//  Created by mrq on 2020/6/24.
//  Copyright © 2020 钱立顺. All rights reserved.
//

#import "USScrawl.h"

@interface USScrawlGroup : USScrawl{
    @protected
    NSMutableArray<USScrawl*> *scrawlList;
}

- (void)addScraw:(USScrawl*)scraw;

- (void)removeScraw:(USScrawl*)scraw;

- (void)removeLastScraw;

- (void)clear;

- (int)scrawCount;

@end

