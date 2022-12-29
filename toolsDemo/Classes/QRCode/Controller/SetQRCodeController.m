//
//  SetQRCodeController.m
//  toolsDemo
//
//  Created by Mr.Q on 16/6/22.
//  Copyright © 2016年 钱立顺. All rights reserved.
//

#import "SetQRCodeController.h"
#import "QCIFilterCell.h"

@interface SetQRCodeController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSArray *filter;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout *collectionLayout;

@property(nonatomic, strong) NSIndexPath *selIndexPath;

@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) UIButton *generatorBtn;

@property(nonatomic, strong) UIView *resultView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *resetBtn;

@end

#define kScreenSize [UIScreen mainScreen].bounds.size
@implementation SetQRCodeController

static NSString *kFilterCellID = @"FilterCellID";
// 使用滤镜生成二维码
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"生成二维码";
    CGSize size = CGSizeMake(kScreenSize.width*0.3, kScreenSize.height*0.3);
    if(kISiPhone){
        size.width = kScreenSize.width*0.6;
    }
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    _textView.center = self.view.center;
    [_textView setBackgroundColor:[UIColor lightGrayColor]];
    _textView.font = [UIFont systemFontOfSize:15];

    _generatorBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.textView.frame.size.width + self.textView.frame.origin.x + 5, self.textView.center.y, 66, 36)];
    [_generatorBtn setTitle:@"生成" forState: UIControlStateNormal];
    [_generatorBtn setBackgroundColor: [UIColor colorWithRed:arc4random_uniform (256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]];

    [_generatorBtn addTarget:self action:@selector(onGenerator) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.textView];
    [self.view addSubview:self.generatorBtn];
    
    self.selIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    self.filter = @[@"CIQRCodeGenerator",@"CICode128BarcodeGenerator",@"CIAztecCodeGenerator"];
    /*
     self.filter = [CIFilter filterNamesInCategory:kCICategoryGenerator];
    CIAztecCodeGenerator,
    CIBarcodeGenerator,
    CICheckerboardGenerator,
    CICode128BarcodeGenerator,
    CIConstantColorGenerator,
    CILenticularHaloGenerator,
    CIMeshGenerator,
    CIPDF417BarcodeGenerator,
    CIQRCodeGenerator,
    CIRandomGenerator,
    CIRoundedRectangleGenerator,
    CIStarShineGenerator,
    CIStripesGenerator,
    CISunbeamsGenerator,
    CITextImageGenerator
*/

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionLayout = layout;

    // 2.初始化collctionView
    UICollectionView *collectionView =  [[UICollectionView alloc]initWithFrame:CGRectMake(0, kScreenSize.height-80, kWIDTH, 80) collectionViewLayout:layout];
    
    [collectionView borderForColor:[UIColor blackColor] borderWidth:1 borderType:UIBorderSideTypeAll];
    collectionView.backgroundColor = [UIColor colorWithRed:253/255.0 green:245/255.0 blue:230/255.0 alpha:1.0];
    // 注册
    [collectionView registerClass:[QCIFilterCell class] forCellWithReuseIdentifier:kFilterCellID];

    self.collectionView = collectionView;

    [self.view addSubview:self.collectionView];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;

    [self viewWillTransitionToSize:[UIScreen mainScreen].bounds.size withTransitionCoordinator:self.transitionCoordinator];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.collectionView.sd_layout.bottomSpaceToView(self.view, self.view.safeAreaInsets.bottom+20).leftEqualToView(self.view).rightEqualToView(self.view).heightIs(80);
}

- (UIView *)resultView{
    if(!_resultView){
        _resultView = [[UIView alloc]initWithFrame:self.view.bounds];
        _resultView.hidden = YES;
        _resultView.backgroundColor = self.view.backgroundColor;
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
        _imageView.center = _resultView.center;
        
        _resetBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 36)];
        _resetBtn.center = CGPointMake(self.view.center.x, kScreenSize.height * 0.8);
        [_resetBtn setTitle:@"返回" forState: UIControlStateNormal];
        [_resetBtn setBackgroundColor: [UIColor colorWithRed:arc4random_uniform (256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]];
        [_resetBtn addTarget:self action:@selector(onReset:) forControlEvents:UIControlEventTouchUpInside];

        [_resultView addSubview:_imageView];
        [_resultView addSubview:_resetBtn];
        [self.view addSubview:_resultView];
    }
    return _resultView;
}

- (void)onGenerator{
    self.resultView.hidden = NO;
    
    UIImage *headImage = nil;

    UIImage *QCardImg = [self createXCodeWithString:self.textView.text andHeadImage:headImage];

    self.imageView.image = QCardImg;
}

- (void)onReset:(UIButton *)sender{
    self.resultView.hidden = YES;
}

- (UIImage *)createXCodeWithString:(NSString *)string andHeadImage:(UIImage *)headImage{
    NSString *filterName = self.filter[self.selIndexPath.item];
    // 准备滤镜
    CIFilter *filter = [CIFilter filterWithName:filterName];

    // 设置默认值
    [filter setDefaults];

    NSArray *keys = [filter inputKeys];
    NSLog(@"%@",keys.description);
    
    if([keys containsObject:@"inputMessage"]){
        // 生成要显示的字符串数据
        NSData *data = [self.textView.text dataUsingEncoding:NSUTF8StringEncoding];
        [filter setValue:data forKeyPath:@"inputMessage"];
    }
    if([keys containsObject:@"inputCorrectionLevel"]){
        if([filterName isEqualToString:@"CIAztecCodeGenerator"]){
            [filter setValue:@60 forKeyPath:@"inputCorrectionLevel"];
        }else{
            [filter setValue:@"H" forKeyPath:@"inputCorrectionLevel"];
        }
    }

    // 输出
    CIImage *coreImage = [filter outputImage];

    // 1.要把图像无损放大
    UIImage *QRImage = [self imageWithCIImage:coreImage andSize:self.imageView.bounds.size];

    return QRImage;
//    // 2.要合成头像
//    CGSize headSize = CGSizeMake(self.imgView.bounds.size.width * 0.25, self.imgView.bounds.size.height * 0.25);
//
//    UIImage *QRCardImage = [self imageWithBackgroundImage:QRImage centerImage:headImage centerImageSize:headSize];
//
//    return QRCardImage;
}

- (UIImage *)imageWithCIImage:(CIImage *)coreImage andSize:(CGSize)size{
    //1. CIImage 转换成 CGImage(CGImageRef)
    CIContext *context = [CIContext contextWithOptions:nil];

    CGImageRef originCGImage = [context createCGImage:coreImage fromRect:coreImage.extent];

    //2. 创建一个图形上下文 Bitmap
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();

    CGContextRef bitmapCtx = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, cs, kCGImageAlphaNone);

    //3. 将CGImage图片渲染到新的图形上下文中
    CGContextSetInterpolationQuality(bitmapCtx, kCGInterpolationNone);

    // 在图形上下文中把图片画出来
    CGRect newRect = CGRectMake(0, 0, size.width, size.height);

    CGContextDrawImage(bitmapCtx, newRect, originCGImage);

    //4. 取图像
    CGImageRef QRImage = CGBitmapContextCreateImage(bitmapCtx);

    // 释放
    CGColorSpaceRelease(cs);

    CGImageRelease(originCGImage);

    CGContextRelease(bitmapCtx);


    return [UIImage imageWithCGImage:QRImage];

}

- (UIImage *)imageWithBackgroundImage:(UIImage *)backgroundImage centerImage:(UIImage *)centerImage centerImageSize:(CGSize)centerSize{
    // 开始图形上下文
    UIGraphicsBeginImageContext(backgroundImage.size);

    // 先画背景
    [backgroundImage drawAtPoint:CGPointZero];

    // 再画头像
    CGFloat headW = centerSize.width;
    CGFloat headH = centerSize.height;
    CGFloat headX = (backgroundImage.size.width - headW) * 0.5;
    CGFloat headY = (backgroundImage.size.height - headH) * 0.5;

    [centerImage drawInRect:CGRectMake(headX, headY, headW, headH)];
    
    // 取图像
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

#pragma mark - UICollectionView datasource & delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.filter.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(120, 80);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    QCIFilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFilterCellID forIndexPath:indexPath];

    NSString *title = self.filter[indexPath.item];
    [cell setTitle:title];

    if(indexPath.item == self.selIndexPath.item){
        [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.selIndexPath){
        QCIFilterCell *lastCell = (QCIFilterCell*)[collectionView cellForItemAtIndexPath:self.selIndexPath];
        lastCell.selected = NO;
    }
    
    QCIFilterCell *cell = (QCIFilterCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = YES;
    
    self.selIndexPath = indexPath;
}

@end
