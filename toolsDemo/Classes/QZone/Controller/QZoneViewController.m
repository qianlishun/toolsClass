//
//  QZoneViewController.m
//  toolsDemo
//
//  Created by Mr.Q on 16/7/17.
//  Copyright © 2016年 钱立顺. All rights reserved.
//

#import "QZoneViewController.h"
#import "QScalableNav.h"

@interface QZoneViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

static NSString *const kCellID = @"cell";

@implementation QZoneViewController

- (UITableView *)tableView{

    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.delegate = self;
        tableView.dataSource = self;

        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellID];
        [self.view addSubview:tableView];
        _tableView = tableView;
    }

    return _tableView;
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    self.tableView.frame = ScreenFrame;
//
//    self.tableView.tableHeaderView=[[UITableViewHeaderFooterView alloc]initWithFrame:CGRectMake(0, 0, kSize.width, 200)];

    QScalableNav *navView = [[QScalableNav alloc]initWithFrame:CGRectMake(0, 0, kSize.width, 200) backgroundImage:@"waterfall06" headerImage:@"waterfall06" title:@"冬绒" subTitle:@"我在时光里坐深了梦"];

    navView.scrollView = self.tableView;
    navView.imgActionBlock = ^(){
        NSLog(@"你点了我的头像");
    };
    [self.view addSubview:navView];
    

    UIButton *backBtn = [[UIButton alloc]init];
    backBtn.center = self.view.center;
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    backBtn.backgroundColor =  [UIColor colorWithRed:arc4random_uniform (256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn sizeToFit];
    [self.view addSubview:backBtn];
}

- (void)back:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];

    cell.textLabel.text = [NSString stringWithFormat:@"text%zd",indexPath.row];

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}


@end
