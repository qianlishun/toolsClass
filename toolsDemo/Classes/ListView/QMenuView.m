//
//  QMenuView.m
//  toolsDemo
//
//  Created by mrq on 2020/12/11.
//  Copyright © 2020 钱立顺. All rights reserved.
//

#import "QMenuView.h"
#import "QTableView.h"
#import "QTableViewCell.h"
#import "Masonry.h"

@interface QMenuView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) QTableView *tableView;
@property(strong, nonatomic) NSMutableArray<NSString*> *idSource;
@property(strong, nonatomic) NSMutableArray<NSArray<UIView*>*> *viewSource;

@property (nonatomic,assign) CGSize cellSize;

@end

@implementation QMenuView

static NSString *const kTableViewCellID = @"QTableView_cell";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.viewSource = [NSMutableArray array];
        self.idSource = [NSMutableArray array];
 
        self.tableView = [[QTableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.tableView showsCustomVertiScrollIndicator:YES];
        [self.tableView setVerIndicatorX:self.tableView.width-4];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self addSubview:self.tableView];
        self.tableView.separatorColor = [UIColor lightGrayColor];
        self.tableView.estimatedRowHeight = 44;
        self.tableView.rowHeight = UITableViewAutomaticDimension;

        _cellSize = CGSizeMake(frame.size.width, 44);
    }
    return self;
}

- (void)setCellSize:(CGSize)size{
    _cellSize = size;
}

- (void)setCellList:(NSArray *)cells{
    self.idSource = [NSMutableArray array];
    self.viewSource = [NSMutableArray array];
    for (int i = 0; i < cells.count; i++) {
        NSDictionary *dict = cells[i];
        NSString *ID = dict.allKeys.firstObject;
        NSArray *array = dict.allValues.firstObject;
        if(ID && array){
            [self.idSource addObject:ID];
            [self.viewSource addObject:array];
        }
    }
    [self delayReloadTableView];
}

- (void)appendCell:(NSDictionary *)cell{
    NSString *ID = cell.allKeys.firstObject;
    NSArray *array = cell.allValues.firstObject;
    if(ID && array){
        [self.idSource addObject:ID];
        [self.viewSource addObject:array];
        
        [self delayReloadTableView];

    }
}


- (void)insertCell:(NSDictionary *)cell afterID:(NSString *)afterID{
    if([self.idSource containsObject:afterID]){
        NSUInteger index = [self.idSource indexOfObject:afterID]+1;

        NSString *ID = cell.allKeys.firstObject;
        NSArray *array = cell.allValues.firstObject;
        if(ID){
            [self.idSource insertObject:ID atIndex:index];
            [self.viewSource insertObject:array atIndex:index];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        }
    }
}

- (NSArray *)findCellWithID:(NSString *)ID{
    if([self.idSource containsObject:ID]){
        NSUInteger index = [self.idSource indexOfObject:ID];
        
        return self.viewSource[index];
    }
    return nil;
}

- (BOOL)deleteCellWithID:(NSString *)ID{
    if([self.idSource containsObject:ID]){
        NSUInteger index = [self.idSource indexOfObject:ID];
        
        [self.viewSource removeObjectAtIndex:index];
        [self.idSource removeObjectAtIndex:index];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];

        return YES;
    }
    return NO;
}

- (void)delayReloadTableView{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadTableView) object:nil];
    [self performSelector:@selector(reloadTableView) withObject:nil afterDelay:0.05];
}

- (void)reloadTableView{
    [self.tableView reloadData];
}

#pragma mark - TableView DataSource & Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat h = [self.viewSource[indexPath.row].lastObject.superview height];
    NSLog(@"%ld ,%.f",(long)indexPath.row,h);
//    if(h < 44) h = 44;
    return h;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.idSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellID];
    if(!cell){
        cell = [[QTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableViewCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setViews:self.viewSource[indexPath.row] size:_cellSize];
    
//    [cell setText:NSLocalizedString(self.nameSource[indexPath.row], nil)];
//    [cell setView:self.viewSource[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(5, 10, 5, 10)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsMake(5, 10, 5, 10)];
    }
  
}
@end
