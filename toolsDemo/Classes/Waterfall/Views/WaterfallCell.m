//
//  WaterfallCell.m
//  toolsDemo
//
//  Created by Mr.Q on 16/5/11.
//  Copyright © 2016年 钱立顺. All rights reserved.
//

#import "WaterfallCell.h"

@interface WaterfallCell  ()


@property (nonatomic,strong) UIImageView *imgView;

@end


@implementation WaterfallCell

-(void)setImage:(UIImage *)image{
    _image = image;

    self.imgView.image = image;
}


-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {

        //创建子控件
        UIImageView *imgView = [[UIImageView alloc]init];
        [self.contentView addSubview:imgView];
        self.imgView = imgView;

    }
    
    return self;
}


-(void)layoutSubviews{
//self.contentView.bounds
    self.imgView.frame = self.bounds;
}


@end
