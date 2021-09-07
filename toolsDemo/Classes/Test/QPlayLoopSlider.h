//
//  QPlayLoopView.h
//  toolsDemo
//
//  Created by Qianlishun on 2021/8/31.
//  Copyright © 2021 钱立顺. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^QPlayLoopChange)(int value);

@interface QPlayLoopSlider : UIView

@property (copy, nonatomic) QPlayLoopChange _Nullable playLoopChange;

@property(nonatomic) float value;                                 // default 0.0. this value will be pinned to min/max
@property(nonatomic) float minimumValue;                          // default 0.0. the current value may change if outside new min value
@property(nonatomic) float maximumValue;                          // default 1.0. the current value may change if outside new max value

@property(nullable, nonatomic,strong) UIColor *minimumTrackTintColor API_AVAILABLE(ios(5.0)) UI_APPEARANCE_SELECTOR;
@property(nullable, nonatomic,strong) UIColor *maximumTrackTintColor API_AVAILABLE(ios(5.0)) UI_APPEARANCE_SELECTOR;


@end

NS_ASSUME_NONNULL_END
