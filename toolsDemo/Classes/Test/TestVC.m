//
//  TestVC.m
//  toolsDemo
//
//  Created by Qianlishun on 2021/6/21.
//  Copyright © 2021 钱立顺. All rights reserved.
//


#define MODE_B      0x00
#define MODE_COLOR  0x01
#define MODE_PDI    0x02
#define MODE_PW     0x03

typedef enum : NSUInteger {
    SCAN_MODE_B = 0,
    SCAN_MODE_COLOR,
    SCAN_MODE_PDI,
    SCAN_MODE_PW,
    SCAN_MODE_COLOR_EX,
    SCAN_MODE_PDI_EX,
    SCAN_MODE_PW_EX,
    SCAN_MODE_BM,
    SCAN_MODE_CD
} SCAN_MODE;

#import "TestVC.h"
#import "USRingView.h"
#import "USQButton2.h"
#import "UIColor+Common.h"
#import "QRulerView.h"
#import "QSlider.h"
#import "QRuleSlider.h"
#import "UIImage+AssetUrl.h"
#import "QPlayLoopSlider.h"
#import "USPickerView.h"
#import "iCarousel.h"

@interface TestVC ()<iCarouselDelegate,iCarouselDataSource>
@property (nonatomic,assign) SCAN_MODE scanMode;
@property (nonatomic,strong) USRingView *ringView;

@property (nonatomic,strong) USQButton2 *bmModeBtn;
@property (nonatomic,strong) USQButton2 *cpModeBtn;
@property (nonatomic,strong) USQButton2 *pwModeBtn;

@property (nonatomic,assign) BOOL isLive;

@end

@implementation TestVC


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    iCarousel *carousel = [[iCarousel alloc]initWithFrame:CGRectMake(100, 100, 300, 80)];
    carousel.scrollSpeed = carousel.scrollSpeed*0.1;
    carousel.singleScroll = NO;
    [self.view addSubview:carousel];
    carousel.backgroundColor = [UIColor colorWithRGBA:@[@35,@35,@35]];
    [carousel setMaskColor:self.view.backgroundColor];
    carousel.type = iCarouselTypeCylinder;
    carousel.bounces = NO;
    carousel.delegate = self;
    carousel.dataSource = self;
   
    QRuleSlider *slider = [[QRuleSlider alloc]initWithFrame:CGRectMake(0, 0, 80, 200)];
//    slider.backgroundColor = [UIColor grayColor];
    slider.center = self.view.center;
    [self.view addSubview:slider];
    
    slider.minimumValue = 30;
    slider.maximumValue = 105;
    slider.value = 30;
    
    QPlayLoopSlider *slider2 = [[QPlayLoopSlider alloc]initWithFrame:CGRectMake(0, 0, self.view.width*0.5, 30)];
    slider2.center = CGPointMake(self.view.width/2, 100);
    
    slider2.minimumValue = 0;
    slider2.maximumValue = 500;
    slider2.value = 0;
    
    [self.view addSubview:slider2];
    
    QRulerView * rulerView = [[QRulerView alloc]initWithFrame:CGRectMake(150, 200, 500, 50)];
//        rulerView.backgroundColor = [UIColor clearColor];
    //使用刻度尺常规模式
    rulerView.isCustomScalesValue = NO;
    //不显示刻度尺上的文案
    rulerView.isShowScaleText = NO;
    rulerView.scaleTextFont = [UIFont systemFontOfSize:0];
    //显示刻度尺中当前值文案
    rulerView.isShowCurrentValue = NO;
    //最大值
    rulerView.maxValue = 500;
    //最小值
    rulerView.minValue = 0;
    //单元值
    rulerView.unitValue = 1;
    //默认值
    rulerView.defaultValue = 0;
    //两个刻度文案之间的刻度格数
    rulerView.scalesCountBetweenScaleText = 1;
    rulerView.scalesCountBetweenLargeLine = 1;
    
    rulerView.indicatorWidth = 2.5;
    rulerView.lineWidth = 2;
    rulerView.lineSpace = 15;
    
    [rulerView updateRulerEnableCallback:NO];
    
    [self.view addSubview:rulerView];
    
    
    USPickerView *pickerView = [[USPickerView alloc]initWithFrame:CGRectMake(0, 0, 300, 80)];
    [pickerView setCount: 20];
    [self.view addSubview:pickerView];
    pickerView.center = self.view.center;
    
    /*
    self.ringView = [[USRingView alloc]initWithFrame:CGRectMake(0, 0, 150, 300) center:CGPointMake(0, 150) radius:150];
    self.ringView.center = CGPointMake(self.view.centerX+80, 250);
    
    USRingView *ringView2 = [[USRingView alloc]initWithFrame:CGRectMake(0, 0, 150, 300) center:CGPointMake(150, 150) radius:150];
    ringView2.center = CGPointMake(self.view.centerX-80, 250);
    
    USRingView *ringView3 = [[USRingView alloc]initWithFrame:CGRectMake(0, 0, 200, 100) center:CGPointMake(100, 100) radius:100];
    ringView3.center = CGPointMake(self.view.centerX, 480);
    [ringView3 setOuterColor:[UIColor colorWithRGBA:@[@66,@66,@66]]];
    [ringView3 setCenterColor:[UIColor colorWithRGBA:@[@33,@33,@33]]];

    
    USRingView *ringView4 = [[USRingView alloc]initWithFrame:CGRectMake(0, 0, 200, 100) center:CGPointMake(100, 0) radius:100];
    ringView4.center = CGPointMake(self.view.centerX, 600);
    
    
    USQButton2 *view = [USQButton2 new];
    view.usEnabled = NO;
    [view setImage:[UIImage imageNamed:@"freeze"] forState:UIControlStateNormal];
    [view addTarget:self action:@selector(onFreeze:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *names = @[@"Color\n(PDI)",@"B\n(B/M)",@"PW"];
    
    _bmModeBtn = [USQButton2 new];
    _cpModeBtn = [USQButton2 new];
    _pwModeBtn = [USQButton2 new];
    
    NSArray *btns = @[_cpModeBtn,_bmModeBtn,_pwModeBtn];

    for (int i = 0; i < btns.count; i++){
        USQButton2 *button = [btns objectAtIndex:i];
        button.titleLabel.numberOfLines = 2;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:names[i] forState:UIControlStateNormal];
        button.tag = i;
    
        [button addTarget:self action:@selector(modeSeleted:) forControlEvents:UIControlEventTouchUpInside];
    }

    [self.view addSubview:_ringView];
    [_ringView setCenterView:view];
    [_ringView setViewList:btns];
    
    
    NSArray *rings = @[ringView2,ringView3,ringView4];
    
    for (int i = 0; i < rings.count; i++) {
        USRingView *ring = rings[i];
        
        [self.view addSubview:ring];
        
        USQButton2 *view2 = [USQButton2 new];
        [view2 setImage:[UIImage imageNamed:@"freeze"] forState:UIControlStateNormal];
        
        USQButton2 *b1 = [USQButton2 new];
        USQButton2 *b2 = [USQButton2 new];
        USQButton2 *b3 = [USQButton2 new];
        
        names = @[@"保存图片",@"测量",@"SaveVideo"];
        NSArray *imageNames = @[@"saveImage",@"measure",@"saveVideo"];
        
        btns = @[b1,b2,b3];

        for (int i = 0; i < btns.count; i++){
            USQButton2 *button = [btns objectAtIndex:i];
            NSString *title = names[i];
            NSString *imagename =  [NSString stringWithFormat:@"%@.png",imageNames[i]];
            
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
            
            if(i == 1){
//                button.titleLabel.font = FONT_SIZE;
            }
            button.usEnabled = YES;
        }
        
        [ring setCenterView:view2];
        [ring setViewList:btns];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        view.usEnabled = YES;
    });
     */
}

- (void)onFreeze:(USQButton2*)sender{
    _isLive = !_isLive;
    
    NSString *imageName = @"freeze";
    if(_isLive){
        imageName = @"freeze_live";
    }
    [sender setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)modeSeleted:(UIButton*)sender{
    [self modeSeleted:sender.tag setMode:YES];
}

- (void)modeSeleted:(NSInteger)sender setMode:(BOOL)isSet{
    
    unsigned char mode = MODE_B;
    
    if(sender == 0){
        if(self.scanMode == SCAN_MODE_COLOR || self.scanMode == SCAN_MODE_COLOR_EX){
            mode = MODE_PDI;
        }else{
            mode = MODE_COLOR;
        }

    }else if(sender == 1){
        if(self.scanMode == SCAN_MODE_B){
            mode = SCAN_MODE_BM;
        }else{
            mode = MODE_B;
        }
    }else if(sender == 2){
        if(self.scanMode == SCAN_MODE_PW || self.scanMode == SCAN_MODE_PW_EX ){
            return;
        }
        mode = MODE_PW;
    }

    [self setMode:mode];
        
//    if (isSet && [_delegate respondsToSelector:@selector(onModeSwitch:)]) {
//        [_delegate onModeSwitch:mode];
//    }
}

- (void)setMode:(NSUInteger)mode{
    
    NSMutableArray *btns = [NSMutableArray arrayWithArray: _ringView.viewList];

    [_bmModeBtn setTitle:@"B\n(B/M)" forState:UIControlStateNormal];
    [_cpModeBtn setTitle:@"Color\n(PDI)" forState:UIControlStateNormal];

    if(mode == SCAN_MODE_BM){
        
        [_bmModeBtn setTitle:@"B/M\nB" forState:UIControlStateNormal];
        
    }else if(mode == MODE_B){
        
        NSUInteger toIndex = [btns indexOfObject:_bmModeBtn];
        [btns exchangeObjectAtIndex:1 withObjectAtIndex:toIndex];
        
        
    }else if(mode == MODE_COLOR){

        NSUInteger toIndex = [btns indexOfObject:_cpModeBtn];
        [btns exchangeObjectAtIndex:1 withObjectAtIndex:toIndex];

    }else if(mode == MODE_PDI){

        [_cpModeBtn setTitle:@"PDI\n(Color)" forState:UIControlStateNormal];

    }else if(mode == MODE_PW){
        
        NSUInteger toIndex = [btns indexOfObject:_pwModeBtn];
        [btns exchangeObjectAtIndex:1 withObjectAtIndex:toIndex];
    }
    
    if(btns.count>0){
        [_ringView setViewList:btns];
    }
    self.scanMode = mode;
    
    NSLog(@"mode: %lu",(unsigned long)mode);
}

#pragma mark - iCarousel delegate & datasource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return 100;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
    if(!view)
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, carousel.height)];
    
    view.backgroundColor = [UIColor lightGrayColor];
    
    return view;
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    switch (option) {
        case iCarouselOptionVisibleItems:
            return 7;
        case iCarouselOptionWrap:
            return NO;
        case iCarouselOptionSpacing:
            return 10;
        default:
            break;
    }
    return value;
}

#pragma mark iCarousel taps
//static bool isDragging = false;

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
//    if(isDragging)
//        return;

}

- (void)carouselWillBeginDragging:(iCarousel *)carousel{
//    isDragging = true;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
//    if(!isDragging)
//        return;
//
//    isDragging = false;
}

- (void)carouselDidScroll:(iCarousel *)carousel{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
}


@end
