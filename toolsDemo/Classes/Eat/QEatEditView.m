//
//  QEatEditView.m
//  toolsDemo
//
//  Created by mrq on 2019/4/10.
//  Copyright © 2019 钱立顺. All rights reserved.
//

#import "QEatEditView.h"
#import "QEatCollectionViewCell.h"

@interface QEatEditView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *dataSourceList;
@end

static NSString *cellID = @"CollectionCell";
@implementation QEatEditView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //创建一个layout布局类
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        //设置布局方向为垂直流布局
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //设置每个item的大小为100*100
        layout.itemSize = CGSizeMake(70, 50);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(20, 50, frame.size.width-40, frame.size.height-50) collectionViewLayout:layout];
        _collectionView.backgroundColor = self.backgroundColor;
        [self addSubview:_collectionView];
        
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        
        [self.collectionView registerClass:[QEatCollectionViewCell class] forCellWithReuseIdentifier:cellID];

        UIButton *done = [UIButton buttonWithType:UIButtonTypeSystem];
        [done setFrame:CGRectMake(frame.size.width-80, 0, 80, 40)];
        [done setTitle:@"完成" forState:UIControlStateNormal];
        [done.titleLabel setFont:[UIFont systemFontOfSize:20]];
        [done addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:done];
    }
    return self;
}

- (void)done:(id)sender{
    NSMutableArray *list = [NSMutableArray array];
    for (QEatCellModel *m in self.dataSourceList) {
        [list addObject:m.title];
    }
    self.doneBlock(list.copy);
}

- (void)setList:(NSArray *)list{
    NSMutableArray *modelList = [NSMutableArray array];
    for (NSString *str in list) {
        QEatCellModel *m = [QEatCellModel new];
        m.title = str;
        [modelList addObject:m];
    }
    self.dataSourceList = [NSArray arrayWithArray:modelList];
    [self.collectionView reloadData];
}

- (NSArray *)getList{
    NSMutableArray *list = [NSMutableArray array];
    for (QEatCellModel *m in self.dataSourceList) {
        [list addObject:m.title];
    }
    return list.copy;
}

#pragma colllectionview delegate & datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSourceList.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    QEatCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    if(indexPath.row < self.dataSourceList.count){
        QEatCellModel *cel = [self.dataSourceList objectAtIndex:indexPath.row];
        cell.descLabel.text = cel.title;
    }else{
        cell.descLabel.text = @"添加";
    }
  
    //可删除情况下；
    if (indexPath.row == self.dataSourceList.count){
        cell.deleteButton.hidden = true;
    }else{
        cell.deleteButton.hidden = false;
    }
    [cell.deleteButton addTarget:self action:@selector(deleteCellButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == self.dataSourceList.count) {
        NSLog(@"点击最后一个cell，执行添加操作");
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Create", nil) message:NSLocalizedString(@"Enter a file name",nil) preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"file";
        }];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *name = alertVC.textFields.firstObject.text;
            [self dataListAddString:name];
            //更新UI；
            [self.collectionView reloadData];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:ok];
        [alertVC addAction:cancel];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
        
        
    }
}

- (void)deleteCellButtonPressed: (id)sender{
    QEatCollectionViewCell *cell = (QEatCollectionViewCell *)[sender superview];//获取cell
    
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:cell];//获取cell对应的indexpath;
    
    [self dataListRemoveAtIndex:indexpath.row];
    
    [self.collectionView reloadData];
    
    NSLog(@"删除按钮，section:%ld ,   row: %ld",(long)indexpath.section,(long)indexpath.row);
    
}

- (void)dataListAddString:(NSString*)str{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataSourceList];
    QEatCellModel *m = [QEatCellModel new];
    m.title = str;
    [array addObject:m];
    self.dataSourceList = array.copy;
}

- (void)dataListRemoveAtIndex:(NSInteger)index{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataSourceList];
    [array removeObjectAtIndex:index];
    self.dataSourceList = array.copy;
}
@end
