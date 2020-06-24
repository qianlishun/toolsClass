//
//  QMeasureController.m
//  toolsDemo
//
//  Created by mrq on 2020/6/23.
//  Copyright © 2020 钱立顺. All rights reserved.
//

#import "QMeasureController.h"
#import "MeasureHeader.h"
#import "MeasureMenuView.h"
@interface QMeasureController ()<MeasureMenuViewDelegate>

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) USMarkView *markView;

@property (nonatomic,strong) MeasureMenuView *measureMenuView;

@end

@implementation QMeasureController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    UIButton *drawBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [drawBtn setFrame:CGRectMake(10, self.view.height - 60, 80, 40)];
    [drawBtn setTitle:@"Draw" forState:UIControlStateNormal];
    [drawBtn addTarget:self action:@selector(onDraw:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:drawBtn];
    
    UIButton *annotateBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [annotateBtn setFrame:CGRectMake(100, self.view.height - 60, 80, 40)];
    [annotateBtn setTitle:@"Annotate" forState:UIControlStateNormal];
    [annotateBtn addTarget:self action:@selector(onAnnotate:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:annotateBtn];
    
    UIButton *measureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [measureBtn setFrame:CGRectMake(190, self.view.height - 60, 80, 40)];
    [measureBtn setTitle:@"Measure" forState:UIControlStateNormal];
    [measureBtn addTarget:self action:@selector(onMeasureMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:measureBtn];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [saveBtn setFrame:CGRectMake(280, self.view.height - 60, 80, 40)];
    [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(onSaveImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, M_VIEW_TOP, self.view.bounds.size.width, self.view.bounds.size.height-80)];
    [self.view addSubview:_imageView];
    
    // 测量视图 要保证测量视图上层没有遮挡
    _markView = [[USMarkView alloc]initWithFrame:_imageView.frame];
     [self.view addSubview:_markView];
    
    // 设置测量结果标签位置
    USRect *rect = [[USRect alloc]initWithLeft:15 top:self.markView.bounds.size.height-100 width:150 height:60];
    [USMeasureGroup setTopResultRect:rect];
    
    UIColor *bgColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
    UIColor *tColor = [UIColor colorWithRed:24/255.0 green:24/255.0 blue:24/255.0 alpha:1.0];

    // 测量菜单
    _measureMenuView = [[MeasureMenuView alloc]init];
     [_measureMenuView setDelegate:self];

    [_measureMenuView setTitleColor:tColor bgColor:bgColor];

    NSArray *arr = @[Measure_LEN,Measure_ANGLE,Measure_AREA,Measure_CLEAR];
    [_measureMenuView setMeasureList:arr andRowSize:CGSizeMake(210, 40)];
    
    _measureMenuView.x = (measureBtn.x + measureBtn.bounds.size.width/2) - 210/2.0;
    _measureMenuView.y = measureBtn.y - _measureMenuView.height;
    _measureMenuView.hidden = YES;
    
    [self.view addSubview:_measureMenuView];
    
}

- (void)onMeasureMenu:(id)sender{
    _measureMenuView.hidden = !_measureMenuView.hidden;
}
 
- (void)onDraw:(id)sender{
    if([self checkMarkCreating])
        return;
    USScrawl *scrawl = [USScrawl new];
    // 随机生成颜色
    UIColor *color = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    [scrawl setColor:color];// 设置字体颜色
    [self.markView addMark:scrawl];
}

- (void)onAnnotate:(id)sender{
    if([self checkMarkCreating])
        return;
    USAnnotate *ann = [USAnnotate new];
    // 随机生成颜色
    UIColor *color = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    [ann setColor:color];// 设置字体颜色
    [ann setFontSize:13];
    [self.markView addMark:ann];
}

- (void)onSaveImage:(id)sender{
    /*
     markView.screenImage: 获得测量图层的截图
     看了下你们的代码实现，是先生成测量覆盖层，然后叠加超声图像生成的诊断图像，
     所以我这里提供这样一个接口调用获得测量截图。
     */
    UIImage *image = self.markView.screenImage;
    _imageView.image = image;// 预览看看对不对
    
    // 清空测量
    [self.markView clearMarks];
}

- (BOOL)checkMarkCreating{
    if(self.markView.creatingScrawl){
        /*
         结束自由涂鸦绘制,
         如果要设置为抬起手就结束，前往USMarkView.m  touchesEnded处修改
         */
        [self.markView.creatingScrawl scrawlEnd];
    }
    if (self.markView.creatingAnnotate) {
        NSLog(@"请先完成标签的添加.");
        return YES;
    }
    
    if(self.markView.creatingMeasure){
        NSLog(@"请完成上一组测量.");
        return YES;
    }
    
    return NO;
}

#pragma mark - MeasureMenu Delegate
- (void)measureSelect:(NSUInteger)tag menuView:(MeasureMenuView *)view{
    _measureMenuView.hidden = YES;
    
    if([self checkMarkCreating])
        return;
    
    tag = [MeasureHeader str2Tag:_measureMenuView.list[tag]];
    
    USMeasure *marker;

    switch (tag) {
        case LEN:
            marker = [USMeasureLength new];
            break;
        case ANGLE:
            marker = [USMeasureAngle new];
            break;
        case AREA:
            marker = [USMeasureArea new];
            break;
        case CLEAR:
            [self.markView clearMarks];
            return;
        default:
           break;
    }
    
    if ([self.markView.theMarks markCount:MARK_MEASURE]>=3) {
        NSLog(@"测量数目不能超过3个.");
        return;
    }
    
    /* 此处设置图像 scale ,
        看了下你们的代码，设置比例应该为 原始图像比例 * 缩放比例
        self.scale * self.imageView.image.size.width / self.imageView.width;
    */
    float scalePixel = 0.3; // 测试值
    [marker setScale:scalePixel];
    
    [marker setResultFontSize:13]; // 设置测量结果字体大小
    
    [self.markView addMark:marker];
    
}

@end
