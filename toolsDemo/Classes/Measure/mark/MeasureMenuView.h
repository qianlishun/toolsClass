//
//  MeasureMenu.h
//  WirelessUSG3
//
//  Created by mrq on 2019/10/21.
//  Copyright © 2019 SonopTek. All rights reserved.
//

// 分割线颜色
#define kSeparatorColor [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0]

#import <UIKit/UIKit.h>
@class MeasureMenuView;


@protocol MeasureMenuViewDelegate<NSObject>
- (void)measureSelect:(NSUInteger)tag menuView:(MeasureMenuView*)view;
@end

@interface MeasureMenuView : UIView
@property (nonatomic,weak) id delegate;

@property (nonatomic,strong) NSArray *list;

- (void)setTitleColor:(UIColor *)tColor bgColor:(UIColor*)bgColor;
- (void)setMeasureList:(NSArray *)list andRowSize:(CGSize)size;

@end

