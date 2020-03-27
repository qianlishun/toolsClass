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

@interface QTestViewController ()
@property (nonatomic,strong) QRulerView *rulerView;

@property (nonatomic,strong) QSlider *pageControl;
@property (nonatomic,strong) QScrollView *scrollView;
@end

@implementation QTestViewController

- (void)viewDidLoad{
    
    
    UIImage *image = [UIImage imageNamed:@"blineTest2.jpg"];
    NSArray *array = [FuzzyCMeans testFCMeauns:image];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    imageView.image = image;
    [self.view addSubview:imageView];
    
    imageView.center = CGPointMake(self.view.width/2, self.view.height/2);
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor colorWithRGBA:@[@30,@160,@30,@0.6]].CGColor;
    [imageView.layer addSublayer:layer];

    CGFloat h = image.size.height;
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (NSNumber *num in array) {
        [path moveToPoint:CGPointMake(num.intValue, 0)];
        [path addLineToPoint:CGPointMake(num.intValue, h)];
    }

    layer.path = path.CGPath;
    
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
                [wR updateRuler];
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
    [rulerView updateRuler];
    [self.view addSubview:rulerView];
    
    self.rulerView = rulerView;
}
@end
