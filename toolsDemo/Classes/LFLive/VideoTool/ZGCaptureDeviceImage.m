//
//  ZGCaptureDeviceImage.m
//  ZegoExpressExample-iOS-OC
//
//  Created by Patrick Fu on 2020/1/12.
//  Copyright © 2020 Zego. All rights reserved.
//

#import "ZGCaptureDeviceImage.h"

@interface ZGCaptureDeviceImage ()

@property (nonatomic, strong) UIImage *motionImage;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, assign) NSUInteger fps;
@property (nonatomic, strong) NSTimer *fpsTimer;


@property (nonatomic, assign) CVPixelBufferRef cameraBuff;

@end

@implementation ZGCaptureDeviceImage

- (instancetype)initWithMotionImage:(CGImageRef)image contentSize:(CGSize)size {
    self = [super init];
    if (self) {
//        self.motionImage = image;
        self.contentSize = size;
    }
    return self;
}

- (void)updateImage:(UIImage*)image cameraBuff:(CVPixelBufferRef)buff contentSize:(CGSize)size{
    if( self.motionImage != image){

        CGFloat cameraWidth = buff ? CVPixelBufferGetWidth(buff)/image.scale : 0;
        
        CGFloat width = image.size.width + cameraWidth;
        
        float wScale = width / size.width;
        float hScale = image.size.height / size.height;
        
        float scale = MAX(wScale, hScale) * image.scale;
        
        self.contentSize = CGSizeMake(size.width * scale, size.height * scale);

        self.motionImage = image;
        
        self.cameraBuff = buff;
        
        [self captureImage];
    }
}

- (void)updateImage:(UIImage*)image contentSize:(CGSize)size{
    if(self.motionImage != image){

        float wScale = image.size.width / size.width;
        float hScale = image.size.height / size.height;
        
        float scale = MAX(wScale, hScale) * image.scale;
        
        self.contentSize = CGSizeMake(size.width * scale, size.height * scale);

        self.motionImage = image;
        
        [self captureImage];
    }
}

- (void)dealloc {
//    CGImageRelease(_motionImage);
}

- (void)startCapture {
    // 用camera的回调或者RawImage的更新处理，这里不再重复使用定时器
//    ZGLogInfo(@"▶️ Start capture motion image");
//    if (!self.fpsTimer) {
//        self.fps = self.fps ? self.fps : 15;
//        NSTimeInterval delta = 1.f / self.fps;
//        self.fpsTimer = [NSTimer timerWithTimeInterval:delta target:self selector:@selector(captureImage) userInfo:nil repeats:YES];
//        [NSRunLoop.mainRunLoop addTimer:self.fpsTimer forMode:NSRunLoopCommonModes];
//    }
//
//    [self.fpsTimer fire];
//    [self captureImage];// Called immediately at the beginning
}

- (void)stopCapture {
//    ZGLogInfo(@"⏸ Stop capture motion image");
//    if (self.fpsTimer) {
//        [self.fpsTimer invalidate];
//        self.fpsTimer = nil;
//    }
}

- (void)captureImage {
    if(!self.motionImage)
        return;
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        
        CVPixelBufferRef pixelBuffer = [self pixelBufferFromImage:self.motionImage.CGImage cameraBuff:self.cameraBuff contentSize:self.contentSize];

        CMTime time = CMTimeMakeWithSeconds([[NSDate date] timeIntervalSince1970], 1000);
        CMSampleTimingInfo timingInfo = { kCMTimeInvalid, time, time };

        CMVideoFormatDescriptionRef desc;
        CMVideoFormatDescriptionCreateForImageBuffer(kCFAllocatorDefault, pixelBuffer, &desc);

        CMSampleBufferRef sampleBuffer;
        CMSampleBufferCreateReadyWithImageBuffer(kCFAllocatorDefault, (CVImageBufferRef)pixelBuffer, desc, &timingInfo, &sampleBuffer);

        id<ZGCaptureDeviceDataOutputPixelBufferDelegate> delegate = self.delegate;
        if (delegate &&
            [delegate respondsToSelector:@selector(captureDevice:didCapturedData:)]) {
            [delegate captureDevice:self didCapturedData:sampleBuffer];
        }

        CFRelease(sampleBuffer);
        CFRelease(desc);
        CVPixelBufferRelease(pixelBuffer);
    });
}

#pragma mark - Utility Method

static OSType inputPixelFormat(){
    return kCVPixelFormatType_32BGRA;
}

static uint32_t bitmapInfoWithPixelFormatType(OSType inputPixelFormat, bool hasAlpha){

    if (inputPixelFormat == kCVPixelFormatType_32BGRA) {
        uint32_t bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host;
        if (!hasAlpha) {
            bitmapInfo = kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Host;
        }
        return bitmapInfo;
    } else if (inputPixelFormat == kCVPixelFormatType_32ARGB) {
        uint32_t bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big;
        
        return bitmapInfo;
    } else {
        NSLog(@"Unsupported bitmap format");
        return 0;
    }
}

BOOL imageContainsAlpha(CGImageRef imageRef) {
    if (!imageRef) {
        return NO;
    }
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    BOOL hasAlpha = !(alphaInfo == kCGImageAlphaNone ||
                      alphaInfo == kCGImageAlphaNoneSkipFirst ||
                      alphaInfo == kCGImageAlphaNoneSkipLast);
    return hasAlpha;
}

- (CVPixelBufferRef)pixelBufferFromImage:(CGImageRef)image cameraBuff:(CVPixelBufferRef)camerabuff contentSize:(CGSize)contentSize {

    CVReturn status;
    CVPixelBufferRef pixelBuffer;
    
    NSDictionary *pixelBufferAttributes = @{
        (id)kCVPixelBufferIOSurfacePropertiesKey: [NSDictionary dictionary],
        (id)kCVPixelBufferCGImageCompatibilityKey: @(YES),
        (id)kCVPixelBufferCGBitmapContextCompatibilityKey: @(YES)
    };
    
    status = CVPixelBufferCreate(kCFAllocatorDefault, contentSize.width, contentSize.height, inputPixelFormat(), (__bridge CFDictionaryRef)pixelBufferAttributes, &pixelBuffer);
    
    if (status != kCVReturnSuccess) {
        return NULL;
    }
    
    time_t currentTime = time(0);
    
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    
    void *data = CVPixelBufferGetBaseAddress(pixelBuffer);
    

    NSUInteger bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer);

    CGFloat imageWidth = CGImageGetWidth(image);
    CGFloat imageHeight = CGImageGetHeight(image);
    static CGPoint origin = {0, 0};
    static time_t lastTime = 0;
    
    if(camerabuff){
        CVPixelBufferLockBaseAddress(camerabuff,0);
        void *cData = CVPixelBufferGetBaseAddress(camerabuff);
        int cWidth = (int)CVPixelBufferGetWidth(camerabuff);
        int cHeight = (int)CVPixelBufferGetHeight(camerabuff);
//        NSLog(@"camera %.f",cWidth);
//         拷贝视频图像
        for (int y = 0; y < cHeight; y++) {
            memcpy(data+y*bytesPerRow, cData+y*cWidth*4, cWidth*4);
        }
        CVPixelBufferUnlockBaseAddress(camerabuff, 0);
        
        if(contentSize.width > imageWidth || contentSize.height > imageHeight){
            origin.x =  (int)( (contentSize.width - imageWidth) );
            origin.y =  (int)( (contentSize.height - imageHeight)/2 );
        }
    }else{
        if(contentSize.width > imageWidth || contentSize.height > imageHeight){
            origin.x =  (int)( (contentSize.width - imageWidth) /2 );
            origin.y =  (int)( (contentSize.height - imageHeight)/2 );
        }
    }

    if (lastTime != currentTime) {
        lastTime = currentTime;
    }
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();

    BOOL hasAlpha = imageContainsAlpha(image);

    uint32_t bitmapInfo = bitmapInfoWithPixelFormatType(inputPixelFormat(), (bool)hasAlpha);
    
    CGContextRef context = CGBitmapContextCreate(data, contentSize.width, contentSize.height, 8, bytesPerRow, rgbColorSpace, bitmapInfo);
    
    CGContextDrawImage(context, CGRectMake(origin.x, origin.y, imageWidth, imageHeight), image);
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);

    return pixelBuffer;
}

@end
