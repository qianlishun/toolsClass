//
//  WaterfallFlowLayout.h
//  toolsDemo
//
//  Created by Mr.Q on 16/5/11.
//  Copyright © 2016年 钱立顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterfallFlowLayout : UICollectionViewFlowLayout

@property (nonatomic,assign) int columns;

@property (nonatomic,strong) NSArray *dataArray;


@end
