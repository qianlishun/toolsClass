//
//  AppDelegate.m
//  toolsDemo
//
//  Created by MrQ on 15/9/17.
//  Copyright © 2016年 QLS. All rights reserved.
//

#import "AppDelegate.h"
#import "MainController.h"
#import "QPDFViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];


    MainController *mainVc=[[MainController alloc]init];

    self.window.rootViewController=mainVc;

    //设置为主控制器并可见
    [self.window makeKeyAndVisible];

    IQKeyboardManager *kbManager = [IQKeyboardManager sharedManager];
    kbManager.enable = YES;
    kbManager.shouldResignOnTouchOutside = YES;
    kbManager.shouldToolbarUsesTextFieldTintColor = YES;
    kbManager.enableAutoToolbar = YES;
    kbManager.toolbarManageBehaviour = IQAutoToolbarBySubviews;

    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    
    
    return [(MainController*)self.window.rootViewController pushPDFVC:url];
}


@end
