//
//  QLiveViewController.m
//  toolsDemo
//
//  Created by Qianlishun on 2021/7/28.
//  Copyright © 2021 钱立顺. All rights reserved.
//


#define MAS_SHORTHAND_GLOBALS

#import "QLiveViewController.h"
#import "Masonry.h"
#import "ZGCaptureDeviceCamera.h"


@interface QLiveViewController ()<ZGCaptureDeviceDataOutputPixelBufferDelegate>

@property (nonatomic,strong) UIImageView *cameraView;

@property (nonatomic,strong) AVSampleBufferDisplayLayer *cameraDisplayLayer;

@property (nonatomic, strong) id<ZGCaptureDevice> captureDeviceCamera;

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,assign) NSInteger index;

@end

@implementation QLiveViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.index = 2;
    
    [self.view.layer addSublayer:self.cameraDisplayLayer];
    
    [self.view addSubview:self.cameraView];
    
    [self.view addSubview:self.imageView];
    
    [self.captureDeviceCamera startCapture];
    
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1/15.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
//
//        UIImage *image = [self screenForLive];
////        self.imageView.image = image;
//    }];
//    [timer fire];
}


- (void)captureDevice:(id<ZGCaptureDevice>)device didCapturedData:(CMSampleBufferRef)data{
    
    if(self.index == 0){
        [self.cameraDisplayLayer enqueueSampleBuffer:data];
    }else if(self.index == 1){
        dispatch_sync(dispatch_get_main_queue(), ^{
            UIImage *image = [self imageFromBuffer:data];
            self.cameraView.image = image;
        });
    }else if(self.index == 2){
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.imageView.image = nil;
            
            UIImage *image = [self imageFromBuffer:data];
            self.cameraView.image = image;

            image = [self screenForLive];
//            self.imageView.image = image;
        });
       
    }
}

- (UIImage *)screenForLive{
    CGSize size = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    size.width = (int)(size.width + 1)/2*2; size.height = (int)size.height;
    float scale = 2;
    UIGraphicsBeginImageContextWithOptions(size, YES, scale);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

- (UIImage *)imageFromBuffer:(CMSampleBufferRef)buffer {
    CVPixelBufferRef pixelBuffer = (CVPixelBufferRef)CMSampleBufferGetImageBuffer(buffer);
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext createCGImage:ciImage fromRect:CGRectMake(0, 0, CVPixelBufferGetWidth(pixelBuffer), CVPixelBufferGetHeight(pixelBuffer))];
    UIImage *image = [UIImage imageWithCGImage:videoImage];
    CGImageRelease(videoImage);
    return image;
}


- (id<ZGCaptureDevice>)captureDeviceCamera{
    if (!_captureDeviceCamera) {
        OSType pixelFormat = kCVPixelFormatType_32BGRA;
        _captureDeviceCamera = [[ZGCaptureDeviceCamera alloc] initWithPixelFormatType:pixelFormat];
        _captureDeviceCamera.delegate = self;
    }
    return _captureDeviceCamera;
}

- (UIImageView *)cameraView{
    if(!_cameraView){
        _cameraView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 50, 150, 150)];
    }
    return _cameraView;
}

- (AVSampleBufferDisplayLayer *)cameraDisplayLayer{
    if(!_cameraDisplayLayer){
        _cameraDisplayLayer = [[AVSampleBufferDisplayLayer alloc] init];
        [_cameraDisplayLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
        [_cameraDisplayLayer setFrame:CGRectMake(50, 200, 150, 150)];
        _cameraDisplayLayer.opaque = YES;
    }
    return _cameraDisplayLayer;
}

- (UIImageView *)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 350, 300, 300)];
    }
    return _imageView;
}

@end
