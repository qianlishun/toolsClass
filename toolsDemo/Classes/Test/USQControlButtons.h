//
//  USQControlButtons.h
//  HU01
//
//  Created by Qianlishun on 2022/4/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickBlock)(float value);

@interface USQControlButtons : UIView

@property(nonatomic, copy) NSString *title;
@property(nonatomic, assign) float value;

@property(nonatomic, assign) BOOL enable;

- (instancetype)initWithValue:(float)value min:(float)min max:(float)max step:(float)step valueChange:(nullable ClickBlock)valueChange;

- (void)setValue:(float)value min:(float)min max:(float)max step:(float)step;

@end

NS_ASSUME_NONNULL_END
