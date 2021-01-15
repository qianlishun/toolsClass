//
//  KGChangeImgSizeView.h
//  KGPhotosLibary
//
//  Created by 北师智慧 on 2020/5/9.
//  Copyright © 2020 Heart likes static water. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KGChangeImgSizeView : UIView

@property (strong, nonatomic) IBOutlet UIView *mainView;
/** 16：9模式 */
@property (nonatomic, copy) void(^typeOf16Than9Block)(void);
/** 4：3模式 */
@property (nonatomic, copy) void(^typeOf4Than3Block)(void);
/** 1：1模式 */
@property (nonatomic, copy) void(^typeOfEqurlBlock)(void);
/** 3：4模式 */
@property (nonatomic, copy) void(^typeOf3Than4Block)(void);
/** 9：16模式 */
@property (nonatomic, copy) void(^typeOf9Than16Block)(void);
/** 自定义裁剪*/
@property (nonatomic, copy) void(^typeOfCustomBlock)(void);

@end

NS_ASSUME_NONNULL_END
