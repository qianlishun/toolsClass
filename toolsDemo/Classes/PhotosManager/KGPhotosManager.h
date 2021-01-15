//
//  KGPhotosManager.h
//  KGPhotosLibary
//
//  Created by 北师智慧 on 2020/5/8.
//  Copyright © 2020 Heart likes static water. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, List_Type) {
  List_Type_Photo = 0,      //只显示图片
  List_Type_Video,          //只显示视频
  List_Type_Photo_Video,    //显示视频和图片
};

static NSString *const KGPhotosLibary_AuthorizationStatusDenied = @"KGPhotosLibary_AuthorizationStatusDenied";
static NSString *const KGPhotosLibary_Send_Photos_Image = @"KGPhotosLibary_Send_Photos_Image";
static NSString *const KGPhotosLibary_Authorization_Allow = @"KGPhotosLibary_Authorization_Allow";
static NSString *const KGPhotosLibary_Send_All_Image = @"KGPhotosLibary_Send_All_Image";

@interface KGPhotosManager : NSObject

+ (instancetype)shareInstance;
- (void)loadPhotosWithSize:(CGSize)size type:(List_Type)type;
// 获取视频第一帧
+ (UIImage*) getVideoPreViewImage:(NSURL *)path;
/// 获取视频时长
/// @param path 视频路径
+ (NSString *) videoTimeWithVideoPath:(NSURL *)path;

+ (float) floatVideoTimeWithVideoPath:(NSURL *)path;

@end

NS_ASSUME_NONNULL_END
