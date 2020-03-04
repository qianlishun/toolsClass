
#import <UIKit/UIKit.h>



//这个block是用来在滑动条变的时候所在界面随之变化,本文拖动滑动条字体随着变化###
typedef void(^SliderBallMoved)(BOOL isUpadte , NSNumber *value);

@interface QSlider : UISlider<UIGestureRecognizerDelegate>

@property (copy, nonatomic) SliderBallMoved isSliderBallMoved;

- (instancetype)initWithFrame:(CGRect)frame list:(NSArray*)list;

- (void)setThumbSize:(CGSize)size color:(UIColor*)color highlight:(UIColor*)lightColor;

- (void)drawDotWithColor:(UIColor*)color;

@end
