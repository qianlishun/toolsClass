//
//  QCIFilterCell.m
//  toolsDemo
//
//  Created by Qianlishun on 2022/12/29.
//  Copyright © 2022 钱立顺. All rights reserved.
//

#import "QCIFilterCell.h"

@interface QCIFilterCell()
@property(nonatomic, strong) UILabel *label;
@end

@implementation QCIFilterCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self borderForColor:[UIColor blackColor] borderWidth:1.0 borderType:UIBorderSideTypeAll];
        self.label = [UILabel new];
        self.label.numberOfLines = 0;
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.adjustsFontSizeToFitWidth = YES;
        self.label.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.label];
        self.label.sd_layout
        .topSpaceToView(self.contentView,5)
        .bottomSpaceToView(self.contentView, 5)
        .leftSpaceToView(self.contentView,5)
        .rightSpaceToView(self.contentView,5);
        
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    self.label.text = title;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    UIColor *color = selected ? [UIColor blueColor] : [UIColor blackColor];
    self.label.textColor = color;
}

@end
