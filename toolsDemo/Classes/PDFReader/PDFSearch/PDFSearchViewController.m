//
//  PDFSearchViewController.m
//  toolsDemo
//
//  Created by Qianlishun on 2022/2/14.
//  Copyright © 2022 钱立顺. All rights reserved.
//

#import "PDFSearchViewController.h"

@interface PDFSearchViewController ()

@end

@implementation PDFSearchViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    
    self.title = @"查找";
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [self.navigationItem.leftBarButtonItem setTintColor: [UIColor blackColor]];

}

@end
