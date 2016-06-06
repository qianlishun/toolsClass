//
//  FRGWaterfallCollectionViewCell.m
//  WaterfallCollectionView
//
//  Created by Miroslaw Stanek on 12.07.2013.
//  Copyright (c) 2013 Event Info Ltd. All rights reserved.
//

#import "FRGWaterfallCollectionViewCell.h"

@interface FRGWaterfallCollectionViewCell()

@property (weak, nonatomic)  UIImageView *imgView;

@end

@implementation FRGWaterfallCollectionViewCell

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
