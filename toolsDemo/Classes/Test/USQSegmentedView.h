//
//  USQSegmentedView.h
//  PVUS
//
//  Created by mrq on 2020/3/4.
//  Copyright © 2020 SonopTek. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface USQSegmentedView : UIControl

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UISegmentedControl *segmentedControl;

/// 当前状态
@property (nonatomic,copy) NSString* currentState;
@property (nonatomic,assign) NSInteger  theCurrentState;

- (void)setName:(NSString *)name state:(NSString *)state;

- (void)setTitleColor:(UIColor*)color forState:(UIControlState)state;
- (void)setDetailColor:(UIColor *)color forState:(UIControlState)state;

- (void)setSegBackgroundColor:(UIColor *)color;
- (void)setSeletedSegBackgroundColor:(UIColor *)color;

- (void)setStateStr:(NSString *)str;
- (void)updateItemList:(NSString*)state;

@end

