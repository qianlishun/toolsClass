//
//  SetQRCodeController.m
//  toolsDemo
//
//  Created by Mr.Q on 16/6/22.
//  Copyright © 2016年 钱立顺. All rights reserved.
//

#import "SetQRCodeController.h"

@interface SetQRCodeController ()

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) UIButton *btn;

@end

#define kScreenSize [UIScreen mainScreen].bounds.size
@implementation SetQRCodeController

- (UIImageView *)imgView{
    if (!_imgView) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenSize.width*0.1, kScreenSize.height*0.2, kScreenSize.width*0.8, kScreenSize.width*0.8)];
        _imgView = imgView;
    }
    return _imgView;
}

- (UITextView  *)textView{

    if (!_textView) {
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 150, 100)];
        textView.center = self.view.center;
        [textView setBackgroundColor:[UIColor lightGrayColor]];
        _textView = textView;
    }
    return _textView;
}

- (UIButton *)btn{
    if (!_btn) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(self.textView.frame.size.width + self.textView.frame.origin.x + 5, self.textView.center.y, 60, 30)];
        [btn  setTitle:@"生成" forState: UIControlStateNormal];
        [btn setBackgroundColor: [UIColor colorWithRed:arc4random_uniform (256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]];

        [btn addTarget:self action:@selector(createClick) forControlEvents:UIControlEventTouchUpInside];
        _btn = btn;
    }
    return _btn;
}

// 使用滤镜生成二维码
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"生成二维码";

    [self.view addSubview:self.textView];

    [self.view addSubview:self.btn];
}

- (void)createClick{

    NSData *data = [self.textView.text dataUsingEncoding:NSUTF8StringEncoding];

    UIImage *headImage = [UIImage imageNamed:@"57495df2eab7e"];

    UIImage *QCardImg =  [self createQRCodeWithData:data andHeadImage:headImage];

    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    [self.view addSubview:self.imgView];

    self.imgView.image = QCardImg;

    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 24)];
    cancelBtn.center = CGPointMake(self.view.center.x, kScreenSize.height * 0.8);
    [cancelBtn setTitle:@"返回" forState: UIControlStateNormal];
    [cancelBtn setBackgroundColor: [UIColor colorWithRed:arc4random_uniform (256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]];
    [cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:cancelBtn];
}

- (void)cancelClick:(UIButton *)sender{

    [self.imgView removeFromSuperview];
    [sender removeFromSuperview];

    self.textView.text = @"";
    [self.view addSubview:self.textView];

    [self.view addSubview:self.btn];
}

- (UIImage *)createQRCodeWithData:(NSData *)data andHeadImage:(UIImage *)headImage{
    // 准备滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];

    // 设置默认值
    [filter setDefaults];

    // 生成要显示的字符串数据
    [filter setValue:data forKeyPath:@"inputMessage"];

    [filter setValue:@"H" forKeyPath:@"inputCorrectionLevel"];

    // 输出
    CIImage *coreImage = [filter outputImage];

    // 1.要把图像无损放大
    UIImage *QRImage = [self imageWithCIImage:coreImage andSize:self.imgView.bounds.size];

    // 2.要合成头像
    CGSize headSize = CGSizeMake(self.imgView.bounds.size.width * 0.25, self.imgView.bounds.size.height * 0.25);

    UIImage *QRCardImage = [self imageWithBackgroundImage:QRImage centerImage:headImage centerImageSize:headSize];

    return QRCardImage;
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
@end
