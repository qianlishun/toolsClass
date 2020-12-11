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

@interface QMenuView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) QTableView *tableView;

@property(strong, nonatomic) NSMutableArray<NSString*> *idSource;
@property(strong, nonatomic) NSMutableArray<NSString*> *nameSource;
@property(strong, nonatomic) NSMutableArray<UIView*> *viewSource;

@end

@implementation QMenuView

static NSString *const kTableViewCellID = @"QTableView_cell";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tableView = [[QTableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.tableView showsCustomVertiScrollIndicator:YES];
        [self.tableView setVerIndicatorX:self.tableView.width-4];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self addSubview:self.tableView];
        self.tableView.separatorColor = [UIColor lightGrayColor];
        self.tableView.estimatedRowHeight = 44;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return self;
}

- (void)setViewList:(NSArray *)views forNames:(NSArray *)names{
    self.viewSource = [NSMutableArray arrayWithArray:views];
    self.nameSource = [NSMutableArray arrayWithArray:names];
    self.idSource = [NSMutableArray arrayWithArray:names];
    
    [self.tableView reloadData];
}

- (void)appendView:(UIView *)view name:(NSString *)name forID:(NSString *)ID{
    [self.viewSource addObject:view];
    [self.nameSource addObject:name];
    if(ID){
        [self.idSource addObject:ID];
    }else{
        [self.idSource addObject:name];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.nameSource.count-1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)insertViewAfterID:(NSString *)afterID view:(UIView *)view name:(NSString *)name forID:(NSString *)ID{
    
    if([self.idSource containsObject:afterID]){
        NSUInteger index = [self.idSource indexOfObject:afterID]+1;

        [self.viewSource insertObject:view atIndex:index];
        [self.nameSource insertObject:name atIndex:index];
        if(ID){
            [self.idSource insertObject:ID atIndex:index];
        }else{
            [self.idSource insertObject:name atIndex:index];
        }
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    }else{
        [self.viewSource addObject:view];
        [self.nameSource addObject:name];
        if(ID){
            [self.idSource addObject:ID];
        }else{
            [self.idSource addObject:name];
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.nameSource.count-1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (UIView *)findViewWithID:(NSString *)ID{
    if([self.idSource containsObject:ID]){
        NSUInteger index = [self.idSource indexOfObject:ID];
        
        return self.viewSource[index];
    }
    return nil;
}

- (BOOL)deleteViewWithID:(NSString *)ID{
    if([self.idSource containsObject:ID]){
        NSUInteger index = [self.idSource indexOfObject:ID];
        
        [self.nameSource removeObjectAtIndex:index];
        [self.viewSource removeObjectAtIndex:index];
        [self.idSource removeObjectAtIndex:index];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        return YES;
    }
    return NO;
}

#pragma mark - TableView DataSource & Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.viewSource[indexPath.row] height];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.nameSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellID];
    if(!cell){
        cell = [[QTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableViewCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setText:NSLocalizedString(self.nameSource[indexPath.row], nil)];
    [cell setView:self.viewSource[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==self.viewSource.count-1) {
    }else{
        if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
        }
    }
  
}
@end
