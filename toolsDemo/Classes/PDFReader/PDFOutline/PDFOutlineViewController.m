//
//  PDFOutlineViewController.m
//  toolsDemo
//
//  Created by Qianlishun on 2022/2/14.
//  Copyright © 2022 钱立顺. All rights reserved.
//

#import "PDFOutlineViewController.h"
#import "PDFOutlineCell.h"

NSString *const outlineCellID = @"outlineCellID";

@interface PDFOutlineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *outlineData;

@end

@implementation PDFOutlineViewController

- (void)setOutlineRoot:(PDFOutline *)outlineRoot
{
    _outlineRoot = outlineRoot;
    
    for (int i = 0; i < outlineRoot.numberOfChildren; i++)
    {
        PDFOutline *outline = [outlineRoot childAtIndex:i];
        outline.isOpen = NO;
        [self.outlineData addObject:outline];
    }
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"目录";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    
    [self.view addSubview:self.tableView];
}

- (void)onCancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - outline
- (void)insertOutlineWithParentOutline:(PDFOutline*)parentOutline{
    NSInteger baseIndex = [self.outlineData indexOfObject:parentOutline];
    
    for (int i = 0; i < parentOutline.numberOfChildren; i++) {
        PDFOutline *temp = [parentOutline childAtIndex:i];
        temp.isOpen = NO;
        [self.outlineData insertObject:temp atIndex:baseIndex+i+1];
    }
}

- (void)removeOutlineWithParentOutline:(PDFOutline*)parentOutline{
    if(parentOutline.numberOfChildren <= 0)
        return;
    
    for (int i = 0; i < parentOutline.numberOfChildren; i++) {
        
        PDFOutline *node = [parentOutline childAtIndex:i];
        
        if(node.numberOfChildren > 0 && node.isOpen){
            [self removeOutlineWithParentOutline:node];
            
            NSInteger index = [self.outlineData indexOfObject:node];
            
            if (index) {
                [self.outlineData removeObjectAtIndex:index];
            }
        }else{
            if([self.outlineData containsObject:node]){
                NSInteger index = [self.outlineData indexOfObject:node];
                if(index){
                    [self.outlineData removeObjectAtIndex:index];
                }
            }
        }
        
    }
}

- (NSInteger)findDepthWithOutline:(PDFOutline*)outline{
    NSInteger depth = -1;
    PDFOutline *temp = outline;
    while (temp.parent != nil) {
        depth++;
        temp = temp.parent;
    }
    return depth;
}

#pragma mark - tableView delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.outlineData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PDFOutlineCell *cell = [tableView dequeueReusableCellWithIdentifier:outlineCellID];
    if (!cell) {
        cell = [[PDFOutlineCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:outlineCellID];
    }

    PDFOutline *outline = self.outlineData[indexPath.row];
    cell.leftLabel.text = outline.label;
    cell.rightLabel.text = outline.destination.page.label;
    cell.selBtn.selected = outline.isOpen;
    
    if(outline.numberOfChildren > 0){
        NSString *imageName = outline.isOpen ? @"▽" : @"▷";
        [cell.selBtn setTitle:imageName forState:UIControlStateNormal];
        cell.selBtn.enabled = YES;
    }else{
        [cell.selBtn setTitle:@"" forState:UIControlStateNormal];
        cell.selBtn.enabled = NO;
    }
    
    cell.outlineBlock = ^(UIButton *button) {
     
        if(outline.numberOfChildren > 0){
            if(button.isSelected){
                outline.isOpen = YES;
                [self insertOutlineWithParentOutline:outline];
            }else{
                outline.isOpen = NO;
                [self removeOutlineWithParentOutline:outline];
            }
            [tableView reloadData];
        }
    };
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    PDFOutline *outline = self.outlineData[indexPath.row];
    
    return [self findDepthWithOutline:outline];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PDFOutline *outline = [self.outlineData objectAtIndex:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(outlineViewcontroller:didSelectOutline:)]){
        [self.delegate outlineViewcontroller:self didSelectOutline:outline];
    }
    
    [self onCancel];
}


- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    
    return _tableView;
}

- (NSMutableArray *)outlineData{
    if(!_outlineData){
        _outlineData = [NSMutableArray array];
    }
    return _outlineData;
}


@end
