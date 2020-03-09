#import <UIKit/UIKit.h>

@interface UIImage (AssetUrl)

- (UIImage*)scaleToFitForHeight;

// 缩放图片
- (UIImage *)scaleToSize:(CGSize)size;

+ (UIImage*)createImageWithColor:(UIColor*)color;

@end
