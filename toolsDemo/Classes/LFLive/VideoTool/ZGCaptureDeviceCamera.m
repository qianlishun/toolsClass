//
//  ZGCaptureDeviceCamera.m
//  ZegoExpressExample-iOS-OC
//
//  Created by Patrick Fu on 2020/1/12.
//  Copyright © 2020 Zego. All rights reserved.
//

#import "ZGCaptureDeviceCamera.h"

@interface ZGCaptureDeviceCamera () <AVCaptureVideoDataOutputSampleBufferDelegate> {
    dispatch_queue_t _sampleBufferCallbackQueue;
}

@property (nonatomic, assign) OSType pixelFormatType;
@property (nonatomic, assign) AVCaptureDevicePosition cameraPosition;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureVideoDataOutput *output;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, assign) int framerate;

@property (nonatomic, assign) BOOL isRunning;

@end

@implementation ZGCaptureDeviceCamera

- (instancetype)initWithPixelFormatType:(OSType)pixelFormatType {
    self = [super init];
    if (self) {
        _pixelFormatType = pixelFormatType;

        // Use front camera as default
        _cameraPosition = AVCaptureDevicePositionBack;

        // Default is 30 fps
        _framerate = 15;

        _sampleBufferCallbackQueue = dispatch_queue_create("im.zego.ZGCustomVideoCaptureCameraDevice.outputCallbackQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)dealloc {
//    [self stopCapture];
}


- (void)startCapture {
    if (self.isRunning) {
        return;
    }
    
    [self.session beginConfiguration];
    
//    if ([self.session canSetSessionPreset:AVCaptureSessionPreset352x288]) {
//        [self.session setSessionPreset:AVCaptureSessionPreset352x288];
//    }
  
    if ([self.session canSetSessionPreset:AVCaptureSessionPresetLow]) {
        [self.session setSessionPreset:AVCaptureSessionPresetLow];
    }
    
    AVCaptureDeviceInput *input = self.input;
    
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }
    
    
    AVCaptureVideoDataOutput *output = self.output;
    
    if ([self.session canAddOutput:output]) {
        [self.session addOutput:output];
    }
    
    AVCaptureConnection *captureConnection = [output connectionWithMediaType:AVMediaTypeVideo];

    // Mirror the video when using the front camera
    if (input.device.position == AVCaptureDevicePositionFront) {
        captureConnection.videoMirrored = YES;
    }
    
    if (captureConnection.isVideoOrientationSupported) {
        captureConnection.videoOrientation = [self getCaptureVideoOrientation];
    }
    
    [self.session commitConfiguration];
    
    if (!self.session.isRunning) {
        [self.session startRunning];
    }
    
    self.isRunning = YES;
}

- (void)stopCapture {
    if (!self.isRunning) {
        return;
    }
    
    if (self.session.isRunning) {
        [self.session stopRunning];
        [self.session removeInput:_input];
    }
    
    self.isRunning = NO;
}

- (void)switchCameraPosition {

    if (self.cameraPosition == AVCaptureDevicePositionFront) {
        self.cameraPosition = AVCaptureDevicePositionBack;
    } else {
        self.cameraPosition = AVCaptureDevicePositionFront;
    }



    // Restart capture
    if (self.isRunning) {
        [self stopCapture];
        [self startCapture];
    }

}

- (void)setFramerate:(int)framerate {
    if (!_device) {
        NSLog(@"Camera is not actived");
        return;
    }

    NSArray<AVFrameRateRange *> *ranges = _device.activeFormat.videoSupportedFrameRateRanges;
    AVFrameRateRange *range = [ranges firstObject];

    if (!range) {
        NSLog(@"videoSupportedFrameRateRanges is empty");
        return;
    }

    if (framerate > range.maxFrameRate || framerate < range.minFrameRate) {
        NSLog(@"Unsupport framerate: %d, range is %.2f ~ %.2f", framerate, range.minFrameRate, range.maxFrameRate);
        return;
    }

    NSError *error = [[NSError alloc] init];
    if (![_device lockForConfiguration:&error]) {
        NSLog(@"AVCaptureDevice lockForConfiguration failed. errCode:%ld, domain:%@", error.code, error.domain);
    }
    _device.activeVideoMinFrameDuration = CMTimeMake(1, framerate);
    _device.activeVideoMaxFrameDuration = CMTimeMake(1, framerate);
    [_device unlockForConfiguration];

    NSLog(@"Set framerate to %d", framerate);
}


#pragma mark - Getter

- (AVCaptureSession *)session {
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
    }
    return _session;
}

// Reacquire the camera every time it is called
- (AVCaptureDevice *)device {
    
    AVCaptureDeviceDiscoverySession *deviceDiscoverSession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionUnspecified];
    
#if TARGET_OS_OSX

    // Note: This demonstration selects the last camera on Mac. Developers should choose the appropriate camera device by themselves.
    AVCaptureDevice *camera = deviceDiscoverSession.devices.lastObject;
    if (!camera) {
        NSLog(@"Failed to get camera");
        return nil;
    }

#elif TARGET_OS_IOS

    // Get the specified position camera
    NSArray *captureDeviceArray = [deviceDiscoverSession.devices filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"position == %d", _cameraPosition]];
    if (captureDeviceArray.count == 0) {
        NSLog(@"Failed to get camera");
        return nil;
    }
    AVCaptureDevice *camera = captureDeviceArray.firstObject;

#endif

    _device = camera;
    return _device;
}

// Reacquire the camera every time it is called
- (AVCaptureDeviceInput *)input {

    NSError *error = nil;
    AVCaptureDeviceInput *captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if (error) {
        NSLog(@"Conversion of AVCaptureDevice to AVCaptureDeviceInput failed");
        return nil;
    }
    _input = captureDeviceInput;

    return _input;
}

- (AVCaptureVideoDataOutput *)output {
    if (!_output) {
        AVCaptureVideoDataOutput *videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        videoDataOutput.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey:@(self.pixelFormatType)};
        [videoDataOutput setSampleBufferDelegate:self queue:_sampleBufferCallbackQueue];
        _output = videoDataOutput;
    }
    return _output;
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {

    CFRetain(sampleBuffer);
    id<ZGCaptureDeviceDataOutputPixelBufferDelegate> delegate = self.delegate;
    if (delegate && [delegate respondsToSelector:@selector(captureDevice:didCapturedData:)]) {
        [delegate captureDevice:self didCapturedData:sampleBuffer];
    }
    CFRelease(sampleBuffer);
}
    


- (AVCaptureVideoOrientation)getCaptureVideoOrientation {
    AVCaptureVideoOrientation result;
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    switch (deviceOrientation) {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
            result = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            //如果这里设置成AVCaptureVideoOrientationPortraitUpsideDown，则视频方向和拍摄时的方向是相反的。
            result = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationLandscapeLeft:
            result = AVCaptureVideoOrientationLandscapeRight;
            break;
        case UIDeviceOrientationLandscapeRight:
            result = AVCaptureVideoOrientationLandscapeLeft;
            break;
        default:
            result = AVCaptureVideoOrientationPortrait;
            break;
    }
    
    return result;
}
@end
