//
//  KGEditBottomView.h
//  KGPhotosLibary
//
//  Created by 北师智慧 on 2020/5/9.
//  Copyright © 2020 Heart likes static water. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^EditModeBlock)(void);

@interface KGEditBottomView : UIView

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIButton *editBtu;
@property (weak, nonatomic) IBOutlet UIButton *retoBtu;
@property (weak, nonatomic) IBOutlet UIButton *scaleBtu;
@property (weak, nonatomic) IBOutlet UIButton *returnBtu;
@property (weak, nonatomic) IBOutlet UIButton *shureBtu;

/** 裁剪模式block */
@property (nonatomic, copy) void(^editModeBlock)(void);
@property (nonatomic, copy) void(^retoModeBlock)(void);
@property (nonatomic, copy) void(^scaleModeBlock)(void);
@property (nonatomic, copy) void(^undoModeBlock)(void);
@property (nonatomic, copy) void(^setNormalBlock)(void);

@end

NS_ASSUME_NONNULL_END
