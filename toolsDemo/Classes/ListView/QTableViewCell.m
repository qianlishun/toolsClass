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

@property (nonatomic,strong) NSArray<UIView*>* theViews;

@property (nonatomic,strong) UIView *theView;
//@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation QTableViewCell

static CGFloat kCellHeight = 44;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        for (UIView*v in self.subviews) {
            if(v==self.contentView)
                continue;
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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    
    for (UIView* v in self.theViews) {
        [v removeFromSuperview];
    }
    self.theViews = nil;
}

- (void)setViews:(NSArray*)views size:(CGSize)size{
    BOOL isNew = NO;
    if(!_theViews || _theViews.count == 0 ){
        _theViews = views;
    }else if(views && views.count>0){
        for (UIView *v in views) {
            if(![_theViews containsObject:v]){
                isNew = YES;
                break;
            }
        }
    }
    if(isNew){
        for (UIView *v in _theViews) {
            [v removeFromSuperview];
        }
        _theViews = views;
    }
    
     
    if(views.count>1){
        CGFloat x = 10;
        CGFloat H = size.height;
        for(int i = 0; i < views.count; i++){
            UIView *v = views[i];
            if(v.height>H){
                H = v.height;
            }else{
                [v setHeight:H];
            }
            [self setHeight:H];
            
            [v sizeToFit];
            if(v.height>H)
                v.height = H;
            
            if([v isKindOfClass:[UILabel class]]){
//                [v sizeToFit];
//                v.height = H;
            }else if([v isKindOfClass:[UITextField class]]){
                if(i==0)
                    [(UITextField*)v setTextAlignment:NSTextAlignmentLeft];
                else if(i==views.count-1)
                    [(UITextField*)v setTextAlignment:NSTextAlignmentRight];
            }
            
            v.x = x;
            
            x = v.right;
            
            if(i == views.count-1)
                v.width = size.width - 10 - v.x;
            
//            v.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
            
            [self.contentView addSubview:v];

        }
        
        if(views.count>2){
            [views mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
            [views mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo();
                make.centerY.equalTo(self.contentView);
            }];
        }
    }else if(views.count==1){
        UIView *v = views[0];

        [self.contentView addSubview:v];
        
        [self setHeight:v.height];
        
        [v mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.height.mas_equalTo(v.height);
            make.width.mas_equalTo(v.width);
        }];
    }
}

- (void)setHeight:(CGFloat)height{
    if(height<kCellHeight)
        height = kCellHeight;
    
    [self.contentView setHeight:height];
    [super setHeight:height];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.selectedBackgroundView setFrame:self.bounds];
}

@end
