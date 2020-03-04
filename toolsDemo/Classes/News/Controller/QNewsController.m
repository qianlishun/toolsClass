//
//  QNews.m
//  toolsDemo
//
//  Created by Mr.Q on 16/6/4.
//  Copyright © 2016年 钱立顺. All rights reserved.
//
#import "QNewsController.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "NewsModel.h"
#import "NewsBaseCell.h"
#import "NewsOneCell.h"
#import "NewsTwoCell.h"
#import "NewsThreeCell.h"
#import "NewsFourCell.h"
#import "NewsWebController.h"
#import "QNetWorkTools.h"
#import "UIView+QLSFrame.h"

@interface QNewsController () <SDCycleScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray *listArray;

@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,strong) MJRefreshComponent *refreshView;

@property (nonatomic,strong) SDCycleScrollView *cycleScorllView;

@property (nonatomic,copy) NSString  *url;

@property (nonatomic,strong) UIButton *btn;

@property (nonatomic,strong) NSMutableDictionary *cacheDict;

@end

@implementation QNewsController


- (UIButton *)btn{

    if (!_btn) {

        UIButton *btn = [[UIButton alloc]init];

        [btn setTitle:@"加载失败,请刷新或检查网络连接 ☞" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn addTarget:self action:@selector(checkNetwork) forControlEvents:UIControlEventTouchUpInside];

        _btn = btn;
    }
    return _btn;
}

- (void)viewDidLoad{

    [super viewDidLoad];

    unsigned int outCount = 0, i = 0;
    objc_property_t* properties = class_copyPropertyList([Ads class], &outCount);
    for (i=0; i<outCount; i++) {
        objc_property_t property = properties[i];
        NSString* propertyType = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
        NSLog(@"%@====",propertyType);
    }
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.automaticallyAdjustsScrollViewInsets = YES;

    self.tableView.separatorColor = [UIColor clearColor];

    __weak typeof (self)weakSelf = self;

    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.refreshView = weakSelf.tableView.header;
        weakSelf.pageIndex = 0;

        [weakSelf loadDataFromServer];
    }];

    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.refreshView = weakSelf.tableView.footer;

        [weakSelf loadMoreData];

    }];

    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));

}

-(NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array];

    }
    return  _listArray;
}


#pragma mark - 请求数据

- (void)setUrlString:(NSString *)urlString{

    QNetWorkTools *tools = [QNetWorkTools sharedNetworkTools];
    for (NSURLSessionDataTask *task in tools.dataTasks) {
        [task cancel];
    }

    [self.listArray removeAllObjects];

    self.url = urlString;

    self.pageIndex = 0;

    [self.tableView reloadData];

    self.tableView.footer.hidden = YES;

    [self.tableView.header beginRefreshing];

    [self loadDataFromServer];
}

- (void)loadMoreData{

    self.pageIndex+=10;

    [self loadDataFromServer];
}

- (void)extracted {
    [NewsModel newsWithURLString:[NSString stringWithFormat:@"%@/%ld-10.html",self.url,(long)self.pageIndex]  success:^(NSArray *array) {
        
        if (self.pageIndex == 0) {
            
            [self.listArray removeAllObjects];
            
            self.listArray = [NSMutableArray arrayWithArray:array];
            
            // 网易新闻更新后,抓包抓到的数据变了 此代码不需要再加了...
            // // 拿出头条中的非轮播数据
            // NewsModel *model =  array[0];
            // NewsModel *tempModel = [NewsModel new];
            // tempModel.title = model.title;
            // tempModel.imgsrc = model.imgsrc;
            // tempModel.digest = model.digest;
            // tempModel.imgsrc = model.imgsrc;
            // tempModel.imgextra = model.imgextra;
            // tempModel.skipID = model.skipID;
            
            // [self.listArray insertObject:tempModel atIndex:1];
            
        }else{
            
            for (id obj in array) {
                [self.listArray addObject:obj];
            }
            // 去除头条重复数据
            NewsModel *model = array[0];
            model.ads = nil;
        }
        
        
        self.btn.hidden = YES;
        
        self.tableView.footer.hidden = self.listArray.count==0?YES:NO;
        
        if (self.listArray.count) {
            [self doneWithView:self.refreshView];
        }else{
            [self performSelector:@selector(checkData) withObject:nil afterDelay:10.0];
        }
        
    } errorBlock:^(NSError *error) {
        NSLog(@"请求失败,%@",error);
        [self.refreshView endRefreshing];
        [self performSelector:@selector(checkData) withObject:nil afterDelay:15.0];
    }];
}

- (void)loadDataFromServer{

    //    NSString *urlString = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/%ld-20.html",@"headline/T1348647853363",self.pageIndex];
    //    NSString *urlString = [NSString stringWithFormat:@"http://c.3g.163.com/nc/article/%@/%ld-20.html",@"list/T1414389941036",self.pageIndex];

    //    NSString *urlString = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/B6UKRIOE00963VRO/full.html"];

    [self extracted];

}

//#pragma mark - 回调刷新
- (void)doneWithView:(MJRefreshComponent *)refreshView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    [self.refreshView endRefreshing];
}

- (void)checkData{
    if (!self.listArray.count) {
        [self timeOut];
    }
}

- (void)timeOut{

    [self.refreshView endRefreshing];

    [self.tableView addSubview:_btn];
    _btn.frame = self.refreshView.bounds;

    _btn.hidden = NO;

}

- (void)checkNetwork{
    //prefs:root=General&path=Network

    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

}


#pragma mark - tableview delegate   datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    NewsModel *newsModel = self.listArray[indexPath.row];

    NSString *ID = [NewsBaseCell cellIDforRow:newsModel];

    Class class = NSClassFromString(ID);

    NewsBaseCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];

    if (!cell) {
        cell = [[class alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
