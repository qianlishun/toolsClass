//
//  KGPhotosManager.m
//  KGPhotosLibary
//
//  Created by 北师智慧 on 2020/5/8.
//  Copyright © 2020 Heart likes static water. All rights reserved.
//

#import "KGPhotosManager.h"
#import <Photos/Photos.h>

#define KGScreen_width [UIScreen mainScreen].bounds.size.width
#define KGScreen_height [UIScreen mainScreen].bounds.size.height

static KGPhotosManager *manager = nil;

@interface KGPhotosManager()

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) List_Type type;

@end

@implementation KGPhotosManager

+ (instancetype)shareInstance{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[KGPhotosManager alloc] init];
  });
  return manager;
}

- (void)loadPhotosWithSize:(CGSize)size type:(List_Type)type{
  self.size = size;
  self.type = type;
  if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied) {
    [[NSNotificationCenter defaultCenter] postNotificationName:KGPhotosLibary_AuthorizationStatusDenied object:nil];
    return;
  }else if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusRestricted || [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined){
    __weak typeof(self) weakSelf = self;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
      switch (status) {
        case PHAuthorizationStatusDenied://用户已明确拒绝
          [[NSNotificationCenter defaultCenter] postNotificationName:KGPhotosLibary_AuthorizationStatusDenied object:nil];
          break;
        case PHAuthorizationStatusAuthorized://用户已授权
          [[NSNotificationCenter defaultCenter] postNotificationName:KGPhotosLibary_Authorization_Allow object:nil];
          [weakSelf reloadPhotosLibary];
          break;
        case PHAuthorizationStatusRestricted://未被授权
          [[NSNotificationCenter defaultCenter] postNotificationName:KGPhotosLibary_AuthorizationStatusDenied object:nil];
          break;
        case PHAuthorizationStatusNotDetermined://用户尚未对应用授权做出选择
          [[NSNotificationCenter defaultCenter] postNotificationName:KGPhotosLibary_AuthorizationStatusDenied object:nil];
          break;
      }
    }];
  }else{
    [[NSNotificationCenter defaultCenter] postNotificationName:KGPhotosLibary_Authorization_Allow object:nil];
    [self reloadPhotosLibary];
  }
}

- (void)reloadPhotosLibary{
  
  dispatch_async(dispatch_queue_create("GET_ALL_CLUMB_IMG", DISPATCH_QUEUE_CONCURRENT), ^{
    
    switch (self.type) {
      case List_Type_Photo:
        
        [self readLibaryPhotos];
        
        break;
        
      case List_Type_Video:
        
        [self readLibaryVideos];
        
        break;
      case List_Type_Photo_Video:
        
        [self readLibaryVideos];
        [self readLibaryPhotos];
        
        break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KGPhotosLibary_Send_All_Image object:nil];
  });
}

- (void)readLibaryPhotos{
  PHFetchResult *res = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
  for (PHAsset *set in res) {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    [[PHImageManager defaultManager] requestImageForAsset:set targetSize:CGSizeZero contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
      KGLog(@"%@--%@",result,info);
      [[NSNotificationCenter defaultCenter] postNotificationName:KGPhotosLibary_Send_Photos_Image object:@{@"img":result}];
    }];
  }
}

- (void)readLibaryVideos{
  PHFetchResult *videoRes = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:nil];
  for (PHAsset *set in videoRes) {
    KGLog(@"视频文件名:%@",set);
    PHVideoRequestOptions *options2 = [[PHVideoRequestOptions alloc] init];
    options2.deliveryMode=PHVideoRequestOptionsDeliveryModeAutomatic;
    [[PHImageManager defaultManager] requestAVAssetForVideo:set options:options2 resultHandler:^(AVAsset*_Nullable asset,
                                                                                                 AVAudioMix*_Nullable audioMix,NSDictionary*_Nullable info) {
      AVURLAsset *urlAsset = (AVURLAsset *)asset;
      KGLog(@"%@",urlAsset);
      [[NSNotificationCenter defaultCenter] postNotificationName:KGPhotosLibary_Send_Photos_Image object:@{@"img":urlAsset.URL}];
    }];
  }
}

// 获取视频第一帧
+ (UIImage*) getVideoPreViewImage:(NSURL *)path
{
  AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
  AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
  
  assetGen.appliesPreferredTrackTransform = YES;
  CMTime time = CMTimeMakeWithSeconds(0.0, 600);
  NSError *error = nil;
  CMTime actualTime;
  CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
  UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
  CGImageRelease(image);
  return videoImage;
}

+ (NSString *) videoTimeWithVideoPath:(NSURL *)path{
  AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
  float timeDouble = CMTimeGetSeconds(asset.duration);
  NSInteger hour = timeDouble/3600;
  NSInteger min = (timeDouble - hour*3600)/60;
  NSInteger senceds = timeDouble - hour*3600 - min*60;
  return [NSString stringWithFormat:@"%@%ld:%@%ld:%@%ld",hour<10?@"0":@"",(long)hour,min<10?@"0":@"",(long)min,senceds<10?@"0":@"",(long)senceds];
}

+ (float) floatVideoTimeWithVideoPath:(NSURL *)path{
  AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
  return CMTimeGetSeconds(asset.duration);
}

@end
