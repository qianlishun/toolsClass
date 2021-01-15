//
//  KGEditPhotoVC.m
//  KGPhotosLibary
//
//  Created by 北师智慧 on 2020/5/9.
//  Copyright © 2020 Heart likes static water. All rights reserved.
//

#import "KGEditPhotoVC.h"
#import "KGEditPhotoCell.h"
#import "KGEditBottomView.h"
#import "KGChangeImgSizeView.h"

#define KGScreen_width [UIScreen mainScreen].bounds.size.width
#define KGScreen_height [UIScreen mainScreen].bounds.size.height
#define KGNavHeight ([UIApplication sharedApplication].statusBarFrame.size.height+49.f)
#define KGAppInfoDic [[NSBundle mainBundle] infoDictionary]
#define KGBundle(name,type) [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"KGLibary" ofType:@"bundle"]] pathForResource:name ofType:type]

@interface KGEditPhotoVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

/** 相册列表 */
@property (nonatomic, strong) UICollectionView *listView;
/** 约束 */
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
/** 导航栏 */
@property (nonatomic, strong) UIView *navView;
/** 确定按钮 */
@property (nonatomic, strong) UIButton *shureBtu;
/** 底部编辑view */
@property (nonatomic, strong) KGEditBottomView *bottomView;
/** 选择裁剪模式 */
@property (nonatomic, strong) KGChangeImgSizeView *sizeView;
/** 当前图片下标 */
@property (nonatomic, assign) NSInteger currIndex;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataArr;
/** 是否允许缩放滑动 */
@property (nonatomic, assign) BOOL allowEdit;

@end

@implementation KGEditPhotoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = [NSMutableArray array];
    if (self.editArr.count > 0) {
        for (NSDictionary *dic in self.editArr) {
            NSMutableArray *arr = [NSMutableArray arrayWithObjects:@{},dic, nil];
            [self.dataArr addObject:arr];
        }
    }
    
    [self createNav];
    
    [self setUI];
}

- (NSInteger)currIndex{
    return _currIndex?_currIndex:0;
}

- (BOOL)allowEdit{
    return _allowEdit?_allowEdit:NO;
}

/// 创建导航栏
- (void)createNav{
    
    _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KGScreen_width, KGNavHeight)];
    _navView.backgroundColor = [UIColor colorWithRed:55/255.0 green:182/255.0 blue:255/255.0 alpha:1];
    [self.view addSubview:_navView];
    
    UIButton *cancelBtu = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtu.frame = CGRectMake(15, KGNavHeight - 38, 100, 30);
    [cancelBtu setImage:[UIImage imageWithContentsOfFile:KGBundle(@"back", @"png")] forState:UIControlStateNormal];
    [cancelBtu addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    cancelBtu.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    cancelBtu.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cancelBtu.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_navView addSubview:cancelBtu];
    
    self.shureBtu = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shureBtu.frame = CGRectMake(KGScreen_width - 115, KGNavHeight - 38, 100, 30);
    [self.shureBtu setTitle:@"确定" forState:UIControlStateNormal];
    [self.shureBtu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.shureBtu.titleLabel.font = [UIFont systemFontOfSize:13.0];
    self.shureBtu.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.shureBtu addTarget:self action:@selector(shureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:self.shureBtu];
}

/// 导航栏返回按钮点击事件
- (void)cancelAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/// 导航栏确定按钮点击事件
- (void)shureAction{
    
}

/// 创建列表
- (void)setUI{
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout.minimumLineSpacing = 0;
    self.layout.minimumInteritemSpacing = 0;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.itemSize = CGSizeMake(KGScreen_width, KGScreen_height - KGNavHeight - (KGScreen_height > 800 ? 34.f:0.f) - 80);
    
    self.listView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, KGNavHeight, KGScreen_width, KGScreen_height - KGNavHeight - 80 - (KGScreen_height > 800 ? 34.f:0.f)) collectionViewLayout:self.layout];
    self.listView.showsVerticalScrollIndicator = NO;
    self.listView.showsHorizontalScrollIndicator = NO;
    self.listView.bounces = NO;
    self.listView.delegate = self;
    self.listView.dataSource = self;
    self.listView.pagingEnabled = YES;
    self.listView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.listView];
    
    [self.listView registerClass:[KGEditPhotoCell class] forCellWithReuseIdentifier:@"KGEditPhotoCell"];
    
    /** 创建底部按钮 */
    self.bottomView = [[KGEditBottomView alloc] initWithFrame:CGRectMake(0, KGScreen_height - 80 - (KGScreen_height > 800 ? 34.f:0.f), KGScreen_width, 80 + (KGScreen_height > 800 ? 34.f:0.f))];
    __weak typeof(self) weakSelf = self;
    self.bottomView.editModeBlock = ^{
        weakSelf.allowEdit = NO;
        weakSelf.listView.scrollEnabled = YES;
        if (weakSelf.sizeView.frame.size.height>0) {
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.sizeView.frame = CGRectMake(0, KGScreen_height - 80 - (KGScreen_height > 800 ? 34.f:0.f), KGScreen_width, 0);
            }];
        }else{
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.sizeView.frame = CGRectMake(0, KGScreen_height - 80 - (KGScreen_height > 800 ? 34.f:0.f) - 246, KGScreen_width, 246);
            }];
        }
        [weakSelf.listView reloadData];
    };
    self.bottomView.retoModeBlock = ^{
        [weakSelf rotatingImage];
    };
    self.bottomView.scaleModeBlock = ^{
        weakSelf.allowEdit = YES;
        weakSelf.listView.scrollEnabled = NO;
        [weakSelf.listView reloadData];
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.sizeView.frame = CGRectMake(0, KGScreen_height - 80 - (KGScreen_height > 800 ? 34.f:0.f), KGScreen_width, 0);
        }];
    };
    self.bottomView.undoModeBlock = ^{
        weakSelf.allowEdit = NO;
        weakSelf.listView.scrollEnabled = YES;
        [weakSelf.listView reloadData];
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.sizeView.frame = CGRectMake(0, KGScreen_height - 80 - (KGScreen_height > 800 ? 34.f:0.f), KGScreen_width, 0);
        }];
        [weakSelf undoEditImage];
    };
    self.bottomView.setNormalBlock = ^{
        weakSelf.allowEdit = NO;
        weakSelf.listView.scrollEnabled = YES;
        [weakSelf.listView reloadData];
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.sizeView.frame = CGRectMake(0, KGScreen_height - 80 - (KGScreen_height > 800 ? 34.f:0.f), KGScreen_width, 0);
        }];
    };
    [self.view addSubview:self.bottomView];
    
    /** 创建切割比例界面*/
    self.sizeView = [[KGChangeImgSizeView alloc] initWithFrame:CGRectMake(0, KGScreen_height - 80 - (KGScreen_height > 800 ? 34.f:0.f), KGScreen_width, 0)];
    self.sizeView.typeOf4Than3Block = ^{
        [weakSelf changeImageAndReloadWidth:4 height:3];
    };
    self.sizeView.typeOf16Than9Block = ^{
        [weakSelf changeImageAndReloadWidth:16 height:9];
    };
    self.sizeView.typeOfEqurlBlock = ^{
        [weakSelf changeImageAndReloadWidth:1 height:1];
    };
    self.sizeView.typeOf3Than4Block = ^{
        [weakSelf changeImageAndReloadWidth:3 height:4];
    };
    self.sizeView.typeOf9Than16Block = ^{
        [weakSelf changeImageAndReloadWidth:9 height:16];
    };
    self.sizeView.typeOfCustomBlock = ^{
        
    };
    [self.view addSubview:self.sizeView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KGEditPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KGEditPhotoCell" forIndexPath:indexPath];
    NSMutableArray *arr = _dataArr[indexPath.row];
    NSDictionary *dic = [arr lastObject];
    [cell contentWithDic:dic];
    [cell editImg:self.allowEdit];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.currIndex = scrollView.contentOffset.x/KGScreen_width;
}

- (UIImage *)tailoringImageWithImage:(UIImage *)img width:(NSInteger)width height:(NSInteger)height type:(BOOL)type{
    return [UIImage imageWithCGImage:CGImageCreateWithImageInRect([img CGImage], CGRectMake(0, 0, img.size.width/width*height>img.size.height?img.size.height/height*width:img.size.width, img.size.width/width*height>img.size.height?img.size.height:img.size.width/width*height))];
}

- (void)changeImageAndReloadWidth:(NSInteger)width height:(NSInteger)height{
    [UIView animateWithDuration:0.2 animations:^{
        self.sizeView.frame = CGRectMake(0, KGScreen_height - 80 - (KGScreen_height > 800 ? 34.f:0.f), KGScreen_width, 0);
    }];
    NSMutableArray *arr = self.dataArr[self.currIndex];
    NSDictionary *dic = [arr lastObject];
    UIImage *img = dic[@"img"];
    NSDictionary *tmpDic = @{@"img":[self tailoringImageWithImage:img width:width height:height type:YES]};
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:arr];
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSMutableArray *obj in self.dataArr) {
        if ([obj isEqualToArray:arr]) {
            [tmpArr addObject:tmpDic];
            [dataArray addObject:tmpArr];
        }else{
            [dataArray addObject:obj];
        }
    }
    self.dataArr = dataArray;
    [self.listView reloadData];
}

- (void)undoEditImage{
    NSMutableArray *arr = self.dataArr[self.currIndex];
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSMutableArray *obj in self.dataArr) {
        if ([obj isEqualToArray:arr]) {
            if (arr.count>2) {
                [arr removeLastObject];
            }
            [dataArray addObject:arr];
        }else{
            [dataArray addObject:obj];
        }
    }
    self.dataArr = dataArray;
    [self.listView reloadData];
}

- (void)rotatingImage{
    self.allowEdit = YES;
    self.listView.scrollEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.sizeView.frame = CGRectMake(0, KGScreen_height - 80 - (KGScreen_height > 800 ? 34.f:0.f), KGScreen_width, 0);
    }];
    
    NSMutableArray *arr = self.dataArr[self.currIndex];
    NSDictionary *dic = [arr lastObject];
    UIImage *img = dic[@"img"];
    
    CGRect rect = CGRectMake(0,0,img.size.height, img.size.width);
    
    float translateX = 0;
    
    float translateY = -rect.size.width;
    
    float scaleY = rect.size.width/rect.size.height;
    
    float scaleX = rect.size.height/rect.size.width;
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextRotateCTM(context, M_PI_2);
    
    CGContextTranslateCTM(context, translateX,translateY);
    
    CGContextScaleCTM(context, scaleX,scaleY);
    
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0,0,rect.size.width, rect.size.height), img.CGImage);
    
    UIImage *newPic =UIGraphicsGetImageFromCurrentImageContext();
    
    NSDictionary *tmpDic = @{@"img":newPic};
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:arr];
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSMutableArray *obj in self.dataArr) {
        if ([obj isEqualToArray:arr]) {
            [tmpArr addObject:tmpDic];
            [dataArray addObject:tmpArr];
        }else{
            [dataArray addObject:obj];
        }
    }
    self.dataArr = dataArray;
    [self.listView reloadData];
}

@end
