//
//  WaterfallFlowLayout.m
//  toolsDemo
//
//  Created by Mr.Q on 16/5/11.
//  Copyright © 2016年 钱立顺. All rights reserved.
//

#import "WaterfallFlowLayout.h"

@interface WaterfallFlowLayout ()

@property (nonatomic,strong) NSMutableArray *attrs;


@end

#define Count 101

@implementation WaterfallFlowLayout

-(NSMutableArray *)attrs{
    if (_attrs == nil) {
        _attrs = [NSMutableArray array];
    }
    return _attrs;
}

-(void)prepareLayout{
    // 创建一个数组,这个数组中包含了很多的UICollectionViewLayoutAttributes对象
    // 每个对象表示一个cell
    //self.dateList

    // 保存所有的item的高度的和
    CGFloat itemH_sum  = 0;
    // 0.1 计算每个item的宽度
    // 除了组的内边距两边的宽度
    CGFloat contentW = self.collectionView.bounds.size.width - self.sectionInset.left-self.sectionInset.right;
    // 每个cell的宽度
    CGFloat itemW = (contentW - (self.columns-1)*self.minimumInteritemSpacing) / self.columns;

    // 定义一个用来保存cell的y值的数组
    float colmunsY[self.columns];
    // 初始化数组
    for (int i = 0; i < self.columns; i++) {
        colmunsY[i] = self.sectionInset.top;
    }

    for (int i = 0; i<Count; i++) {
        // 取出模型
        UIImage *image = (UIImage *)self.dataArray[ i % self.dataArray.count];
        // 创建NSIndexPath
        NSIndexPath *idxPath = [NSIndexPath indexPathForItem:i inSection:0];
        // 创建attribute对象
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:idxPath];

        // 计算每个cell对应的frame,并设置给这个attr对象
        // 0.2 计算高度  新的H = 新的W * 原始H / 原始W

        CGFloat itemH = [self itemHWithOriginSize:CGSizeMake(image.size.width,image.size.height) itemW:itemW];

        //累加每个item的高度
        itemH_sum += itemH;

        // 0.3 计算每个item的x值
        // 0.3.1计算出每个cell所在的列索引
        //         int col_idx = i% self.columns;

        // 如何获取列的索引?要根据当前的colmunsY这个数组中取一个最小值.把下一个item排在它下面
        int col_idx = [self columnIdxOfMinimumMaxYWithColumnsY:colmunsY];

        //  // 计算x
        CGFloat itemX = self.sectionInset.left + col_idx * (itemW + self.minimumInteritemSpacing);
        // 0.4 计算 y 值
        CGFloat itemY = colmunsY[col_idx];
        colmunsY[col_idx] += (itemH + self.minimumLineSpacing);

        attr.frame = CGRectMake(itemX ,itemY ,itemW , itemH);

        [self.attrs addObject:attr];
    }

    // 因为collection view的滚动范围（contentSize）是根据itemSize来计算出来的
    // 为了能让滚动正常, 所以要统一设置itemSize
    self.itemSize = CGSizeMake(itemW, itemH_sum/Count);
}

// 计算出最小(每个item的最大y值里面找找最小的那个)的那个列的索引
-(int)columnIdxOfMinimumMaxYWithColumnsY:(float *)columnsY{
    //假设索引为0的那个就是最小值
    int col = 0;
    CGFloat min_y = columnsY[col];

    for (int i=0; i<self.columns; i++) {
        if (columnsY[i] < min_y) {
            min_y = columnsY[i];
            col = i;
        }
    }
    return col;
}

// 计算item高度的方法
-(CGFloat)itemHWithOriginSize:(CGSize)size itemW:(CGFloat)w{
    return w * size.height / size.width;
}

// 返回指定区域内的（rect）所有 cell 的布局属性
// 每个UICollectionViewLayoutAttributes表示一个 cell的相关的一组属性。
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    return self.attrs;
}
@end
