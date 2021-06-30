//
//  OneController.m
//  toolsDemo
//
//  Created by Mr.Q on 15/9/17.
//  Copyright © 2015年 QLS. All rights reserved.
//

#import "OneController.h"
#import "DemoCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "QLSNavigationController.h"
#import <CoreLocation/CoreLocation.h>

@interface OneController (){
    CLLocationManager *localtionmgr;
}

@property (nonatomic,copy) NSArray  *contenArray;


@end

@implementation OneController


- (void)viewDidLoad {
    [super viewDidLoad];

//    self.title = @"Demo";
    self.view.backgroundColor = [UIColor whiteColor];

    self.contenArray = @[
                         @"QEatController",@"去哪吃",
                         @"SetQRCodeController",@"生成二维码",
                         @"ScanController",@"扫描二维码",
                         @"QMeasureController",@"Measure",
                         @"QFindLineStoryboard",@"血管处理测试",
                         @"QTestStoryboard",@"Test",
                         @"QNewsHomeController",@"一个新闻界面",
                         @"ImagePlayController",@"图片无限轮播",
                         @"QImageBookController",@"覆盖式切换图片",
                         @"LockController",@"(九宫格)手势解锁屏幕",
                         @"QStarController",@"小星星",
                         @"WaterfallController",@"瀑布流",
                         @"QWaveController",@"~~~波~~~",
                         @"QZoneViewController",@"仿QQ头部下拉图片",
                         @"QColorsViewController",@"渐变色",
                         @"QFangzuViewController",@"房",
                         @"QMenuViewController",@"List",
                         @"TestVC",@"test",
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
    UIViewController *vc;
    if([str containsString:@"Storyboard"]){
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:str bundle:[NSBundle mainBundle]];
        NSString *classStr = [str stringByReplacingOccurrencesOfString:@"Storyboard" withString:@"ViewController"];
        vc = [storyBoard instantiateViewControllerWithIdentifier:classStr];
    }else{
        vc = [NSClassFromString(str) new];
    }
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
