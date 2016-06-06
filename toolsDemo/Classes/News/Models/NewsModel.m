//
//  NewsModel.m
//  toolsDemo
//
//  Created by Mr.Q on 16/6/4.
//  Copyright © 2016年 钱立顺. All rights reserved.
//

#import "NewsModel.h"
#import "MJExtension.h"

@implementation NewsModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"imgextra":@"Imgextra",
             @"editor":@"Editor",
             @"ads":@"Ads"
             };
}
@end
