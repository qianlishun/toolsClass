//
//  QRuleSlder.h
//  toolsDemo
//
//  Created by Qianlishun on 2021/8/31.
//  Copyright © 2021 钱立顺. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^QRuleSliderChange)(int value);

@interface QRuleSlider : UIView

@property (copy, nonatomic) QRuleSliderChange _Nullable ruleSliderChange;

@property(nonatomic) float value;                                 // default 0.0. this value will be pinned to min/max
@property(nonatomic) float minimumValue;                          // default 0.0. the current value may change if outside new min value
@property(nonatomic) float maximumValue;                          // default 1.0. the current value may change if outside new max value

@property(nullable, nonatomic,strong) UIColor *minimumTrackTintColor API_AVAILABLE(ios(5.0)) UI_APPEARANCE_SELECTOR;
@property(nullable, nonatomic,strong) UIColor *maximumTrackTintColor API_AVAILABLE(ios(5.0)) UI_APPEARANCE_SELECTOR;


@end
