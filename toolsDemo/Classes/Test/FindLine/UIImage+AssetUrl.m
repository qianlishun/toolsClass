#import "UIImage+AssetUrl.h"
@implementation UIImage (AssetUrl)

-(UIImage *)scaleToFitForHeight{
    CGFloat fixelW = CGImageGetWidth(self.CGImage);
    CGFloat fixelH = CGImageGetHeight(self.CGImage);
    
    CGFloat newH = ScreenFrame.size.width/ScreenFrame.size.height * fixelW;
    
    UIGraphicsBeginImageContext(CGSizeMake(fixelW, newH));  //size 为CGSize类型，即你所需要的图片尺寸
    
    { // 填充背景色
    CGRect rect = CGRectMake(0.0f, 0.0f, fixelW, newH);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextFillRect(context, rect);
    }
    
    [self drawInRect:CGRectMake(0, (newH-fixelH)/2, fixelW, fixelH)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

// draw color background
- (UIImage *)image:(UIImage *)image withColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [image drawInRect:rect];
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextFillRect(context, rect);
    
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (UIImage *)scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (UIImage*) createImageWithColor: (UIColor*) color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


- (Byte *)pixelRGBBytes{
    CGImageRef imageRef = self.CGImage;
    NSUInteger iWidth = CGImageGetWidth(imageRef);
    NSUInteger iHeight = CGImageGetHeight(imageRef);
    NSUInteger iBytesPerPixel = 4;
    NSUInteger iBytesPerRow = iBytesPerPixel * iWidth;
    NSUInteger iBitsPerComponent = 8;
    Byte *imageBytes = (Byte *) calloc(iWidth * iHeight * iBytesPerPixel, sizeof(Byte));
    
    CGColorSpaceRef colorspace = CGImageGetColorSpace(imageRef);
    
    CGContextRef context = CGBitmapContextCreate(imageBytes,
                                                 iWidth,
                                                 iHeight,
                                                 iBitsPerComponent,
                                                 iBytesPerRow,
                                                 colorspace,
                                                 kCGImageAlphaPremultipliedLast);
    
    CGRect rect = CGRectMake(0 , 0 , iWidth , iHeight);
    CGContextDrawImage(context , rect ,imageRef);
//    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorspace);
    return imageBytes;
}

+ (UIImage *)initWithRgbBytes:(unsigned char [])bytes with:(CGSize)size{
    NSUInteger w = size.width;
    NSUInteger h = size.height;
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * w;
    NSUInteger bitsPerComponent = 8;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(bytes, w, h, bitsPerComponent, bytesPerRow,
                                                       colorSpace,   kCGImageAlphaPremultipliedLast);
    
    CGImageRef cgRef;
    UIImage *img;
    
    if (!bitmapContext)
    {
        CGContextRelease(bitmapContext);
        CGColorSpaceRelease(colorSpace);
        NSLog(@"位图上下文为空！");
        return nil;
    }
    cgRef = CGBitmapContextCreateImage(bitmapContext);
    img = [[UIImage alloc]initWithCGImage:cgRef];
    CGImageRelease(cgRef);
    CGContextRelease(bitmapContext);
    CGColorSpaceRelease(colorSpace);
//    free(bytes); // 释放内存
//    bytes = NULL;
//    NSLog(@"end");
    return img;
}
@end
