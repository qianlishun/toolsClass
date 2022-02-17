//
//  PDFSearchViewController.m
//  toolsDemo
//
//  Created by Qianlishun on 2022/2/14.
//  Copyright © 2022 钱立顺. All rights reserved.
//

#import "PDFSearchViewController.h"
#import "PDFSearchCell.h"

NSString *const pdfSearchCellID = @"pdfSearchCellID";

@interface PDFSearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,PDFDocumentDelegate>
@property(nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *searchData;
@end

@implementation PDFSearchViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    [self.searchBar becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    
    self.title = @"查找";
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [self.navigationItem.leftBarButtonItem setTintColor: [UIColor blackColor]];

    self.navigationItem.titleView = self.searchBar;
    [self.view addSubview:self.tableView];
}

- (UISearchBar *)searchBar{
    if(!_searchBar){
        _searchBar = [[UISearchBar alloc]init];
        _searchBar.delegate = self;
        _searchBar.showsCancelButton = YES;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    }
    return _searchBar;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 150;
    }
    return _tableView;
}

- (NSMutableArray *)searchData{
    if(!_searchData){
        _searchData = [NSMutableArray array];
    }
    return _searchData;
}
#pragma mark - UITableView delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PDFSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:pdfSearchCellID];
    if(!cell){
        cell = [[PDFSearchCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:pdfSearchCellID];
    }
    PDFSelection *selection = self.searchData[indexPath.row];
    PDFPage *page = selection.pages[0];
    PDFOutline *outline = [self.document outlineItemForSelection:selection];
    
    NSString *destination = [NSString stringWithFormat:@"%@ PAGE: %@", outline.label, page.label];
    cell.destinationLabel.text = destination;
    
    PDFSelection *extendSelction = [selection copy];
    [extendSelction extendSelectionAtStart:10];
    [extendSelction extendSelectionAtEnd:90];
    [extendSelction extendSelectionForLineBoundaries];
    
    NSRange range = [extendSelction.string rangeOfString:selection.string options:NSCaseInsensitiveSearch];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:extendSelction.string];
    [attrStr addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:range];
    
    cell.resultLabel.attributedText = attrStr;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(searchViewController:didSelectSearchResult:)]){
        PDFSelection *selection = self.searchData[indexPath.row];
        [self.delegate searchViewController:self didSelectSearchResult:selection];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}

#pragma mark - UISearchBar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.document cancelFindString];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length < 2)
        return;
    
    [self.searchData removeAllObjects];
    [self.tableView reloadData];
    
    [self.document cancelFindString];
    self.document.delegate = self;
//    NSCaseInsensitiveSearch  不区分大小写和比较
    [self.document beginFindString:searchText withOptions:NSCaseInsensitiveSearch];
    
}

#pragma mark - PDFDocument Delegate
- (void)didMatchString:(PDFSelection *)instance{
    [self.searchData addObject:instance];
    [self.tableView reloadData];
}


@end
