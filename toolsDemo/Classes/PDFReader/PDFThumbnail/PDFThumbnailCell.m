//
//  PDFThumbnailCell.m
//  toolsDemo
//
//  Created by Qianlishun on 2022/2/15.
//  Copyright © 2022 钱立顺. All rights reserved.
//

#import "PDFThumbnailCell.h"

@implementation PDFThumbnailCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat cellWidth = frame.size.width;
        CGFloat cellHeight = cellWidth * 1.5;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight)];
        _imageView.userInteractionEnabled = YES;
        
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        _titleLabel.center = CGPointMake(cellWidth / 2, cellHeight - 20);
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.layer.cornerRadius = 2;
        _titleLabel.layer.masksToBounds = YES;
        _titleLabel.backgroundColor = [UIColor blackColor];
        
        [self addSubview:_titleLabel];

    }
    return self;
}
@end
