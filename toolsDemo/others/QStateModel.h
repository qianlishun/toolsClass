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

+ (void)createFolderPath:(NSString*)path;

@property (nonatomic,copy) NSString *machine;

@property (nonatomic,assign) UIEdgeInsets edgeInsets;

@property(nonatomic, strong) NSDictionary *pdfSaveData;

@end

NS_ASSUME_NONNULL_END
