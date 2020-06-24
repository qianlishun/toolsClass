//
//  Measure.m
//  WirelessUSG3
//
//  Created by mrq on 2017/5/9.
//  Copyright © 2017年 SonopTek. All rights reserved.
//

#import "MeasureHeader.h"
#import "USPoint.h"

@interface MeasureHeader()

@end

@implementation MeasureHeader

+ (NSInteger)str2Tag:(NSString *)str{
    if([str isEqualToString:Measure_LEN]){
        return LEN;
    }else if([str isEqualToString:Measure_AREA]){
        return AREA;
    }else if([str isEqualToString:Measure_CLEAR]){
        return CLEAR;
    }else if([str isEqualToString:Measure_ANGLE]){
        return ANGLE;
    }
    return -1;
}

+ (float)getScreenDPI{
    float dpi;
    float scale = 1;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
//        scale = [[UIScreen mainScreen] scale];  //得到屏幕分辨率
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        dpi = 132 * scale;
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        dpi = 163 * scale;
    } else {
        dpi = 160 * scale;
    }
    return dpi;
}
@end
