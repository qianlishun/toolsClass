//
//  ZGCaptureDeviceImage.h
//  ZegoExpressExample-iOS-OC
//
//  Created by Patrick Fu on 2020/1/12.
//  Copyright © 2020 Zego. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ZGCaptureDeviceProtocol.h"


@interface ZGCaptureDeviceImage : NSObject <ZGCaptureDevice>

@property (nonatomic, weak) id<ZGCaptureDeviceDataOutputPixelBufferDelegate> delegate;

- (instancetype)initWithMotionImage:(CGImageRef)image contentSize:(CGSize)size;

- (void)updateImage:(UIImage*)image contentSize:(CGSize)size;

- (void)updateImage:(UIImage*)image cameraBuff:(CVPixelBufferRef)buff contentSize:(CGSize)size;
@end
