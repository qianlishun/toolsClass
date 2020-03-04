//
// Created by 王浩达 on 16/4/17.
// Copyright (c) 2016 sonoptek. All rights reserved.
//


#import "UIColor+Common.h"

@implementation UIColor (Common)

+ (UIColor *)getHexColor:(NSString *)string
{
    if (!string || [string isEqualToString:@""] || string.length != 6)
    {
        return nil;
    }

    unsigned red, green, blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[string substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[string substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[string substringWithRange:range]] scanHexInt:&blue];

    UIColor *color = [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:1];
    return color;

}

+ (UIColor *)colorWithRGBA:(NSArray *)arr{
    int r = [arr[0] intValue];
    int g = [arr[1] intValue];
    int b = [arr[2] intValue];
    float a = arr.count>3 ? [arr[3] floatValue] : 1.0;
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

- (UIColor *)inverseColor {

    CGColorRef oldCGColor = self.CGColor;

    int numberOfComponents = (int)CGColorGetNumberOfComponents(oldCGColor);

    // can not invert - the only component is the alpha
    // e.g. self == [UIColor groupTableViewBackgroundColor]
    if (numberOfComponents == 1) {
        return [UIColor colorWithCGColor:oldCGColor];
    }

    const CGFloat *oldComponentColors = CGColorGetComponents(oldCGColor);
    CGFloat newComponentColors[numberOfComponents];

    int i = numberOfComponents - 1;
    newComponentColors[i] = oldComponentColors[i]*0.3; // alpha
    while (--i >= 0) {
        newComponentColors[i] = 1 - oldComponentColors[i];
    }

    CGColorRef newCGColor = CGColorCreate(CGColorGetColorSpace(oldCGColor), newComponentColors);
    UIColor *newColor = [UIColor colorWithCGColor:newCGColor];
    CGColorRelease(newCGColor);

    return newColor;
}


- (nullable UIImage *)getArcImageWithSize:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
      
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
      
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,self.CGColor);
    CGContextFillEllipseInRect(context, rect);
    CGContextStrokePath(context);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (nullable UIImage *)getImageWithSize:(CGSize)size {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,self.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
