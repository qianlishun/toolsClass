//
//  KGEditPhotoCell.m
//  KGPhotosLibary
//
//  Created by 北师智慧 on 2020/5/9.
//  Copyright © 2020 Heart likes static water. All rights reserved.
//

#import "KGEditPhotoCell.h"

@interface KGEditPhotoCell()<UIScrollViewDelegate>

/** 底层 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 图片 */
@property (nonatomic, strong) UIImageView *imgView;
/** 是否允许拖拽 */
@property (nonatomic, assign) BOOL allow;

@end

@implementation KGEditPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (BOOL)allow{
    return _allow?_allow:NO;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 15, frame.size.width - 30, frame.size.height - 30)];
        self.scrollView.backgroundColor = [UIColor blackColor];
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.delegate = self;
        self.scrollView.bounces = NO;
        self.scrollView.contentSize = CGSizeMake(frame.size.width - 30, frame.size.height - 30);
        [self addSubview:self.scrollView];
        
        
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - 30, frame.size.height - 30)];
        self.imgView.backgroundColor = [UIColor blackColor];
        self.imgView.contentMode = UIViewContentModeScaleAspectFit;
        self.imgView.userInteractionEnabled = _allow;
        [self.scrollView addSubview:self.imgView];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [self.imgView addGestureRecognizer:pan];
        
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
        [self.imgView addGestureRecognizer:pinch];
    }
    return self;
}

- (void)panAction:(UIPanGestureRecognizer *)seg{
    if (!_allow) {
        return;
    }
}

- (void)pinchAction:(UIPinchGestureRecognizer *)seg{
    if (!_allow) {
        return;
    }
    self.imgView.frame = CGRectMake(0, 0, self.imgView.bounds.size.width*(seg.scale>0.f?1.1:0.9), self.imgView.bounds.size.height*(seg.scale>0.f?1.1:0.9));
    self.scrollView.contentSize = self.imgView.bounds.size;
}

- (void)contentWithDic:(NSDictionary *)dic{
    self.imgView.image = dic[@"img"];
}

- (void)editImg:(BOOL)allow{
    _allow = allow;
    self.imgView.userInteractionEnabled = allow;
}


@end
