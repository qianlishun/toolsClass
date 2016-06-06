//
//  OneController.m
//  toolsDemo
//
//  Created by Mr.Q on 16/3/29.
//  Copyright © 2016年 QLS. All rights reserved.
//

#import "OneController.h"
#import "DemoCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
@interface OneController ()

@property (nonatomic,copy) NSArray  *contenArray;

@end

@implementation OneController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.contenArray = @[@"ImagePlayController",@"图片无限轮播",@"LockController",@"(九宫格)手势解锁屏幕",@"QStarController",@"小星星",@"WaterfallController",@"瀑布流",@"QWaveController",@"~~~波~~~",@"QNewsController",@"一个新闻界面",@"TwoController",@"test!test!test!test!test!test!test!test!test!test!test!test!test!test!",@"TwoController",@"我是一段测试文字,测试自适应高度调整.就能到加拿大及纳税的结案时间你的好大声安徽大厦的建安大家看你啥动画师大会收到爱神的箭加深对加黑色的爱的氨基酸的那件事你"];

//    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame=CGRectMake(0, 0, 200, 60);
//    button.center=self.view.center;
//    
//    button.backgroundColor=[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
//
//
//    [button setTitle:@"点击跳转" forState:UIControlStateNormal];
//    [self.view addSubview:button];
//
//    [button addTarget:self action:@selector(jumpToThree) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark - tableView date source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _contenArray.count/2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"test";
    DemoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[DemoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.titleLabel.text = self.contenArray[indexPath.row * 2 ];
    cell.contentLabel.text = self.contenArray[indexPath.row * 2 + 1];

    return cell;


}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = self.contenArray[indexPath.row * 2 ];

    UIViewController *vc = [NSClassFromString(str) new];
    vc.navigationItem.title = self.contenArray[indexPath.row * 2 + 1];
    [self.navigationController pushViewController:vc animated:YES];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return  [self cellHeightForIndexPath:indexPath cellContentViewWidth:[UIScreen mainScreen].bounds.size.width];
}

-(void)viewWillAppear:(BOOL)animated{


//    NSLog(@"%@",self.navigationController.viewControllers);
}
//-(void)jumpToThree{
//
//    [self.navigationController pushViewController:[[ImagePlayController alloc]init] animated:YES];
//}


@end
