//
//  QScalableNav.m
//  toolsDemo
//
//  Created by Mr.Q on 16/7/19.
//  Copyright © 2016年 钱立顺. All rights reserved.
//

#import "QScalableNav.h"

@interface QScalableNav ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@end

@implementation QScalableNav


- (id)initWithFrame:(CGRect)frame backgroundImage:(NSString *)backgroudImage headerImage:(NSString *)headerImage title:(NSString *)title subTitle:(NSString *)subTitle
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        _backgroundImageView = [[UIImageView alloc] initWithFrame:frame];
        _backgroundImageView.image = [UIImage imageNamed:backgroudImage];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;

        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width*0.5-70*0.5, 0.27*frame.size.height+navHeight, 70, 70)];
        _headerImageView.image = [UIImage imageNamed:headerImage];
        [_headerImageView.layer setMasksToBounds:YES];
        _headerImageView.layer.cornerRadius = _headerImageView.frame.size.width/2.0f;
        _headerImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_headerImageView addGestureRecognizer:tap];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.6*frame.size.height, frame.size.width, frame.size.height*0.2)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.text = title;

        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.75*frame.size.height, frame.size.width, frame.size.height*0.1)];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.font = [UIFont systemFontOfSize:12];
        _subTitleLabel.text = subTitle;
        _titleLabel.textColor = [UIColor whiteColor];
        _subTitleLabel.textColor = [UIColor whiteColor];


        [self addSubview:_backgroundImageView];
        [self addSubview:_headerImageView];
        [self addSubview:_titleLabel];
        [self addSubview:_subTitleLabel];
        self.clipsToBounds = YES;
//
//        UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
//        backBtn.titleLabel.text = @"返回";
//        backBtn.tintColor = [UIColor blackColor];
//        [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
//
    }
    return self;
}


- (void)removeObserver
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew) context:Nil];
    self.scrollView.contentInset = UIEdgeInsetsMake(self.frame.size.height, 0 ,0 , 0);
    self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGPoint newOffset = [change[@"new"] CGPointValue];
    [self updateSubViewsWithScrollOffset:newOffset];
}

-(void)updateSubViewsWithScrollOffset:(CGPoint)newOffset
{

   if (self.scrollView.contentOffset.y < -220) {

    CGFloat offset = -self.scrollView.contentOffset.y-220;

        self.frame = CGRectMake(0, -offset+navHeight,self.scrollView.bounds.size.width + offset * 2, MaxHeight + offset*2);
        self.backgroundImageView.frame = CGRectMake(-offset, offset+navHeight, kSize.width + offset*2, MaxHeight + offset*2);
        self.headerImageView.center = self.backgroundImageView.center;
        self.titleLabel.alpha = self.subTitleLabel.alpha = 1 - offset/10;
    }
    else{

        self.frame = CGRectMake(0, navHeight, self.scrollView.bounds.size.width, MaxHeight);

        CGFloat destinaOffset = -64;
        CGFloat startChangeOffset = -self.scrollView.contentInset.top;
        newOffset = CGPointMake(newOffset.x, newOffset.y<startChangeOffset?startChangeOffset:(newOffset.y>destinaOffset?destinaOffset:newOffset.y));

        CGFloat subviewOffset = self.frame.size.height-40; // 子视图的偏移量

        CGFloat newY = -newOffset.y-self.scrollView.contentInset.top;
        CGFloat d = destinaOffset-startChangeOffset;
        CGFloat alpha = 1-(newOffset.y-startChangeOffset)/d;
        CGFloat imageReduce = 1-(newOffset.y-startChangeOffset)/(d*2);

        self.subTitleLabel.alpha = alpha;
        self.titleLabel.alpha = alpha;
        self.frame = CGRectMake(0, newY+navHeight, self.frame.size.width, self.frame.size.height);
        self.backgroundImageView.frame = CGRectMake(0, (1.5*self.frame.size.height)*(1-alpha)+navHeight, self.backgroundImageView.frame.size.width, self.backgroundImageView.frame.size.height);

        CGAffineTransform t = CGAffineTransformMakeTranslation(0,navHeight+(subviewOffset-0.35*self.frame.size.height)*(1-alpha));

        _headerImageView.transform = CGAffineTransformScale(t,
                                                            imageReduce, imageReduce);

        self.titleLabel.frame = CGRectMake(0, 0.6*self.frame.size.height+(subviewOffset-0.45*self.frame.size.height)*(1-alpha), self.frame.size.width, self.frame.size.height*0.2);
        self.subTitleLabel.frame = CGRectMake(0, 0.75*self.frame.size.height+(subviewOffset-0.45*self.frame.size.height)*(1-alpha), self.frame.size.width, self.frame.size.height*0.1);
    }
}

- (void)tapAction:(id)sender
{
    if (self.imgActionBlock) {
        self.imgActionBlock();
    }
}

@end
