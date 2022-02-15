//
//  PDFOutlineCell.m
//  toolsDemo
//
//  Created by Qianlishun on 2022/2/15.
//  Copyright © 2022 钱立顺. All rights reserved.
//

#import "PDFOutlineCell.h"


@implementation PDFOutlineCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
     
        self.offsetX = self.indentationWidth;
        
        self.selBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.selBtn setFrame:CGRectMake(10, 0, 20, 20)];
        [self.contentView addSubview:self.selBtn];
        [self.selBtn addTarget:self action:@selector(onSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        self.leftLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.leftLabel];
        
        
        self.rightLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.rightLabel];
        self.rightLabel.textAlignment = NSTextAlignmentRight;
        
        self.backgroundColor = [UIColor clearColor];
        self.leftLabel.textColor = self.rightLabel.textColor
        = [UIColor blackColor];
        
        _leftLabel.adjustsFontSizeToFitWidth = _rightLabel.adjustsFontSizeToFitWidth = YES;

        _leftLabel.numberOfLines = _rightLabel.numberOfLines = 1;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)onSelected:(UIButton*)sender{
    sender.selected = !sender.isSelected;
    
    if(self.outlineBlock){
        self.outlineBlock(sender);
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.offsetX = self.indentationWidth * self.indentationLevel+10;

    CGFloat h = self.contentView.bounds.size.height;
    CGFloat w = self.contentView.bounds.size.width;
    
    [self.selBtn setFrame:CGRectMake(self.offsetX, 0, h, h)];

    if(self.rightLabel.text.length>0){
        [self.leftLabel setFrame:CGRectMake(self.selBtn.right+5, 0, w-self.selBtn.right-75, h)];
        self.leftLabel.height = h;
            
        [self.rightLabel setFrame:CGRectMake(w-70, 0, 60, h)];
    }else{
        [self.leftLabel setFrame:CGRectMake(self.selBtn.right+5, 0, w - self.selBtn.right-5, h)];
        self.leftLabel.height = h;
    }
    
    if (self.indentationLevel == 0)
    {
        self.leftLabel.font = [UIFont systemFontOfSize:17];
    }
    else
    {
        self.leftLabel.font = [UIFont systemFontOfSize:15];
    }
    
    
}

@end
