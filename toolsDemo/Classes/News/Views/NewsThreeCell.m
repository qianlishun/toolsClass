//
//  NewsThreeCell.m
//  toolsDemo
//
//  Created by Mr.Q on 16/6/4.
//  Copyright © 2016年 钱立顺. All rights reserved.
//

#import "NewsThreeCell.h"

@implementation NewsThreeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        [self setView];
    }
    return self;
}


- (void)setView{

    CGFloat margin = 10;

    self.lblTitle.sd_layout
    .topSpaceToView(self.contentView,margin)
    .leftSpaceToView(self.contentView,margin)
    .rightSpaceToView(self.contentView,margin)
    .heightIs(21);

    self.imgIcon.sd_layout
    .topSpaceToView(self.lblTitle,margin)
    .leftSpaceToView(self.contentView,margin)
    .rightSpaceToView(self.contentView,margin)
    .heightIs(120);

    self.lblSubtitle.sd_layout
    .topSpaceToView(self.imgIcon,margin)
    .rightSpaceToView(self.contentView,0)
    .leftSpaceToView(self.contentView,0)
    .autoHeightRatio(0);

    self.lineView.sd_layout
    .topSpaceToView(self.lblSubtitle,margin)
    .leftSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,0)
    .heightIs(1);

    [self setupAutoHeightWithBottomView:self.lineView bottomMargin:0];

}


- (void)setNewsModel:(NewsModel *)newsModel{

    self.lblTitle.text = newsModel.title;

    self.lblSubtitle.text = [NSString stringWithFormat:@"%@",newsModel.digest];

    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:newsModel.imgsrc] placeholderImage:[UIImage imageNamed:@"0"]];

}

@end
