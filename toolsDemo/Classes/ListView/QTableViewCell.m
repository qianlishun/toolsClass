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

- (void)setViews:(NSArray*)views{
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
        CGFloat H = self.height;
        for(int i = 0; i < views.count; i++){
            UIView *v = views[i];
            if(v.height>H){
                H = v.height;
                [self setHeight:H];

            }else{
                [v setHeight:H];
            }
            if([v isKindOfClass:[UILabel class]]){
                [v sizeToFit];
                v.height = H;
            }else if([v isKindOfClass:[UITextField class]]){
                if(i==0)
                    [(UITextField*)v setTextAlignment:NSTextAlignmentLeft];
                else if(i==views.count-1)
                    [(UITextField*)v setTextAlignment:NSTextAlignmentRight];
            }
            
            v.x = x;
            
            x = v.right;
            
            if(i == views.count-1)
                v.width = self.width - 10 - v.x;
            
            v.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
            
            [self.contentView addSubview:v];

        }
        
        if(![views.lastObject isKindOfClass:[UITextField class]]){
              [views mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:10 tailSpacing:10];
              [views mas_makeConstraints:^(MASConstraintMaker *make) {
                  make.height.mas_equalTo(H);
                  make.centerY.equalTo(self.contentView);
              }];
        }
    }else if(views.count==1){
        UIView *v = views[0];

        [self.contentView addSubview:v];
        
        [self setHeight:v.height+10];
        
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


/*
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
*/

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.selectedBackgroundView setFrame:self.bounds];
    
//    if( _stackView && self.stackView.width != self.width){
//        self.stackView.x = 10;
//        self.stackView.width = self.width-20;
//    }
    
//    if(self.theViews.count==1){
//        UIView *v = self.theViews[0];
//        [v setCenterX:self.width/2];
//        [v setCenterY:self.height/2];
//    }
    /*
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
     */
}

@end
