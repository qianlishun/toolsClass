//
//  PDFThumbnailViewController.m
//  toolsDemo
//
//  Created by Qianlishun on 2022/2/14.
//  Copyright © 2022 钱立顺. All rights reserved.
//

//@interface PDFThumbnailCell : NSObject
//
//@end

#import "PDFThumbnailViewController.h"
#import "PDFThumbnailCell.h"

NSString *const pdfThumbnailCellID = @"pdfThumbnailCellID";


@interface PDFThumbnailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    dispatch_queue_t queue;
    NSCache *thumbnailCache;
}
@property(nonatomic, strong) UICollectionView *collectionView;
@end

@implementation PDFThumbnailViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(!self.collectionView.superview){
        [self.view addSubview:self.collectionView];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    
    self.title = @"缩略图";
    
    queue = dispatch_queue_create("thumbnail.pdfview", DISPATCH_QUEUE_CONCURRENT);
    thumbnailCache = [NSCache new];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [self.navigationItem.leftBarButtonItem setTintColor: [UIColor blackColor]];

}

- (UICollectionView *)collectionView{
    if(!_collectionView){
        CGFloat itemWidth = floor((self.view.bounds.size.width - 10 * 4) / 3.0);
        CGFloat itemHeight = itemWidth * 1.5;

        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor grayColor];
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[PDFThumbnailCell class] forCellWithReuseIdentifier:pdfThumbnailCellID];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (void)setDocument:(PDFDocument *)document{
    _document = document;
}

#pragma mark - UICollectionView delegate & datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.document.pageCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PDFThumbnailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:pdfThumbnailCellID forIndexPath:indexPath];
    
    PDFPage *page = [self.document pageAtIndex:indexPath.item];
    
    cell.titleLabel.text = page.label;
    
    NSString *key = [NSString stringWithFormat:@"%ld",(long)indexPath.item];
    
    UIImage *image = [thumbnailCache objectForKey:key];
    
    if(image){
        cell.imageView.image = image;
    }else{
        CGSize imageSize = CGSizeMake(cell.bounds.size.width*2, cell.bounds.size.height*2);
        dispatch_async(queue, ^{
            UIImage *image = [page thumbnailOfSize:imageSize forBox:kPDFDisplayBoxMediaBox];
            [self->thumbnailCache setObject:image forKey:key];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imageView.image = image;
            });
        });
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    [self dismissViewControllerAnimated:YES completion:nil];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(thumbnailViewController:didSelectAtIndex:)]){
        [self.delegate thumbnailViewController:self didSelectAtIndex:indexPath];
    }
}

@end
