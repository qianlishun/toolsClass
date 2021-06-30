//
//  QStateModel.h
//  toolsDemo
//
//  Created by Qianlishun on 2021/6/22.
//  Copyright © 2021 钱立顺. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QStateModel : NSObject
+ (instancetype)sharedInstance;

@property (nonatomic,copy) NSString *machine;

@property (nonatomic,assign) UIEdgeInsets edgeInsets;

@end

NS_ASSUME_NONNULL_END
