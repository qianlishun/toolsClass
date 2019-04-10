//
//  QCollectionViewCell.m
//  toolsDemo
//
//  Created by mrq on 2019/4/10.
//  Copyright © 2019 钱立顺. All rights reserved.
//

#import "QEatCollectionViewCell.h"

@implementation QEatCellModel
@end

@interface QEatCollectionViewCell()

@end

@implementation QEatCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor lightGrayColor];
        
        self.descLabel = [[UILabel alloc]initWithFrame:self.bounds];
        self.descLabel.textColor = [UIColor blackColor];
        self.descLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.descLabel];
        
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteButton setFrame:CGRectMake(frame.size.width-20, 0, 20, 20)];
        [self addSubview:self.deleteButton];
        [_deleteButton setImage:[UIImage imageNamed:@"clear"] forState:UIControlStateNormal];
        self.deleteButton.hidden = YES;
    }
    return self;
}

@end
