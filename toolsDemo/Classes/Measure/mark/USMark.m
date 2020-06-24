//
//  USMark.m
//  WirelessUSG3
//
//  Created by mrq on 2017/6/8.
//  Copyright © 2017年 SonopTek. All rights reserved.
//

#import "USMark.h"

@implementation USMark

- (instancetype)init
{
    self = [super init];
    if (self) {
        textSize = 30.0f;
    }
    return self;
}

- (void)setTextSize:(float)size{
    textSize = size;
}

- (USMark *)hitTest:(USPoint *)point{
    return nil;
}

- (void)deSelect{
}

- (int)markType{
    return MARK_UNKOWN;
}

- (void)draw:(CAShapeLayer*)layer{
}

- (BOOL)isCreatYet{
    return YES;
}

- (CATextLayer*)createTextLayerWithString:(NSString*)string Frame:(CGRect)frame color:(UIColor *)color fontsize:(float)fontsize{
    CATextLayer *textLayer = [CATextLayer layer];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 1;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName:color,NSParagraphStyleAttributeName:paragraph}];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontsize] range:NSMakeRange(0, string.length)];
    textLayer.string = attributedStr;
    textLayer.bounds = [attributedStr boundingRectWithSize:CGSizeMake(frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    [textLayer setPosition:CGPointMake(frame.origin.x + textLayer.bounds.size.width/2+2,  frame.origin.y+textLayer.bounds.size.height/2)];
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.backgroundColor = [UIColor clearColor].CGColor;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    return textLayer;
}

@end
