//
//  KGPhotosLibary.h
//  KGPhotosLibary
//
//  Created by 北师智慧 on 2020/5/8.
//  Copyright © 2020 Heart likes static water. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGPhotosManager.h"

@interface KGPhotosLibary : UIViewController

@property (nonatomic, assign) NSInteger photoCount;
/** 是否允许编辑 */
@property (nonatomic, assign) BOOL allowEdit;
@property (nonatomic,copy) void(^sendChooseImage)(NSArray *result);
@property (nonatomic,assign) List_Type type;

@end
