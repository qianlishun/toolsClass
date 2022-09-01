//
//  QPDFReader.m
//  toolsDemo
//
//  Created by Qianlishun on 2022/2/14.
//  Copyright © 2022 钱立顺. All rights reserved.
//

#import "QPDFReader.h"
#import "PDFOutlineViewController.h"
#import "PDFThumbnailViewController.h"
#import "PDFSearchViewController.h"
#import "PDFView+QExtension.h"

@interface QPDFReader()<PDFOutlineDelegate,PDFThumbnailDelegate,PDFSearchDelegate>

@property (nonatomic, strong) UIView *zoomBaseView;
@property (nonatomic, strong) UIButton *btnZoomIn;
@property (nonatomic, strong) UIButton *btnZoomOut;
@property (nonatomic, assign) BOOL hasDisplay;

@property (nonatomic, strong) UIView *toolsView;

@property(nonatomic, strong) NSMutableDictionary *pdfSaveData;
@end

@implementation QPDFReader

- (void)setDocument:(PDFDocument *)document{
    _document = document;
    
    self.title = document.documentURL.lastPathComponent;
    self.pdfView.document = document;
    self.pdfView.scaleFactor = self.pdfView.scaleFactorForSizeToFit;
    
    NSString *key = self.document.documentURL.lastPathComponent;
    if( [self.pdfSaveData.allKeys containsObject:key]){
        NSInteger index = [[self.pdfSaveData objectForKey:key] integerValue];
        PDFPage *page = [self.document pageAtIndex:index];
        [self.pdfView goToPage:page];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        

        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        if (@available(iOS 13.0, *)) {
            [searchBtn setImage:[UIImage systemImageNamed:@"magnifyingglass"]
                        forState:UIControlStateNormal];
        }else{
            [searchBtn setTitle:@"查找" forState:UIControlStateNormal];
        }
        [searchBtn addTarget:self action:@selector(onSearch:) forControlEvents:UIControlEventTouchUpInside];

        UIBarButtonItem *searchItem = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];

        self.navigationItem.rightBarButtonItems = @[searchItem];
        
        [self setupPDFView];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appDidEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    if (@available(iOS 11.0, *)) {
        edgeInsets = self.view.safeAreaInsets;
    }
    CGRect rect =  CGRectMake(edgeInsets.left, edgeInsets.top, self.view.width-edgeInsets.left-edgeInsets.right, self.view.height-edgeInsets.top);
    
    self.pdfView.frame = rect;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self saveCurrentPDFData];
}

- (void)setupPDFView{
    
    self.pdfView = [[PDFView alloc] initWithFrame:self.view.bounds];
    self.pdfView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    self.pdfView.autoScales = YES;
    self.pdfView.maxScaleFactor = 4.0;
    self.pdfView.minScaleFactor = 0.5;
    self.pdfView.userInteractionEnabled = YES;
    self.pdfView.backgroundColor = [UIColor grayColor];
    [self.pdfView zoomIn:self];
    [self.pdfView setBounces:NO];
    
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
    singleTapGesture.numberOfTapsRequired = 1;
    singleTapGesture.numberOfTouchesRequired = 1;
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction)];
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.numberOfTouchesRequired = 1;
    
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    
    [self.pdfView addGestureRecognizer:singleTapGesture];
    [self.pdfView addGestureRecognizer:doubleTapGesture];
    
    [self.view addSubview:self.pdfView];
    [self.view addSubview:self.toolsView];
//    [self.view addSubview:self.zoomBaseView];
    
    self.hasDisplay = YES;
}

- (void)onOutline:(id)sender{
    
    PDFOutline *outline = self.document.outlineRoot;
    
    if(outline){
        PDFOutlineViewController *outlineVC = [PDFOutlineViewController new];
        outlineVC.outlineRoot = outline;
        outlineVC.delegate = self;
        
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:outlineVC] animated:YES completion:nil];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Attention" message:NSLocalizedString(@"This pdf do not have outline!", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];

    }
    
}

- (void)onThumb:(id)sender{
    
    PDFThumbnailViewController *thumbnailVC = [PDFThumbnailViewController new];
    thumbnailVC.document = self.document;
    thumbnailVC.delegate = self;
    
    [self.navigationController presentViewController:thumbnailVC animated:YES completion:nil];

}

- (void)onSearch:(id)sender{
    
    PDFSearchViewController *searchVC = [PDFSearchViewController new];
    searchVC.document = self.document;
    searchVC.delegate = self;
    
    [self.navigationController presentViewController:searchVC animated:YES completion:nil];

}

#pragma mark - delegate
- (void)outlineViewcontroller:(PDFOutlineViewController *)controller didSelectOutline:(PDFOutline *)outline{
    PDFAction *action = outline.action;
    PDFActionGoTo *gotoAC = (PDFActionGoTo*)action;
    
    if(gotoAC){
        [self.pdfView goToDestination:gotoAC.destination];
    }
}

- (void)thumbnailViewController:(PDFThumbnailViewController *)controller didSelectAtIndex:(NSIndexPath *)indexPath{
    PDFPage *page = [self.document pageAtIndex:indexPath.item];
    [self.pdfView goToPage:page];
}

- (void)searchViewController:(PDFSearchViewController *)controller didSelectSearchResult:(PDFSelection *)selection{
    
}

#pragma mark - -

- (void)singleTapAction
{
    NSLog(@"%s",__func__);
    [self tapAnimationView:self.toolsView];
    self.hasDisplay = !self.hasDisplay;
}

- (void)tapAnimationView:(UIView*)view{
    if (self.hasDisplay)
    {
        view.hidden = NO;
        view.alpha = 1.0;
        
        [UIView animateWithDuration:0.2 animations:^{
            view.alpha = 0.0;
        } completion:^(BOOL finished) {
            view.hidden = YES;
        }];
    }
    else
    {
        view.hidden = NO;
        view.alpha = 0.0;
        
        [UIView animateWithDuration:0.2 animations:^{
            view.alpha = 1.0;
        } completion:^(BOOL finished) {
            view.hidden = NO;
        }];
    }
}

- (void)doubleTapAction
{
    NSLog(@"%s",__func__);
    
    NSLog(@"%f",self.pdfView.scaleFactorForSizeToFit);
    
    if (self.pdfView.scaleFactor == self.pdfView.scaleFactorForSizeToFit)
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.pdfView.scaleFactor = self.pdfView.scaleFactorForSizeToFit * 4;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.pdfView.scaleFactor = self.pdfView.scaleFactorForSizeToFit;
        }];
    }
}

- (void)zoomInAction
{
    NSLog(@"%s",__func__);
    
    [UIView animateWithDuration:0.1 animations:^{
        [self.pdfView zoomIn:nil];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)zoomOutAction
{
    NSLog(@"%s",__func__);
    
    [UIView animateWithDuration:0.1 animations:^{
        [self.pdfView zoomOut:nil];
    } completion:^(BOOL finished) {
        
    }];
}

- (UIView *)zoomBaseView
{
    if (!_zoomBaseView)
    {
        UIColor *blueColor = [UIColor colorWithRed:21/255.0 green:126/255.0 blue:251/255.0 alpha:1.0];
        
        _zoomBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 100)];
        _zoomBaseView.center = CGPointMake([UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height - [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom - 80);
        
        _btnZoomIn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnZoomIn.frame = CGRectMake(0, 0, 40, 50);
        _btnZoomIn.layer.borderWidth = 1;
        _btnZoomIn.layer.borderColor = blueColor.CGColor;
        [_btnZoomIn setTitle:@"+" forState:UIControlStateNormal];
        [_btnZoomIn setTitleColor:blueColor forState:UIControlStateNormal];
        [_btnZoomIn.titleLabel setFont:[UIFont systemFontOfSize:25]];
        [_btnZoomIn addTarget:self action:@selector(zoomInAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_zoomBaseView addSubview:_btnZoomIn];
        
        _btnZoomOut = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnZoomOut.frame = CGRectMake(0, 50, 40, 50);
        _btnZoomOut.layer.borderWidth = 1;
        _btnZoomOut.layer.borderColor = blueColor.CGColor;
        [_btnZoomOut setTitle:@"-" forState:UIControlStateNormal];
        [_btnZoomOut setTitleColor:blueColor forState:UIControlStateNormal];
        [_btnZoomOut.titleLabel setFont:[UIFont systemFontOfSize:25]];
        [_btnZoomOut addTarget:self action:@selector(zoomOutAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_zoomBaseView addSubview:_btnZoomOut];
    }
    
    return _zoomBaseView;
}

- (UIView *)toolsView{
    if(!_toolsView){
        _toolsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 90)];
        _toolsView.center = CGPointMake([UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height - [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom - 80);
        _toolsView.backgroundColor = [UIColor clearColor];
        
        UIButton *outlineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        outlineBtn.frame = CGRectMake(0, 0, 40, 40);
//        if (@available(iOS 13.0, *)) {
//            [outlineBtn setImage:[UIImage systemImageNamed:@"list.bullet"] forState:UIControlStateNormal];
//        } else {
            [outlineBtn setImage:[UIImage imageNamed:@"list_bullet"] forState:UIControlStateNormal];
//        }
        [outlineBtn addTarget:self action:@selector(onOutline:) forControlEvents:UIControlEventTouchUpInside];
        
        [_toolsView addSubview:outlineBtn];
        
        UIButton *thumbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        thumbBtn.frame = CGRectMake(0, 45, 40, 40);
//        if (@available(iOS 13.0, *)) {
//            [thumbBtn setImage:[UIImage systemImageNamed:@"rectangle.grid.2x2"] forState:UIControlStateNormal];
//        } else {
            [thumbBtn setImage:[UIImage imageNamed:@"rectangle_grid_2x2"] forState:UIControlStateNormal];
//        }
        [thumbBtn addTarget:self action:@selector(onThumb:) forControlEvents:UIControlEventTouchUpInside];
        
        [_toolsView addSubview:thumbBtn];
    }
    
    return _toolsView;
}

#pragma mark PDF Save
- (NSMutableDictionary *)pdfSaveData{
    if(!_pdfSaveData){
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        _pdfSaveData = [ud objectForKey:@"QPDF_SAVEDATA"];
    }
    return _pdfSaveData;
}

- (void)saveCurrentPDFData{
    NSInteger index = [self.document indexForPage:self.pdfView.currentPage];
    NSString *key = self.document.documentURL.lastPathComponent;
    
    [self.pdfSaveData setObject:[NSNumber numberWithInteger:index] forKey:key];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:self.pdfSaveData forKey:@"QPDF_SAVEDATA"];
}

- (void)appDidEnterBackground:(NSNotification*)noti{
    [self saveCurrentPDFData];
}

- (void)dealloc{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
