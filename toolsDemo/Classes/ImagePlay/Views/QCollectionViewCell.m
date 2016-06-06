//
//  QCollectionViewCell.m
//  toolsDemo
//
//  Created by Mr.Q on 16/5/9.
//  Copyright © 2016年 钱立顺. All rights reserved.
//

#import "QCollectionViewCell.h"

@interface QCollectionViewCell ()


@property (nonatomic,weak)  UIImageView *imgViewIcon;


@end


@implementation QCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {

        //创建子控件
        UIImageView *imgViewIcon = [[UIImageView alloc]init];
        [self.contentView addSubview:imgViewIcon];
        self.imgViewIcon = imgViewIcon;

    }

    return self;
}

-(void)setImage:(UIImage *)image{
    _image = image;

    self.imgViewIcon.image = image;

}

-(void)layoutSubviews{

    [super layoutSubviews];

    self.imgViewIcon.frame = self.contentView.bounds;
}

@end
