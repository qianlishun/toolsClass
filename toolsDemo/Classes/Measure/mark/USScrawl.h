//
//  USScrawl.h
//  toolsDemo
//
//  Created by mrq on 2020/6/24.
//  Copyright © 2020 钱立顺. All rights reserved.
//

#import "USMark.h"
//@class USPoint;

@interface USScrawl : USMark

- (void)setColor:(UIColor*)color;

- (void)setLineWidth:(float)lineWidth;
- (float)getLineWidth;

- (void)addPoint:(USPoint*)point;

- (void)scrawlEnd;

- (USPoint*)getPoint:(int)index;

- (int)pointCount;
@end

