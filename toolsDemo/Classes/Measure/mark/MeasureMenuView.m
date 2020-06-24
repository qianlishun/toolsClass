//
//  MeasureMenu.m
//  WirelessUSG3
//
//  Created by mrq on 2019/10/21.
//  Copyright © 2019 SonopTek. All rights reserved.
//

#import "MeasureMenuView.h"
@interface MeasureMenuView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIImageView *tip;

@property (nonatomic,strong) UIColor *titleColor;
@property (nonatomic,strong) UIColor *bgColor;

@end

@implementation MeasureMenuView

- (void)setTitleColor:(UIColor *)tColor bgColor:(UIColor *)bgColor{
    self.titleColor = tColor;
    self.bgColor = bgColor;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.tableView setBackgroundColor:[UIColor clearColor]];
        [self.tableView.layer setCornerRadius:8];
        self.tableView.layer.masksToBounds = YES;
        [self.tableView.layer setBorderColor:kSeparatorColor.CGColor];
        [self.tableView.layer setBorderWidth:1.0];
        self.tableView.bounces = NO;
        [self.tableView setScrollEnabled:YES];
        [self.tableView setShowsVerticalScrollIndicator:YES];
        [self.tableView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
        [self.tableView setSeparatorColor:kSeparatorColor];
        [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];

        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        [self addSubview:self.tableView];
        
        self.list = [NSArray array];
        
        self.tip = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 10, 30)];
        self.tip.image = [UIImage imageNamed:@"measure_up.png"];
        [self addSubview:self.tip];
        self.tip.hidden = YES;
    }
    return self;
}

- (void)setSize:(CGSize)size{
    [super setSize:size];
    
    [self.tip setCenterY:size.height/2];
    
    [self.tableView setSize:size];

    if(self.list.count*self.tableView.rowHeight - size.height>self.tableView.rowHeight/2){
        self.tip.hidden = NO;
    }else{
        self.tip.hidden = YES;
    }
}

- (void)setMeasureList:(NSArray *)list andRowSize:(CGSize)size{
    CGFloat kScreenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat h = size.height * list.count;
     if( h > kScreenH*0.45){
         h = kScreenH * 0.45;
     }
    self.list = [NSArray arrayWithArray:list];
    
    self.tableView.rowHeight = size.height;
    [self setSize:CGSizeMake(size.width, h)];

    [self.tableView reloadData];
}

- (void)examinationSelect:(UIButton *)sender{
    if([_delegate respondsToSelector:@selector(measureSelect:menuView:)]){
        [_delegate measureSelect:sender.tag menuView:self];
    }
}


#pragma mark - tableview delegate & datasouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = self.bgColor;
        cell.textLabel.textColor = self.titleColor;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        //        [cell.textLabel setFont:[UIFont systemFontOfSize:18]];
    }
    cell.textLabel.text = NSLocalizedString(self.list[indexPath.row],nil);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([_delegate respondsToSelector:@selector(measureSelect:menuView:)]){
        [_delegate measureSelect:indexPath.row menuView:self];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==self.list.count-1) {
//        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//            [cell setSeparatorInset:UIEdgeInsetsMake(0,cell.width,0,0)];
//        }
//
//        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//            [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 10)];
//        }
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat height = scrollView.frame.size.height+0.5;
    CGFloat contentoffsetY = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentoffsetY;
    float d = fabs(distanceFromBottom - height);
    [UIView animateWithDuration:0.25 animations:^{
        if (d<3) {
           // "scroll bottom");
           self.tip.transform = CGAffineTransformMakeRotation(M_PI);
        }else if(contentoffsetY==0){
          // "scroll top");
           self.tip.transform = CGAffineTransformMakeRotation(0);
        }
    }];
}

@end
