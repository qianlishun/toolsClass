//
//  QNews.m
//  toolsDemo
//
//  Created by Mr.Q on 16/6/4.
//  Copyright © 2016年 钱立顺. All rights reserved.
//
#import "QLSNavigationController.h"
#import "QNewsController.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "XYString.h"
#import "UITableView+SDAutoTableViewCellHeight.h"

#import "NewsBaseCell.h"
#import "NewsOneCell.h"
#import "NewsTwoCell.h"
#import "NewsThreeCell.h"
#import "NewsFourCell.h"

#import "NewsWebController.h"

@interface QNewsController () <UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *listArray;

@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,strong) MJRefreshComponent *refreshView;

@property (nonatomic,strong) SDCycleScrollView *cycleScorllView;

@end

@implementation QNewsController

- (void)viewDidLoad{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.automaticallyAdjustsScrollViewInsets = YES;

    [self.view addSubview:self.tableView];

    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));

}

-(NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc]init];

    }
    return  _listArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;


        __weak typeof (self)weakSelf = self;

        _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.refreshView = weakSelf.tableView.header;
            weakSelf.pageIndex = 0;

            [weakSelf loadData];
        }];

        [self.tableView.header beginRefreshing];

        self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weakSelf.refreshView = weakSelf.tableView.footer;
            weakSelf.pageIndex = weakSelf.pageIndex + 5;
            [weakSelf loadData];
        }];

        self.tableView.footer.hidden = YES;
    }
    return _tableView;
}

#pragma mark - 请求数据 
- (void)loadData{

    NSString *urlString = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/%ld-20.html",@"headline/T1348647853363",self.pageIndex];
//    NSString *urlString = [NSString stringWithFormat:@"http://c.3g.163.com/nc/article/%@/%ld-20.html",@"list/T1414389941036",self.pageIndex];
    NSLog(@"%@",urlString);

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [XYString getObjectFromJsonString:operation.responseString];
        // keyEnumerator 获取所有键  objectEnumerator得到对象  keyEnumerator得到键值

        NSString *key = [dict.keyEnumerator nextObject];
        NSArray *tempArray = dict[key];

        NSMutableArray *arrayM = [NSMutableArray arrayWithArray:[NewsModel mj_objectArrayWithKeyValuesArray:tempArray]];

        if (self.refreshView == self.tableView.header) {
            self.listArray = arrayM;
            self.tableView.footer.hidden = self.listArray.count == 0 ? YES:NO;

        }else if (self.refreshView == self.tableView.footer){
            [self.listArray addObjectsFromArray:arrayM];
        }

//        NSLog(@"%@",_listArray);
        [self doneWithView:self.refreshView];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败,%@",error);

        [self.refreshView endRefreshing];
    }];

}

#pragma mark - 回调刷新

- (void)doneWithView:(MJRefreshComponent *)refreshView{
    [self.tableView reloadData];

    [self.refreshView endRefreshing];
}

#pragma mark - tableview delegate   datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NewsBaseCell * cell = nil;

    NewsModel *newsModel = self.listArray[indexPath.row];

    NSString *ID = [NewsBaseCell cellIDforRow:newsModel];

    Class class = NSClassFromString(ID);

    cell = [tableView dequeueReusableCellWithIdentifier:ID];

    if (!cell) {
        cell = [[class alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }

    if ([ID isEqualToString:@"NewsFourCell"]) {
        cell.fatherVC = self;
    }

    cell.newsModel = newsModel;

    // 缓存 cell 的 frame
    cell.sd_tableView = tableView;
    cell.sd_indexPath = indexPath;

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsModel *newsModel = self.listArray[indexPath.row];

    NSString *ID = [NewsBaseCell cellIDforRow:newsModel];

    Class class = NSClassFromString(ID);

    return [self.tableView cellHeightForIndexPath:indexPath model:newsModel keyPath:@"newsModel" cellClass:class contentViewWidth:[self cellContentViewWidth]];
}

- (CGFloat)cellContentViewWidth{

    CGFloat width = kSize.width;

    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = kSize.height;
    }
    return width;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NewsModel *model = self.listArray[indexPath.row];
    // 创建一个用于跳转的控制器
    NewsWebController *vc = [[NewsWebController alloc]init];

    // 把数据传递给这个控制器
    vc.url= model.url;

    vc.title= model.title;

    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
