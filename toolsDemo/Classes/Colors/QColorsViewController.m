//
//  QColorsViewController.m
//  toolsDemo
//
//  Created by mrq on 17/2/24.
//  Copyright © 2017年 钱立顺. All rights reserved.
//

#import "QColorsViewController.h"

@interface QColorsViewController ()
@property (nonatomic,copy) NSTimer *timer;

@property (nonatomic,assign) int i;

@end

#define TITLE_CONTROL_HEIGHT 300

@implementation QColorsViewController

- (void)dealloc{
    [_timer invalidate];
    _timer = nil;
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
    
}

- (void)onTimer{
    NSLog(@"%d",_i);
    _i++;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _i = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];

    UIImageView *colorsView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, TITLE_CONTROL_HEIGHT)];
    colorsView.center = CGPointMake(50, self.view.center.y);
    
    [self.view addSubview:colorsView];
    
    colorsView.image = [self getColorsImage];
    
    UIImageView *greysView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, TITLE_CONTROL_HEIGHT)];
    greysView.center = CGPointMake(150, self.view.center.y);
    
    [self.view addSubview:greysView];
    
    greysView.image = [self getGreyImage];
    
    
    NSArray *colorArr = @[
    [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0],
    [UIColor colorWithRed:104/255.0 green:104/255.0 blue:104/255.0 alpha:1.0],
    [UIColor colorWithRed:158/255.0 green:158/255.0 blue:158/255.0 alpha:1.0],
    [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1.0]
    ];
    CGRect rect = CGRectMake(0, 0, 50, 50);
    UIImage *img1 = [self getBgImgeFromstartColor:colorArr[0] endColor:colorArr[1] withFrame:rect];
    UIImage *img2 = [self getBgImgeFromstartColor:colorArr[1] endColor:colorArr[2] withFrame:rect];
    UIImage *img3 = [self getBgImgeFromstartColor:colorArr[2] endColor:colorArr[3] withFrame:rect];
    for (int i=-3; i<4; i++) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((i+3)*50, 100, 50, 50)];
        [self.view addSubview:imgView];
        if (abs(i)==3) {
            imgView.image = img1;
        }else if(abs(i)==2){
            imgView.image = img2;
        }else if(abs(i)==1){
            imgView.image = img3;
        }
    }
}


- (UIImage *)getColorsImage{
    unsigned char powerPesudo[][3] = {
        {145,13,0},	{146,13,0},	{147,14,0},	{149,14,0},	{151,15,0},	{152,16,0},	{154,16,0},	{155,17,0},
        {157,17,0},	{159,18,0},	{160,19,0},	{162,19,0},	{164,21,0},	{166,22,0},	{168,22,0},	{169,24,0},
        {171,25,0},	{172,26,0},	{174,26,0},	{176,28,0},	{178,29,0},	{180,30,0},	{181,32,0},	{183,32,0},
        {185,34,0},	{187,34,0},	{189,36,0},	{191,38,0},	{193,39,0},	{195,40,0},	{197,41,0},	{198,43,0},
        {199,44,0},	{200,46,0},	{201,47,0},	{202,48,0},	{203,50,0},	{204,52,0},	{205,54,0},	{206,56,0},
        {207,58,0},	{207,60,0},	{208,62,0},	{209,64,0},	{209,66,0},	{210,68,0},	{211,70,0},	{211,72,0},
        {212,74,0},	{212,76,0},	{213,78,0},	{214,80,0},	{214,82,0},	{215,84,0},	{216,86,0},	{216,88,0},
        {217,90,0},	{217,92,0},	{217,94,0},	{218,96,0},	{219,98,0},	{220,100,0},	{220,102,0},	{221,104,0},
        {221,106,0},	{222,108,0},	{222,110,0},	{223,112,0},	{224,114,0},	{225,116,0},	{225,118,0},	{225,120,0},
        {226,122,0},	{227,124,0},	{227,126,0},	{228,128,0},	{228,130,0},	{229,132,0},	{229,134,0},	{229,136,0},
        {230,138,0},	{230,140,0},	{231,142,0},	{231,144,0},	{231,146,0},	{232,148,0},	{232,150,0},	{233,152,0},
        {233,154,0},	{233,156,0},	{233,159,0},	{234,163,0},	{235,167,0},	{235,170,0},	{236,174,0},	{237,178,0},
        {237,182,0},	{238,186,0},	{239,191,0},	{239,195,0},	{240,199,0},	{241,203,0},	{241,207,0},	{241,211,0},
        {241,216,0},	{241,220,0},	{241,224,0},	{241,228,0},	{241,233,0},	{241,233,0},	{242,235,0},	{242,237,0},
        {243,241,0},	{243,243,0},	{243,243,0},	{244,244,0},	{244,244,0},	{245,245,0},	{245,245,0},	{246,246,0},
        {246,246,5},	{247,247,10},	{247,247,16},	{247,247,22},	{248,248,30},	{249,249,36},	{250,250,42},	{251,251,48}
    };
    
    CGFloat colors[128*4];
    
    for (int i=0; i<128; i++) {
        for (int j=0; j<4; j++) {
            if (j<3) {
                colors[i*4+j] = powerPesudo[i][j] / 255.0;
            }else{
                colors[i*4+j] = 1.0;
            }
        }
    }

//    CGFloat colo[] =
//    
//    {
//        
//        51.0 / 255.0, 160.0 / 255.0, 0.0 / 255.0, 1.00,
//        
//        68.0 / 255.0, 198.0 / 255.0, 0.0 / 255.0, 1.00,
//        
//
//    };
    //绘制背景渐变
    
    /*
      CGGradientCreateWithColorComponents(<#CGColorSpaceRef  _Nullable space#>, <#const CGFloat * _Nullable components#>, <#const CGFloat * _Nullable locations#>, <#size_t count#>)
     CGCradientCreateWithColorComponents函数需要四个参数：
     
     色彩空间：（Color Space）这是一个色彩范围的容器，类型必须是CGColorSpaceRef.对于这个参数，我们可以传入CGColorSpaceCreateDeviceRGB函数的返回值，它将给我们一个RGB色彩空间。
     
     颜色分量的数组：这个数组必须包含CGFloat类型的红、绿、蓝和alpha值。数组中元素的数量和接下来两个参数密切。从本质来讲，你必须让这个数组包含足够的值，用来指定第四个参数中位置的数量。所以如果你需要两个位置位置（起点和终点），那么你必须为数组提供两种颜色
     
     位置数组，颜色数组中各个颜色的位置：此参数控制该渐变从一种颜色过渡到另一种颜色的速度有多快。
     
     位置的数量：这个参数指明了我们需要多少颜色和位置。
     */
    
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();

    CGGradientRef myGradient = CGGradientCreateWithColorComponents
    
    (rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    
    // Allocate bitmap context
    
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL, 320, TITLE_CONTROL_HEIGHT, 8, 4 * 320, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaNoneSkipFirst);
    
    // Draw Gradient Here
  
    /*
       CGContextDrawLinearGradient(<#CGContextRef  _Nullable c#>, <#CGGradientRef  _Nullable gradient#>, <#CGPoint startPoint#>, <#CGPoint endPoint#>, <#CGGradientDrawingOptions options#>)
     创建好线性渐变后，我们将使用CGContextDrawLinearGradient过程在图形上下文中绘制，此过程需要五个参数：
     
     Graphics context 指定用于绘制线性渐变的图形上下文。
     
     Axial gradient 我们使用CGGradientCreateWithColorComponents函数创建的线性渐变对象的句柄
     
     start point 图形上下文中的一个CGPoint类型的点，表示渐变的起点。
     
     End Point表示渐变的终点。
     
     Gradient drawing options 当你的起点或者终点不在图形上下文的边缘内时，指定该如何处理。你可以使用你的开始或结束颜色来填充渐变以外的空间。此参数为以下值之一：KCGGradientDrawsAfterEndLocation扩展整个渐变到渐变的终点之后的所有点 KCGGradientDrawsBeforeStartLocation扩展整个渐变到渐变的起点之前的所有点。0不扩展该渐变。
     
     */
    
    CGContextDrawLinearGradient(bitmapContext, myGradient, CGPointMake(160.0f, 0.0f),CGPointMake(160.0f, TITLE_CONTROL_HEIGHT),  kCGGradientDrawsBeforeStartLocation);
    
    // Create a CGImage from context
    
    CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
    
    // Create a UIImage from CGImage
    
    UIImage *uiImage = [UIImage imageWithCGImage:cgImage];
    
    // Release the CGImage
    
    CGImageRelease(cgImage);
    
    // Release the bitmap context
    
    CGContextRelease(bitmapContext);
    
    // Create the patterned UIColor and set as background color
    
    return uiImage;
}


- (UIImage *)getGreyImage{
    
    unsigned char colorSpeed[][3] = {
        {0,2,159},      {0,8,160},      {0,14,160},     {0,20,161},     {0,27,162},     {0,33,163},     {0,40,164},     {0,47,165},
        {0,54,166},     {0,61,167},     {0,67,168},     {0,72,168},     {0,77,169},     {0,82,170},     {0,87,171},     {0,92,172},
        {0,97,173},     {0,102,173},	{0,107,173},	{0,112,173},	{0,117,173},	{0,121,173},	{0,126,173},	{0,131,173},
        {0,136,173},	{0,141,173},	{0,145,173},	{0,150,173},	{0,155,173},	{0,160,173},	{0,165,173},	{0,169,173},
        {0,172,171},	{0,173,167},	{0,173,162},	{0,173,157},	{0,173,152},	{0,173,148},	{0,173,143},	{0,173,138},
        {0,173,133},	{0,173,128},	{0,173,124},	{0,173,119},	{0,173,114},	{0,173,109},	{0,173,104},	{0,173,100},
        {0,173,95},     {0,173,90},     {0,173,85},     {0,173,80},     {0,173,76},     {0,173,71},     {0,173,66},     {0,173,61},
        {0,173,56},     {0,173,52},     {0,173,47},     {0,173,43},     {1,173,39},     {3,173,35},     {5,173,32},     {6,173,31},
        
        
        {132,2,0},      {134,4,0},      {139,8,0},      {144,12,0},     {148,17,0},     {150,22,0},     {151,27,0},     {152,32,0},
        {153,37,0},     {154,42,0},     {155,46,0},     {156,49,0},     {157,51,0},     {158,53,0},     {159,55,0},     {160,57,0},
        {161,59,0},     {162,62,0},     {163,64,0},     {164,66,0},     {165,68,0},     {166,70,0},     {167,72,0},     {168,74,0},
        {169,76,0},     {170,79,0},     {171,81,0},     {172,84,1},     {172,87,3},     {173,90,4},     {174,92,5},     {175,95,6},
        {176,98,8},     {177,101,9},	{178,103,10},	{179,106,12},	{180,109,13},	{181,112,14},	{182,114,16},	{183,117,17},
        {184,120,18},	{185,123,20},	{186,125,21},	{187,128,22},	{188,131,24},	{189,133,25},	{190,136,27},	{191,139,28},
        {192,141,30},	{193,144,31},	{194,146,33},	{195,149,34},	{196,151,36},	{197,154,37},	{198,157,39},	{199,159,40},
        {200,162,42},	{201,164,43},	{202,167,45},	{203,169,46},	{204,171,48},	{205,174,50},	{206,176,51},	{207,179,53},
    };
    
    unsigned char temp[128][3];
    
    for (int i = 0; i<128; i++) {
        if (i<64) {
            for (int j=0; j<3; j++) {
                temp[i][j] = colorSpeed[63-i][j];
            }
        }else{
            for (int j=0; j<3; j++) {
                temp[i][j] = colorSpeed[i][j];
            }
        }
    }
    
    CGFloat colors[128*4];
    
    for (int i=0; i<128; i++) {
        for (int j=0; j<4; j++) {
            if (j<3) {
                colors[i*4+j] = temp[i][j] / 255.0;
            }else{
                colors[i*4+j] = 1.0;
            }
        }
    }

    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    
    CGGradientRef myGradient = CGGradientCreateWithColorComponents
    
    (rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    
    // Allocate bitmap context
    
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL, 320, TITLE_CONTROL_HEIGHT, 8, 4 * 320, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaNoneSkipFirst);
    
    CGContextDrawLinearGradient(bitmapContext, myGradient, CGPointMake(160.0f, 0.0f),CGPointMake(160.0f, TITLE_CONTROL_HEIGHT),  kCGGradientDrawsBeforeStartLocation);
    
    // Create a CGImage from context
    
    CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
    
    // Create a UIImage from CGImage
    
    UIImage *uiImage = [UIImage imageWithCGImage:cgImage];
    
    // Release the CGImage
    
    CGImageRelease(cgImage);
    
    // Release the bitmap context
    
    CGContextRelease(bitmapContext);
    
    // Create the patterned UIColor and set as background color
    
    return uiImage;
}

- (UIImage *)getBgImgeFromstartColor:(UIColor *)startColor endColor:(UIColor *)endColor withFrame:(CGRect)frame
{
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    NSArray *colors = @[(__bridge id) startColor.CGColor, (__bridge id) endColor.CGColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    //具体方向可根据需求修改
    UIGraphicsBeginImageContextWithOptions(frame.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGPoint startPoint = CGPointMake(CGRectGetMinX(frame), CGRectGetMidY(frame));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(frame), CGRectGetMidY(frame));
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    
    return img;
}


@end
