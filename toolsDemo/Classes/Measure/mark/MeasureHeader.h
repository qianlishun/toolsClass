//
//  Measure.h
//  WirelessUSG3
//
//  Created by mrq on 2017/5/9.
//  Copyright © 2017年 SonopTek. All rights reserved.
//

// 默认字体大小
#define M_FONT_SMALLSIZE_FLOAT 12.0
#define M_FONT_SIZE_FLOAT  15.0
#define M_FONT_BIGSIZE_FLOAT  18.0

// 标记点标识图标大小
#define kPointSize (([UIScreen mainScreen].bounds.size.width>1000) ? 20:15)

#define M_VIEW_TOP ( (mScreenH == 812.0 || mScreenH == 896.0)  ? 44 : 20)
#define M_VIEW_BOTTOM ( (mScreenH == 812.0 || mScreenH == 896.0)  ? 34 : 0)
#define M_VIEW_TOP_h ( (mScreenW == 812.0 || mScreenW == 896.0)  ? 44 : 20)
#define M_VIEW_BOTTOM_h ( (mScreenW == 812.0 || mScreenW == 896.0)  ? 34 : 0)

#define  mScreenSize [UIScreen mainScreen].bounds.size
#define  mScreenW   [UIScreen mainScreen].bounds.size.width
#define  mScreenH   [UIScreen mainScreen].bounds.size.height

#import <Foundation/Foundation.h>
#import "MeasureMenuView.h"
#import "USMeasureLength.h"
#import "USMeasureArea.h"
#import "USMarkGroup.h"
#import "USAnnotateGroup.h"
#import "USScrawlGroup.h"
#import "USMeasureAngle.h"
#import "USMarkView.h"

static NSString *Measure_LEN =  @"LENGTH";
static NSString *Measure_AREA = @"AREA/CIRCUMFERENCE";
static NSString *Measure_ANGLE = @"ANGLE";
static NSString *Measure_CLEAR = @"CLEAR";

typedef enum {
    LEN=0,        // 长度
    ANGLE,       // 角度
    AREA,        // 椭圆面积和周长
    CLEAR = 999,
} MEASURE_TYPES;

@interface MeasureHeader : NSObject

+ (NSInteger)str2Tag:(NSString*)str;

+ (float)getScreenDPI;
@end
