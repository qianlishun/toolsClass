//
//  QStarController.m
//  toolsDemo
//
//  Created by Mr.Q on 16/5/9.
//  Copyright © 2016年 钱立顺. All rights reserved.
//

#import "QStarController.h"

@interface QStarController ()

@property (nonatomic,strong) NSArray *images;


@end

@implementation QStarController

-(NSArray *)images{
    if (!_images) {
        _images = @[[UIImage imageNamed:@"spark_blue"],[UIImage imageNamed:@"spark_green"],[UIImage imageNamed:@"spark_cyan"],[UIImage imageNamed:@"spark_magenta"],[UIImage imageNamed:@"spark_yellow"],[UIImage imageNamed:@"spark_red"]];
    }
    return _images;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    // 背景设为黑色
    self.view.backgroundColor = [UIColor blackColor];

    self.navigationItem.title = @"小星星";
    // 打开多点触控
    self.view.multipleTouchEnabled = YES;

}

// 手指按下时调用,点一下就出一个小星星
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self addSpark:touches];
}

// 手指移动
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self addSpark:touches];
}
-(void)addSpark:(NSSet *)touches{
    // 遍历集合中的触摸点
    for (UITouch *touch in touches) {
        //取出触摸点的位置
        CGPoint location = [touch locationInView:self.view];

        UIImageView *imgView = [[UIImageView alloc]initWithImage:self.images[arc4random() % 6]];

        imgView.center = location;

        [self.view addSubview:imgView];

        // 用动画 延迟一段时间后将图片删除
        [UIView animateWithDuration:3.0 animations:^{
            imgView.alpha = 0.0;
        }completion:^(BOOL finished) {
            [imgView removeFromSuperview];
        }];
        
    }
}
// 手指抬起
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%s",__func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
