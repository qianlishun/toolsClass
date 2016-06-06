//
//  ImagePlayController.m
//  toolsDemo
//
//  Created by Mr.Q on 16/5/9.
//  Copyright © 2016年 钱立顺. All rights reserved.
//

#import "ImagePlayController.h"
#import "QCollectionViewCell.h"
#import "UIView+SDAutoLayout.h"
#define SectionCount 100
#define ImageCount 4

@interface ImagePlayController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,assign) int pageIndex;


@property (nonatomic,weak) UICollectionView *collectionView;

@property (nonatomic,strong) NSTimer *timer;


@end

static NSString *const ID = @"img_cell";

@implementation ImagePlayController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.backgroundColor= [UIColor whiteColor];
    //去出弹簧效果
    self.collectionView.bounces = NO;

    //去出水平滚动条
    self.collectionView.showsHorizontalScrollIndicator = NO;

    //设置自动分页
    self.collectionView.pagingEnabled = YES;


    // 滚动到第二个Cell的位置
    [self collectionViewScrollToSecondCell];

    self.index = 0;

    [self setTimer];

}

#pragma mark - collectionView
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        // 1.初始化layout
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];

        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
        //        NSLog(@"%f",layout.itemSize.width);

        // 2.初始化collctionView
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        [self.view addSubview:collectionView];

        collectionView.delegate = self;
        collectionView.dataSource = self;

        // 注册
        [collectionView registerClass:[QCollectionViewCell class] forCellWithReuseIdentifier:ID];


        _collectionView = collectionView;

    }

    return _collectionView;
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return SectionCount;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return ImageCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger next = indexPath.item - 1;

    next = ((self.index + next) + ImageCount ) % ImageCount;

    //    NSLog(@"%@",@(self.index));

    //获取数据
    NSString *imgName = [NSString stringWithFormat:@"img%02ld",next+1];

    UIImage *img =  [UIImage imageNamed:imgName];

    // 创建cell
    QCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];

    //设置cell
    cell.image = img;

    //返回cell
    return cell;
}

#pragma mark <UICollectionViewDelegate>

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self setTimer];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    // 获取滚动的偏移的x值
    CGFloat offsetX = scrollView.contentOffset.x;

    // 计算偏移 的倍数  这个偏移倍数的可能性为0 -1 , 2 -1
    int offset = offsetX / scrollView.bounds.size.width - 1;

    // 修改 self.index (+1 huo -1)
    self.index = ( self.index + offset + ImageCount ) % ImageCount;

    self.pageIndex = (int)self.index;

    dispatch_async(dispatch_get_main_queue(), ^{
        [self collectionViewScrollToSecondCell];
    });

}

-(void)collectionViewScrollToSecondCell{

    NSIndexPath *idxPath = [NSIndexPath indexPathForItem:1 inSection:SectionCount/2];

    [self.collectionView scrollToItemAtIndexPath:idxPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];

}

#pragma mark - timer
// 封装 一个 创建计时器控件 的方法
-(void)setTimer{
    // 启动一个计时器控件,用来实现自动轮播
    //TimeInterval 触发事件的时间间隔,(即多久变化一张) selector 触发事件, repeats是否重复
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];

    // 把self.timer加入消息循环的模式修改一下
    // 修改self.timer的优先级与控件一样
    // 获取当前的消息循环对象
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    // 改变self.timer对象的优先级
    [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];


}
// 封装一个停止计时器的方法
-(void)stopTimer{
    // 调用invalidate 一旦停止计时器,那么这个计时器就不可再重用了
    [self.timer invalidate];
    self.timer = nil;

}
-(void)autoScroll{

    // 1.马上显示回最中间那组的数据
    NSIndexPath *currentIndexPathReset = [[self.collectionView indexPathsForVisibleItems]lastObject];

    // 2.计算出下一个需要展示的位置
    NSInteger nextItem = currentIndexPathReset.item + 1;
    NSInteger nextSection = currentIndexPathReset.section;
    if (nextItem == ImageCount) {
        nextItem = 0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];

    // 3.通过动画滚动到下一个位置
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];

    // 页码
    self.pageIndex = 1;
    self.pageIndex = (int)(self.pageIndex+ (self.collectionView.contentOffset.x/kWIDTH -1) + ImageCount ) % ImageCount;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.navigationItem.title = [NSString stringWithFormat:@"%d / %d",self.pageIndex+1,ImageCount];
    
}

@end
