//
//  LockView.h
//  toolsDemo
//
//  Created by Mr.Q on 16/5/9.
//  Copyright © 2016年 钱立顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LockView : UIView

@property (nonatomic,copy) BOOL (^lockBlock) (NSString *,UIImage *);

@end
