#import <UIKit/UIKit.h>

@interface UIImage (AssetUrl)

- (UIImage*)scaleToFitForHeight;

// 缩放图片
- (UIImage *)scaleToSize:(CGSize)size;

+ (UIImage*)createImageWithColor:(UIColor*)color;


- (Byte *)pixelRGBBytes;

+ (UIImage*)initWithRgbBytes:(unsigned char[])bytes with:(CGSize)size;
@end
