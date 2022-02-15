//
//  MainController.m
//  toolsDemo
//
//  Created by MrQ on 16/9/17.
//  Copyright © 2015年 QLS. All rights reserved.
//

#import "MainController.h"
    //准备工作  导入头文件
#import "OneController.h"
#import "TwoController.h"
#import "LoginViewController.h"
#import "QPDFViewController.h"

@interface MainController ()

@end

@implementation MainController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    if (@available(iOS 11.0, *)) {
        edgeInsets = self.view.safeAreaInsets;
        [QStateModel sharedInstance].edgeInsets = edgeInsets;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //----------1.第一步:配置导航栏的颜色    我这里使用的是随机色---------------------------------//
    self.navigationBackgroundColor=[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];

    //----------2.第二步:添加子控制器配置数组   可以添加任意个,但是最好不要超过6个---------------------------------//
    self.childControllerAndIconArr=@[
                                     /************第一个控制器配置信息*********************/
                                     @{
                                         VC_VIEWCONTROLLER : [[OneController alloc]init],  //控制器对象
                                         NORMAL_ICON : @"icon_classTable",             //正常状态的Icon 名称
                                         SELECTED_ICON : @"icon_classTable_selected",  //选中状态的Icon 名称
                                         TITLE : @"表"                                 //Nav和Tab的标题
                                         },
                                     /************第二个控制器配置信息*********************/
                                     @{
                                        VC_VIEWCONTROLLER  : [[LoginViewController alloc]init],
                                         NORMAL_ICON : @"icon_me",
                                         SELECTED_ICON : @"icon_me_selected",
                                         TITLE : @"通讯录"
                                         },
                                     @{
                                         VC_VIEWCONTROLLER : [[TwoController alloc]init],
                                         NORMAL_ICON : @"icon_discover",
                                         SELECTED_ICON : @"icon_discover_selected",
                                         TITLE : @"发现"
                                         },

                                     ];
    
    if (@available(iOS 15.0, *)) {
        [UITableView appearance].sectionHeaderTopPadding = 0;
    }
}



- (BOOL)pushPDFVC:(NSURL *)url{
    [url startAccessingSecurityScopedResource];
    NSFileCoordinator *fileCoordiator = [[NSFileCoordinator alloc]initWithFilePresenter:nil];
    NSFileAccessIntent *readingIntent = [NSFileAccessIntent readingIntentWithURL:url options:NSFileCoordinatorReadingWithoutChanges];
    [fileCoordiator coordinateAccessWithIntents:@[readingIntent] queue:[NSOperationQueue mainQueue] byAccessor:^(NSError * _Nullable error) {
       if(error){
          NSLog(@"coordinateAccess %@", error);
          return;
       }
        NSData *data = [NSData dataWithContentsOfURL:readingIntent.URL];

        NSString *toPath = [customPDFPath stringByAppendingPathComponent:url.lastPathComponent];
        
        [[NSFileManager defaultManager]createFileAtPath:toPath contents:data attributes:@{}];
        
        QPDFViewController *vc = [QPDFViewController new];
        [self.childViewControllers.firstObject pushViewController:vc animated:YES];

        [vc openPDFWithPath:toPath];
    }];
    
    return YES;
}
@end
