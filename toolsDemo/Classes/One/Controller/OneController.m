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
#import "QLSNavigationController.h"
@interface OneController ()

@property (nonatomic,copy) NSArray  *contenArray;


@end

@implementation OneController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Demo";
    self.view.backgroundColor = [UIColor whiteColor];

    self.contenArray = @[@"ImagePlayController",@"图片无限轮播",
                         @"LockController",@"(九宫格)手势解锁屏幕",
                         @"QStarController",@"小星星",
                         @"WaterfallController",@"瀑布流",
                         @"QWaveController",@"~~~波~~~",
                         @"QNewsHomeController",@"一个新闻界面",
                         @"SetQRCodeController",@"生成二维码",
                         @"ScanController",@"扫描二维码",
                         ];

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
