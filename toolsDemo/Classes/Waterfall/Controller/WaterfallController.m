//
//  WaterfallController.m
//  toolsDemo
//
//  Created by Mr.Q on 16/5/11.
//  Copyright © 2016年 钱立顺. All rights reserved.
//

#import "WaterfallController.h"
#import "WaterfallFlowLayout.h"
#import "WaterfallCell.h"

@interface WaterfallController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) WaterfallFlowLayout *layout;


@property (nonatomic,strong) NSArray *images;


@end

#define Count 101
#define imageCount 6

@implementation WaterfallController

static NSString *const ID = @"water_cell";

-(NSArray *)images{

    if (!_images) {

        NSString *str = [NSString string];

        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i = 0; i<imageCount; i++) {

            str = [NSString stringWithFormat:@"waterfall%02d",i+1];

            UIImage *image = [UIImage imageNamed:str];

            [arrayM addObject:image];
        }
        _images =  arrayM;

    }
    return _images;
}


-(UICollectionView *)collectionView{

    if (!_collectionView) {


        self.layout = [[WaterfallFlowLayout alloc]init];

        self.layout.columns  = 3;
        self.layout.dataArray = self.images;
        self.layout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);
        self.layout.minimumInteritemSpacing = 5;
        self.layout.minimumLineSpacing = 3;

        self.collectionView = [[UICollectionView alloc]initWithFrame:ScreenFrame collectionViewLayout:self.layout];

        // 注册
        [self.collectionView registerClass:[WaterfallCell class] forCellWithReuseIdentifier:ID];

        self.collectionView.backgroundColor= [UIColor whiteColor];

        [self.view addSubview:self.collectionView];

//        //去出弹簧效果
//        self.collectionView.bounces = NO;

        //去出水平滚动条
        self.collectionView.showsHorizontalScrollIndicator = NO;

    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];


    [self collectionView];

    // 设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return Count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    WaterfallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];

    UIImage *image = self.images[indexPath.row % imageCount];

    cell.image = image;

    return cell;
}

-(void)viewDidAppear:(BOOL)animated{

//    NSLog(@"%@",super.navigationController.viewControllers);

}

#pragma mark <UICollectionViewDelegate>

@end
