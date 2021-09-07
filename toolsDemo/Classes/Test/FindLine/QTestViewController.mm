//
//  QTestViewController.m
//  toolsDemo
//
//  Created by mrq on 2020/1/6.
//  Copyright © 2020 钱立顺. All rights reserved.
//

#import "QTestViewController.h"
#import "QSlider.h"
#import "UIColor+Common.h"
#import "QScrollView.h"
#import "USSlider.h"
#import <NetworkExtension/NEHotspotConfigurationManager.h>
#import "QRulerView.h"
#import "FuzzyCMeans.h"
#import "HoughLineDetector.h"
#import "UIImage+AssetUrl.h"

@interface QTestViewController ()
@property (nonatomic,strong) QRulerView *rulerView;

@property (nonatomic,strong) QSlider *pageControl;
@property (nonatomic,strong) QScrollView *scrollView;
@end

@implementation QTestViewController

- (void)viewDidLoad{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor colorWithRGBA:@[@0,@0,@0,@1.0]].CGColor;
    [self.view.layer addSublayer:layer];
    layer.lineWidth = 3;

    int x = 50;
    int y = self.view.height - 50;;
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int r = 0; r < 50; r ++) {
        [path moveToPoint:CGPointMake(x, y - M_PI * r * r /2.0)];
        [path addArcWithCenter:CGPointMake(x, y - M_PI * r * r /2.0) radius:0.5 startAngle:0 endAngle:M_PI clockwise:YES];
        x+=10;
    }
    
    layer.path = path.CGPath;
    
    
//    return;
    @autoreleasepool {
        
    UIImage *image = [UIImage imageNamed:@"blineTest2.jpg"];
    int height = image.size.height;
    int width = image.size.width;
    
    Byte *pBytes = [image pixelRGBBytes];

    unsigned char *source = (unsigned char*)malloc(width*height*sizeof(unsigned char));

    for (int l=0;l<width;l++) {
        for (int s=0;s<height;s++) {
            int index = (width*s+l)*4;
            float r = pBytes[index];
            float g = pBytes[index+1];
            float b = pBytes[index+2];
            int dot = 0.30*r + 0.59*g + 0.11*b;
            source[width*s+l] = dot;
        }
    }
//        NSLog(@"<<start");
//        [FuzzyCMeans detect:pBytes size:image.size];
//        NSLog(@"<<end");

//        free(source);
//        source = NULL;
        
            
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    imageView.image = image;
    [self.view addSubview:imageView];
    imageView.center = CGPointMake(self.view.width/2, self.view.height/2);
    
    NSArray *array = [FuzzyCMeans testFCMeauns:image];

    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor colorWithRGBA:@[@30,@160,@30,@0.6]].CGColor;
    [imageView.layer addSublayer:layer];
    layer.lineWidth = 3;

    // 画线
    CGFloat h = image.size.height;
    UIBezierPath *path = [UIBezierPath bezierPath];
   
        /*
     boundingbox_t bbox = { 0,0,width,height };

     std::vector<line_float_t> lines;

        for (int t = 0 ; t < array.count; t++) {
            NSArray *tarr = array[t];
            
            int start = [tarr.firstObject intValue];
            int end = [tarr.lastObject intValue];
        
            unsigned char bs[tarr.count * height];
            int tIndex = 0;
            for (int x = start; x <= end; x++) {
                for (int y = 0; y < height; y++) {
                    bs[tIndex] = source[x*height + y];
                    tIndex++;
                }
                
            }
            bbox.width = (int)tarr.count;
            bbox.height = height;
        
        int result =
         HoughLineDetector(bs,bbox.width,bbox.height,1,1,70,150,1, M_PI/180.0,
                                       0, M_PI, 100, HOUGH_LINE_STANDARD,bbox,lines);

            if(lines.size()>0){
                NSNumber *num = tarr[tarr.count/2];
                [path moveToPoint:CGPointMake(num.intValue, 0)];
                [path addLineToPoint:CGPointMake(num.intValue, h)];
            }
                
        for(int i = 0; i < lines.size(); i ++){
            line_float_t line = lines[i];
            
            [path moveToPoint:CGPointMake(line.startx + start, line.starty)];
            [path addLineToPoint:CGPointMake(line.endx + start, line.endy)];
        }
    }
        */
    for (NSArray *arr in array) {
        for (NSNumber *num in arr) {
            [path moveToPoint:CGPointMake(num.intValue, 0)];
            [path addLineToPoint:CGPointMake(num.intValue, h)];
        }
    }

    layer.path = path.CGPath;
}
    return;
    CGSize thumbSize = CGSizeMake(15, 15);
    
    QSlider *pageControl = [[QSlider alloc] initWithFrame:CGRectMake(0, 0,201, 50) list:@[@30,@45,@60,@75,@90,@105]];
    
    pageControl.center = self.view.center;
    
    UIColor *color = [UIColor colorWithRGBA:@[@75,@172,@198]];
    UIColor *colorLight = [UIColor colorWithRGBA:@[@60,@246,@194]];

//    UIImage *image = [color getArcImageWithSize:thumbSize];
//    UIImage *imageLight = [colorLight getArcImageWithSize:thumbSize];

    [pageControl setThumbSize:thumbSize color:color highlight:colorLight];

//    [pageControl setThumbImage:image forState:UIControlStateNormal];
    
    [self.view addSubview:pageControl];
    
    [self setupRuler];
    
    __block QRulerView *wR = self.rulerView;
    pageControl.isSliderBallMoved = ^(BOOL isUpadte, NSNumber *value) {
        if (isUpadte == YES) {
            NSLog(@"%@", value);
                int maxVlue = wR.maxValue;
                maxVlue+=20;
                wR.maxValue = maxVlue;
                wR.defaultValue = maxVlue;
                isScrollCallBack = NO;
                [wR updateRulerEnableCallback:isScrollCallBack];
                isScrollCallBack = YES;
        }
    };
    
    [pageControl drawDotWithColor:color];
    
    
    self.scrollView = [[QScrollView alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];
    self.scrollView.contentSize = CGSizeMake(200, 440);
    self.scrollView.backgroundColor = [UIColor orangeColor];
    
    [self.view addSubview:self.scrollView];
    
    
    USSlider *slider = [[USSlider alloc]initWithFrame:CGRectMake(0, 100, 200, 40)];
    slider.minimumValue = 0;
    slider.maximumValue = 5;
    [self.scrollView addSubview:slider];
    
    [slider drawDotWithColor:[UIColor blackColor]];
    
}

static bool isScrollCallBack = YES;
-(void)setupRuler{
    // 变速区域
    QRulerView * rulerView = [[QRulerView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 51)];
    rulerView.backgroundColor = [UIColor clearColor];
    //使用刻度尺常规模式
    rulerView.isCustomScalesValue = NO;
    //不显示刻度尺上的文案
    rulerView.isShowScaleText = NO;
    rulerView.scaleTextFont = [UIFont systemFontOfSize:0];
    //显示刻度尺中当前值文案
    rulerView.isShowCurrentValue = NO;
    //最大值
    rulerView.maxValue = 99;
    //最小值
    rulerView.minValue = 0;
    //单元值
    rulerView.unitValue = 1;
    //默认值
    rulerView.defaultValue = 0;
    //两个刻度文案之间的刻度格数
    rulerView.scalesCountBetweenScaleText = 0;
    rulerView.scalesCountBetweenLargeLine = 1;
    
    rulerView.indicatorWidth = 2;
    rulerView.lineWidth = 2;
    rulerView.lineSpace = 15;

    //结束滚动
    [rulerView setDividingRulerDidEndScrollingBlock:^NSString *(CGFloat value) {
        if(isScrollCallBack){
            NSLog(@"sel end %.f",value);
        }
        return [NSString stringWithFormat:@"%.f",value];
    }];
    //滚动中
    [rulerView setDividingRulerDidScrollBlock:^NSString *(CGFloat value,CGPoint rulerContentOffset) {
        if(isScrollCallBack){
            NSLog(@"sel  %.f",value);
        }
        return [NSString stringWithFormat:@"%.f",value];
    }];
    [rulerView setFrame:CGRectMake(0, 300, CGRectGetWidth(self.view.frame), 52)];
    [rulerView updateRulerEnableCallback:NO];
    [self.view addSubview:rulerView];
    
    self.rulerView = rulerView;
}

@end
