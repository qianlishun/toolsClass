//
//  QNewsHomeController.m
//  toolsDemo
//
//  Created by Mr.Q on 16/6/10.
//  Copyright © 2016年 钱立顺. All rights reserved.
//

#import "QNewsHomeController.h"
#import "Channel.h"
#import "ChannelLabel.h"
#import "NewsHomeCell.h"

@interface QNewsHomeController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *channels;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UICollectionViewFlowLayout *collectionLayout;

@property (nonatomic,assign) NSInteger currentIndex;

@end

@implementation QNewsHomeController


- (NSArray *)channels{

    if (!_channels) {
        _channels = [Channel channels];
    }
    return _channels;
}


static NSString *const ID = @"home_cell";

- (void)viewDidLoad{

    [super viewDidLoad];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionLayout = layout;

      // 2.初始化collctionView
    UICollectionView *collectionView =  [[UICollectionView alloc]initWithFrame:CGRectMake(0, 104, kWIDTH, kSize.height - 104) collectionViewLayout:layout];

    collectionView.backgroundColor = [UIColor whiteColor];
    // 注册
    [collectionView registerClass:[NewsHomeCell class] forCellWithReuseIdentifier:ID];

    self.collectionView = collectionView;

    [self.view addSubview:self.collectionView];


    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kWIDTH, 44)];

    self.scrollView.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.scrollView];


    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;

    [self loadChannels];
}

- (void)loadChannels{

    self.automaticallyAdjustsScrollViewInsets = NO;
    CGFloat marginX = 5;
    CGFloat x = marginX;
    CGFloat h = self.scrollView.bounds.size.height;

    for (Channel *channel in self.channels) {
        ChannelLabel *lbl = [ChannelLabel channelLabelWithTName:channel.tname];
        [self.scrollView addSubview:lbl];

        lbl.frame = CGRectMake(x, 0, lbl.bounds.size.width, h);

        x += lbl.bounds.size.width + marginX;
    }


    self.scrollView.contentSize = CGSizeMake(x, 0);
    self.scrollView.showsHorizontalScrollIndicator = NO;

    ChannelLabel *firstLabel = self.scrollView.subviews[0];
    firstLabel.scale = 1;
}

#pragma mark dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.channels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];

    Channel *channel = self.channels[indexPath.item];
    cell.urlString = channel.urlString;

    return cell;
}

#pragma mark     delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{


    ChannelLabel *curentLabel = self.scrollView.subviews[self.currentIndex];
    ChannelLabel *nextLabel = nil;

    for (NSIndexPath *indexPath in self.collectionView.indexPathsForVisibleItems) {
        if (indexPath.item != self.currentIndex) {
            nextLabel = self.scrollView.subviews[indexPath.item];
            break;
        }
    }
    if (nextLabel == nil) {
        return;
    }

    CGFloat nextScale = ABS(scrollView.contentOffset.x / scrollView.bounds.size.width - self.currentIndex);
    CGFloat  currentScale = 1 - nextScale;

    for (id obj in self.scrollView.subviews) {
        if ([[obj class] isSubclassOfClass:[UIButton class]]) {
            ChannelLabel *lbl = (ChannelLabel *)obj;
            lbl.scale = 0;
        }
    }
    
    nextLabel.scale = nextScale;
    curentLabel.scale = currentScale;

    self.currentIndex = scrollView.contentOffset.x / scrollView.bounds.size.width;

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    self.currentIndex = scrollView.contentOffset.x / scrollView.bounds.size.width;

    ChannelLabel *label = self.scrollView.subviews[self.currentIndex];
    CGFloat offset = label.center.x - self.scrollView.bounds.size.width * 0.5;
    CGFloat maxOffset = self.scrollView.contentSize.width - label.bounds.size.width - self.scrollView.bounds.size.width;

    if (offset < 0) {
        offset = 0;
    }else if(offset > maxOffset){
        offset = maxOffset + label.bounds.size.width;
    }

    [self.scrollView setContentOffset:CGPointMake(offset, 0)animated:YES];
}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

    self.collectionLayout.itemSize = self.collectionView.bounds.size;

}


@end
