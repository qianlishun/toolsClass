//
//  DemoCell.m
//  toolsClass
//
//  Created by Mr.Q on 15/9/17.
//  Copyright © 2015年 QLS. All rights reserved.
//

#import "DemoCell.h"

#import "UIView+SDAutoLayout.h"

@implementation DemoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;

    UILabel *contentLabel = [UILabel new];
    contentLabel.textColor = [UIColor grayColor];
    contentLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;

    CGFloat margin = 10;

    self.titleLabel.sd_layout
    .leftSpaceToView(self.contentView, margin)
    .topSpaceToView(self.contentView, margin)
    .rightSpaceToView(self.contentView, margin)
    .heightIs(20);

    self.contentLabel.sd_layout
    .leftEqualToView(self.titleLabel)
    .rightEqualToView(self.titleLabel)
    .topSpaceToView(self.titleLabel, margin)
    .autoHeightRatio(0);

    [self setupAutoHeightWithBottomView:self.contentLabel bottomMargin:margin];
}

@end
