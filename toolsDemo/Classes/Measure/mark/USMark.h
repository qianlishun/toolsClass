//
//  USMark.h
//  WirelessUSG3
//
//  Created by mrq on 2017/6/8.
//  Copyright © 2017年 SonopTek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USPoint.h"

@class USRawImage;
typedef enum {
    MARK_UNKOWN = 0,
    MARK_MEASURE,
    MARK_ANNOTATE,
    MARK_SCRAWL,
} MARK_TYPE;

@interface USMark : NSObject{
    @protected
    float textSize;
}

- (void)setTextSize:(float)size;

- (USMark*)hitTest:(USPoint*)point;

- (void)deSelect;

- (int)markType;

- (void)draw:(CAShapeLayer*)layer;

- (BOOL)isCreatYet;

- (CATextLayer*)createTextLayerWithString:(NSString*)string Frame:(CGRect)frame color:(UIColor *)color fontsize:(float)fontsize;
@end
