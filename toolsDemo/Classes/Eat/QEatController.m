//
//  QEatController.m
//  toolsDemo
//
//  Created by mrq on 2019/4/1.
//  Copyright © 2019 钱立顺. All rights reserved.
//

#import "QEatController.h"
#import <WebKit/WebKit.h>
#import "QEatEditView.h"
#import "QCoverView.h"
#import "UIView+SDAutoLayout.h"

@interface QEatController ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate>
@property (nonatomic,strong)  WKWebView *webView;
@property (nonatomic,strong) QEatEditView *editView;
@end

@implementation QEatController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建网页配置对象
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    // 创建设置对象
    WKPreferences *preference = [[WKPreferences alloc]init];
    //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
    preference.minimumFontSize = 0;
    //设置是否支持javaScript 默认是支持的
    preference.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
    preference.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences = preference;
    
    // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
    config.allowsInlineMediaPlayback = YES;
    //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
    config.requiresUserActionForMediaPlayback = YES;
    //设置是否允许画中画技术 在特定设备上有效
    config.allowsPictureInPictureMediaPlayback = YES;
    //设置请求的User-Agent信息中应用程序名称 iOS9后可用
    config.applicationNameForUserAgent = @"ChinaDailyForiPad";
    //自定义的WKScriptMessageHandler 是为了解决内存不释放的问题
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) configuration:config];
    [self.view addSubview:_webView];
    
    // UI代理
    _webView.UIDelegate = self;
    // 导航代理
    _webView.navigationDelegate = self;
    // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
    _webView.allowsBackForwardNavigationGestures = YES;
    //可返回的页面列表, 存储已打开过的网页
    _webView.scrollView.bounces = NO;
    [_webView.scrollView setShowsVerticalScrollIndicator:NO];
    [_webView.scrollView setShowsHorizontalScrollIndicator:NO];
    _webView.scrollView.delegate = self;
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"wrgo.html" ofType:nil];
    NSString *htmlString = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //加载本地html文件
    [_webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self updateWebView:[self getDefaultList]];
}

- (void)edit:(id)sender{
    __weak typeof(self) weakself = self;
    if(!_editView){
        CGFloat h = 300;
        _editView = [[QEatEditView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-h, self.view.bounds.size.width, h)];
        NSArray *list = [self getDefaultList];
        [_editView setList:list];
        _editView.doneBlock = ^(NSArray *list) {
            [weakself reloadWebView:list];
            [QCoverView hide];
        };
    }
    
    [QCoverView transparentCoverFrom:self.view content:_editView animated:YES touchHideBlock:^(UIView *view) {
        [weakself reloadWebView: [weakself.editView getList]];
    }];
    
    _editView.bottom = self.view.bottom;
    _editView.centerX = self.view.centerX;
}

- (void)reloadWebView:(NSArray*)list{
    [self updateWebView:list];
    
    [self updateDefaultList:list];
    
    [_editView setList:list];
}

- (void)updateWebView:(NSArray*)list{
    
    NSData *jsonData =  [NSJSONSerialization dataWithJSONObject:list options:0 error:NULL];
    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *methodStr = @"setList";
    jsonStr = [NSString stringWithFormat:@"%@('%@')",methodStr,jsonStr];
    [self.webView evaluateJavaScript:jsonStr completionHandler:^(id _Nullable obj, NSError * _Nullable error){
        NSLog(@"evaluateJavaScript, obj = %@, error = %@", obj, error);
     }];
}

static NSString *udKey = @"QEatListKey";
- (void)updateDefaultList:(NSArray*)list{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:list forKey:udKey];
}

- (NSArray*)getDefaultList{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *list = [ud objectForKey:udKey];
    if(!list){
        list = @[@"寻客",@"V道",@"桂林",@"地下",@"张记",@"米粟",@"多味"];
        [self updateDefaultList:list];
    }
    return list;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    scrollView.contentOffset = CGPointMake( 1, scrollView.contentOffset.y);
}

@end
