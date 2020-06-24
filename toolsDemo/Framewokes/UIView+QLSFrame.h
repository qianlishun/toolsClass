//
//  UIView+HMCategory.h
//  
//
//  Created by AndyDev on 15/9/5.
//  Copyright © 2015年 AndyDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (QLSFrame)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

- (void)addLineWithRect:(CGRect)rect color:(UIColor*)color;


- (CATextLayer*)createTextLayerWithString:(NSString*)string Frame:(CGRect)frame fontsize:(float)fontsize color:(UIColor*)color;
@end
