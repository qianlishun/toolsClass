//
//  WaterfallController1.m
//  toolsDemo
//
//  Created by Mr.Q on 16/5/12.
//  Copyright © 2016年 钱立顺. All rights reserved.
//

#import "WaterfallController1.h"
#import "FRGWaterfallCollectionViewCell.h"
#import "FRGWaterfallCollectionViewLayout.h"
#import "FRGWaterfallHeaderReusableView.h"

static NSString* const WaterfallCellIdentifier = @"WaterfallCell";
static NSString* const WaterfallHeaderIdentifier = @"WaterfallHeader";

@interface WaterfallController1 () <FRGWaterfallCollectionViewDelegate, UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *cellHeights;

@property (nonatomic,strong) NSArray *images;

@property (nonatomic,strong) UICollectionView *cv;


@end


static NSString *const ID = @"water_cell";

@implementation WaterfallController1

-(NSArray *)images{
    if (!_images) {

        NSString *str = [NSString string];
        NSMutableArray *arrayM = [NSMutableArray array];

        for (int i = 0; i<6; i++) {
            str = [NSString stringWithFormat:@"waterfall%02d",i+1];

            UIImage *img = [UIImage imageNamed:str];

            [arrayM addObject:img];
        }
        _images = arrayM;
    }
    return _images;
}

-(UICollectionView *)cv{

    if (!_cv) {

        FRGWaterfallCollectionViewLayout *Layout = [[FRGWaterfallCollectionViewLayout alloc] init];
        Layout.delegate = self;
        Layout.itemWidth = 120.0f;
        Layout.topInset = 10.0f;
        Layout.bottomInset = 10.0f;
        Layout.stickyHeader = YES;

        self.cv = [[UICollectionView alloc]initWithFrame:ScreenFrame collectionViewLayout:Layout];

        self.cv.backgroundColor = [UIColor whiteColor];
        //注册
        [self.cv registerClass:[FRGWaterfallCollectionViewCell class] forCellWithReuseIdentifier:ID];
        [self.cv registerClass:[FRGWaterfallHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        [self.view addSubview:self.cv];
        [self.cv reloadData];

    }
    return _cv;

}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    [self cv];

    self.cv.delegate = self;
    self.cv.dataSource = self;

}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [[self.cv collectionViewLayout] invalidateLayout];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 30;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    FRGWaterfallCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];

    cell.lblTitle.text = [NSString stringWithFormat: @"Item %ld", indexPath.item];
    UIImage *image = self.images[indexPath.item % 6];
    NSLog(@"%@",image);
    cell.image = image;

    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(FRGWaterfallCollectionViewLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellHeights[indexPath.section + 1 * indexPath.item] floatValue];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(FRGWaterfallCollectionViewLayout *)collectionViewLayout
heightForHeaderAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section + 1) * 26.0f;
}

- (NSMutableArray *)cellHeights {
    if (!_cellHeights) {
        _cellHeights = [NSMutableArray arrayWithCapacity:900];
        for (NSInteger i = 0; i < 900; i++) {
            _cellHeights[i] = @(arc4random()%100*2+100);
        }
    }
    return _cellHeights;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath; {
    FRGWaterfallHeaderReusableView *titleView =
    [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                       withReuseIdentifier:@"header"
                                              forIndexPath:indexPath];
    titleView.lblTitle.text = [NSString stringWithFormat: @"Section %ld", indexPath.section];
    return titleView;
}

@end
