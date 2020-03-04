

#import <UIKit/UIKit.h>

#define kGreenColorArr @[@50,@170,@80]

#define kBlueColorArr @[@30,@144,@255]

#define kGreenRGBA 30/255.0,180/255.0,70/255.0,1.0

#define kYellowColorArr @[@200,@200,@0]

#define kButtonBgColor  [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]

#define kButtonFontColor [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1.0]

#define kSeparatorColor [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0]

@interface UIColor (Common)

+ (UIColor *)getHexColor:(NSString *)string;

+ (UIColor *)colorWithRGBA:(NSArray *)arr;

- (UIColor *)inverseColor;


- (nullable UIImage *)getArcImageWithSize:(CGSize)size;
- (nullable UIImage *)getImageWithSize:(CGSize)size;
@end
