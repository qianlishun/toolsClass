//
//  QTableViewCell.m
//  toolsDemo
//
//  Created by mrq on 2020/12/11.
//  Copyright © 2020 钱立顺. All rights reserved.
//

#import "QTableViewCell.h"
#import "Masonry.h"

@interface QTableViewCell()
@property (nonatomic,strong) UIView *theView;
@property (nonatomic,strong) UILabel *titleLabel;
@end

@implementation QTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        for (UIView*v in self.subviews) {
            [v removeFromSuperview];
        }
        for (id obj in self.subviews)
        {
            if ([NSStringFromClass([obj class]) isEqualToString:@"UITableViewCellScrollView"])
            {
                UIScrollView *scroll = (UIScrollView *) obj;
                scroll.delaysContentTouches = NO;
                break;
            }
        }
        UIView *v = [[UIView alloc]initWithFrame:self.bounds];
//        v.backgroundColor = [UIColor lightGrayColor];
        self.selectedBackgroundView = v;
        
    }
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    if(self.theView){
        [self.theView removeFromSuperview];
        self.theView = nil;
    }
}

- (void)setText:(NSString *)text{
    if(text==nil || text.length==0){
        if(self.titleLabel){
            [self.titleLabel removeFromSuperview];
            self.titleLabel = nil;
        }
        return;
    }
    if(!_titleLabel){
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0.4*self.width, self.height)];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = [UIColor blackColor];
        [self addSubview:self.titleLabel];
    }
    self.titleLabel.size = CGSizeMake(self.width*0.4, self.height);
    self.titleLabel.center = CGPointMake(self.width/2, self.height/2);
    self.titleLabel.text = text;

}

- (void)setView:(UIView *)view{
    if(_theView != view){
        if(_theView){
            [_theView removeFromSuperview];
        }
        _theView = view;
        [self addSubview:view];
        
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.selectedBackgroundView setFrame:self.bounds];
    
    [self.titleLabel sizeToFit];
    if(!_theView){
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.center = CGPointMake(self.width/2, self.height/2);
        
    }else if(!_titleLabel){
        self.theView.width = self.width-20;
        self.theView.center = CGPointMake(self.width/2, self.height/2);
        
    }else{
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.x = 10;
        self.titleLabel.centerY = self.height/2;

        self.theView.width = self.width * 0.5-10;
        self.theView.right = self.width - 10;
        self.theView.centerY = self.height/2;
    }
}

@end
