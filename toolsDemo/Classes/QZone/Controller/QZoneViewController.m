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
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];

    cell.textLabel.text = [NSString stringWithFormat:@"text%zd",indexPath.row];

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

@end