//
//  QImageBookController.m
//  toolsDemo
//
//  Created by mrq on 2018/4/12.
//  Copyright © 2018年 钱立顺. All rights reserved.
//
#define ImageCount 4
#define AnimationOffset 50
#define TAG 233

#import "QImageBookController.h"
#import "QAnimationView.h"
#import "UIView+QLSFrame.h"

@interface QImageBookController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation QImageBookController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scrollView];
    
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width*ImageCount, self.scrollView.height);
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    for (int i =0; i<ImageCount; i++) {
        QAnimationView *view = [[QAnimationView alloc]initWithFrame:CGRectMake(i*self.scrollView.width, 0, self.scrollView.width, self.scrollView.height)];
        view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        
        NSString *imgName = [NSString stringWithFormat:@"img%02d",i+1];
        UIImage *img =  [UIImage imageNamed:imgName];
        
        [view.imageView setImage:img];
        
        [self.scrollView addSubview:view];
        
        view.tag = i+TAG;
    }
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat x = scrollView.contentOffset.x;
    
    NSInteger leftIndex = x/scrollView.width;
    
    QAnimationView *leftView = [scrollView viewWithTag:leftIndex+TAG];
    
    QAnimationView *rightView = [scrollView viewWithTag:leftIndex+TAG+1];
    
    leftView.contentX = (scrollView.width-AnimationOffset) + (x - ((leftIndex+1)*scrollView.width))/scrollView.width*(scrollView.width-AnimationOffset);
    
    rightView.contentX = -(scrollView.width-AnimationOffset) + (x-(leftIndex*scrollView.width))/scrollView.width*(scrollView.width-AnimationOffset);

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
