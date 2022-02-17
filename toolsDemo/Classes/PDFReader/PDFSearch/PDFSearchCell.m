//
//  PDFSearchCell.m
//  toolsDemo
//
//  Created by Qianlishun on 2022/2/15.
//  Copyright © 2022 钱立顺. All rights reserved.
//

#import "PDFSearchCell.h"

@implementation PDFSearchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.destinationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, 20)];
        self.destinationLabel.textColor = [UIColor blackColor];
        self.destinationLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.destinationLabel];
        
        self.resultLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.destinationLabel.bottom, self.width, self.height-self.destinationLabel.bottom)];
        self.resultLabel.textColor = [UIColor blackColor];
        self.resultLabel.numberOfLines = 0;
        [self.contentView addSubview:self.resultLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.destinationLabel setFrame:CGRectMake(0, 0, self.width, 20)];

    [self.resultLabel setFrame:CGRectMake(0, self.destinationLabel.bottom, self.width, self.height-self.destinationLabel.bottom)];
}

@end
