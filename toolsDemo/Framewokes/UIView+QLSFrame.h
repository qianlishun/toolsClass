//
//  UIView+HMCategory.h
//  
//
//  Created by AndyDev on 15/9/5.
//  Copyright © 2015年 AndyDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+SDAutoLayout.h"

typedef NS_OPTIONS(NSUInteger, UIBorderSideType) {
    UIBorderSideTypeAll = 0,
    UIBorderSideTypeTop = 1 << 0,
    UIBorderSideTypeBottom = 1 << 1,
    UIBorderSideTypeLeft = 1 << 2,
    UIBorderSideTypeRight = 1 << 3,
};


@interface UIView (QLSFrame)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

- (void)addLineWithRect:(CGRect)rect color:(UIColor*)color;

- (CATextLayer*)createTextLayerWithString:(NSString*)string Frame:(CGRect)frame font:(UIFont*)font  color:(UIColor*)color;

- (UIView *)borderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType;

@end
