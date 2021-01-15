//
//  KGAVPlayerVC.h
//  WD_HJ
//
//  Created by 北师智慧 on 2020/6/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KGAVPlayerVCDelegate <NSObject>

- (void)sendVideoURL:(NSString *)url;

@end

@interface KGAVPlayerVC : UIViewController

@property (nonatomic,copy) NSURL *url;
@property (nonatomic,weak) id<KGAVPlayerVCDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
