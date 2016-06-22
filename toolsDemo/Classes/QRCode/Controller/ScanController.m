//
//  ScanController.m
//  toolsDemo
//
//  Created by Mr.Q on 16/6/22.
//  Copyright © 2016年 钱立顺. All rights reserved.
//

#import "ScanController.h"
#import "PreView.h"

@interface  ScanController()<AVCaptureMetadataOutputObjectsDelegate>

//1. 输入设备(用来获取外界信息)  摄像头, 麦克风, 键盘
@property (nonatomic,strong) AVCaptureDeviceInput *input;

//2. 输出设备 (将收集到的信息, 做解析, 来获取收到的内容)
@property (nonatomic,strong) AVCaptureMetadataOutput *output;

//3. 会话session (用来连接输入和输出设备)
@property (nonatomic,strong) AVCaptureSession *session;

//4. 特殊的 layer(展示输入设备所采集的信息)
@property (nonatomic,strong) PreView *preView;

@property (strong, nonatomic)  UILabel *label;
@property (nonatomic,strong) UIButton *btn;


@end

@implementation ScanController

- (UIButton *)btn{

    if (!_btn) {

        UIButton *btn = [[UIButton alloc]initWithFrame:self.label.frame];

        [btn addTarget:self action:@selector(scanClick) forControlEvents:UIControlEventTouchUpInside];
        _btn = btn;
    }
    return _btn;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"扫描二维码";

    self.view.backgroundColor = [UIColor whiteColor];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 260, 42)];
    label.center = self.view.center;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"点我扫描";
    self.label = label;

    [self.view addSubview:label];

    [self.view addSubview:self.btn];

}

- (void)scanClick{
    // 1.输入设备 (用来获取外界信息) 摄像头  麦克风 键盘
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];

    // 2.输出设备 (将收集到的信息, 做解析 ,  来获取收到的内容)
    self.output = [AVCaptureMetadataOutput new];

    // 3.会话 session 用来连接输入和输出设备
    self.session = [AVCaptureSession new];

    // 会话扫描展示的大小
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];

    // 会话跟输入和输出设备关联
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }

    // 下面两句代码应该写在此处
    // 指定输出设备的代理  用来接受返回的数据
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

    // 设置元数据类型  二维码 QRCode
    [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];

    // 4.特殊的 layer  (展示输入设备所采集的信息)
    self.preView = [[PreView alloc]initWithFrame:self.view.bounds];
    self.preView.session = self.session;

    [self.view addSubview:self.preView];

    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 24)];
    cancelBtn.center = CGPointMake(self.view.center.x, self.view.bounds.size.height * 0.8);
    [cancelBtn setTitle:@"返回" forState: UIControlStateNormal];
    [cancelBtn setBackgroundColor: [UIColor colorWithRed:arc4random_uniform (256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]];
    [cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:cancelBtn];

    // 启动会话
    [self.session startRunning];
}

- (void)cancelClick:(UIButton *)sender{
    // 1.停止会话
    [self.session stopRunning];

    // 2.删除 layer
    [self.preView removeFromSuperview];

    [sender removeFromSuperview];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{

    // 1.停止会话
    [self.session stopRunning];

    // 2.删除 layer
    [self.preView removeFromSuperview];

    // 3.遍历数据获取内容
    for (AVMetadataMachineReadableCodeObject *obj in metadataObjects) {
        self.label.text = obj.stringValue;
    }
    if([self.label.text hasPrefix:@"http://"] || [self.label.text hasPrefix:@"https://"] || [self.label.text hasPrefix:@"sms://"]){

        NSURL *url = [NSURL URLWithString:self.label.text];
        [[UIApplication sharedApplication]openURL:url];
    }
    
}



@end
