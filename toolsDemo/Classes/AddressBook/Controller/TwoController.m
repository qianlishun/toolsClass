//
//  TwoController.m
//  toolsDemo
//
//  Created by Mr.Q on 15/12/20.
//  Copyright © 2015年 QLS. All rights reserved.
//

#import "TwoController.h"
#import "UIView+QLSFrame.h"
#import <NetworkExtension/NetworkExtension.h>
#import "GCDAsyncSocket.h"
#import "LocalNetworkView.h"
#import "SerViceAPP.h"

typedef void (^STRINGBLOCK)(NSString *str);

@interface TwoController ()<GCDAsyncSocketDelegate>{
    BOOL _isServer;
}
@property (nonatomic,strong) NSArray *networks;
@property(nonatomic,strong)GCDAsyncSocket *socket;//socket
@property (nonatomic, strong)NSThread *thread;    //心跳线程
@property (nonatomic,copy)STRINGBLOCK receivedMessageBlock;//接收的消息回调

@property (nonatomic,strong) LocalNetworkView *localNetworkView;

@property (nonatomic,strong) UILabel *serIPLabel;
@property (nonatomic,strong) UILabel *connectLabel;

@end

@implementation TwoController
#pragma mark  socket 实体
-(GCDAsyncSocket *)socket{
    return _socket = _socket?:[[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
}
#pragma mark连接服务器端口和ip
- (void)connectHost:(NSString *)host port:(uint16_t)port{
    [self.socket connectToHost:host onPort:port error:nil];
}
#pragma mark 连接成功
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"连接成功");
    [self.socket readDataWithTimeout:-1 tag:0];
    //开启线程发送心跳
    [self.thread start];
}

static double timeindex = 0;
static int count = 0;
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
//    NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    double now = [NSDate date].timeIntervalSince1970;
    if(timeindex==0){
        timeindex = now;
    }else if(now - timeindex >=1){
        NSString *str = [NSString stringWithFormat:@"length: %lu,count: %d",(unsigned long)data.length,count];
        self.receivedMessageBlock?self.receivedMessageBlock(str):nil;
        count = 0;
        timeindex = now;
    }
    count ++;
 
    [sock readDataWithTimeout:-1 tag:0];
}
#pragma mark 断开连接
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"断开连接 %@",err);
    //再次可以重连
    if (err) {
        [self connectHost:sock.connectedHost port:sock.connectedPort];
    }
    else{//正常断开
     
    }
    [self.thread cancel];
    self.thread = nil;
}
#pragma mark 消息发送
- (void)sendmessage:(NSString*)message{
    if(self.socket.isDisconnected){
        [self connectHost:self.socket.connectedHost port:self.socket.connectedPort];
    }
    [self.socket writeData:[message dataUsingEncoding:NSUTF8StringEncoding ] withTimeout:-1 tag:0];
}
#pragma mark  开启心跳定时发送
- (void)threadStart{
    @autoreleasepool {
        [NSTimer scheduledTimerWithTimeInterval:25 target:self selector:@selector(heartBeat) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]run];
    }
}
#pragma mark 心跳信息
- (void)heartBeat{
    [self sendmessage:@"heart"];
}
#pragma mark 心跳线程
- (NSThread*)thread{
    if (!_thread) {
        _thread = [[NSThread alloc]initWithTarget:self selector:@selector(threadStart) object:nil];
    }
    return _thread;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 200, 60);
    button.center=self.view.center;
    button.backgroundColor=[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];

    [button setTitle:@"socket test" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(socketTest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
//    UITextView *textFiled = [[UITextView alloc]initWithFrame:CGRectMake(self.view.width/2, 100, 200, 30)];
//    textFiled.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:textFiled];
    
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithTitle:@"LocalNetwork" style:UIBarButtonItemStylePlain target:self action:@selector(onClicklocalNetwork:)];
    
    self.navigationItem.rightBarButtonItem = item1;
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithTitle:@"openServer" style:UIBarButtonItemStylePlain target:self action:@selector(openServer)];
    self.navigationItem.leftBarButtonItem = item2;
    
    _serIPLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, 150, 30)];
    [_serIPLabel setTintColor:[UIColor blackColor]];
    [self.view addSubview:_serIPLabel];
    
    _connectLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, 150, 30)];
    [_connectLabel setTintColor:[UIColor blackColor]];
    [self.view addSubview:_connectLabel];
    
//    [self scanWifiInfos];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 100, 150, 30)];
    [timeLabel setTintColor:[UIColor blackColor]];
    [self.view addSubview:timeLabel];
    
    __block UILabel *bT = timeLabel;
    __block int index = 0;
    [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        index++;
        bT.text = [NSString stringWithFormat:@"%d",index];
    }];
}

- (void)openServer{
    [self.socket disconnect];
    [[SerViceAPP shareInstance] openSerVice];
    _serIPLabel.text = [[SerViceAPP shareInstance] getIPAddress:YES];
    __weak typeof (&*self)weakSelf = self;
    [SerViceAPP shareInstance].messageBlock=^(GCDAsyncSocket *client,NSString *message){
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    };
    [SerViceAPP shareInstance].userNumberBlock = ^(NSInteger number) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.connectLabel.text = [@(number) stringValue];
        });
    };
}

- (void)socketTest{
    [[SerViceAPP shareInstance]closeService];
    
    if(self.socket.isConnected){
        [self.socket disconnect];
    }else{
        NSString* host = @"192.168.2.222";
        UInt16 portData = 5002;
        [self connectHost:host port:portData];
        
        self.receivedMessageBlock = ^(NSString *message){
            NSLog(@"receivedMessageBlock %@",message);
        };
        [self sendmessage:@"233"];
    }
}

- (void)scanWifiInfos{
    NSLog(@"1.Start");
    
    self.networks = [NSArray array];
    
    NSMutableDictionary* options = [[NSMutableDictionary alloc] init];
    [options setObject:@"EFNEHotspotHelperDemo" forKey: kNEHotspotHelperOptionDisplayName];
    dispatch_queue_t queue = dispatch_queue_create("EFNEHotspotHelperDemo", NULL);
    
    NSLog(@"2.Try");
    BOOL returnType = [NEHotspotHelper registerWithOptions: options queue: queue handler: ^(NEHotspotHelperCommand * cmd) {
        
        NSLog(@"4.Finish");
        NEHotspotNetwork* network;
        if (cmd.commandType == kNEHotspotHelperCommandTypeEvaluate || cmd.commandType == kNEHotspotHelperCommandTypeFilterScanList) {
            
            self.networks = [NSArray arrayWithArray:cmd.networkList];
            [self.tableView reloadData];
            // 遍历 WiFi 列表，打印基本信息
            for (network in cmd.networkList) {
                
//                NSString* wifiInfoString = [[NSString alloc] initWithFormat: @"---------------------------\nSSID: %@\nMac地址: %@\n信号强度: %f\nCommandType:%ld\n---------------------------\n\n", network.SSID, network.BSSID, network.signalStrength, (long)cmd.commandType];
//                NSLog(@"%@", wifiInfoString);
                
                // 检测到指定 WiFi 可设定密码直接连接
                if ([network.SSID isEqualToString: @"测试 WiFi"]) {
                    [network setConfidence: kNEHotspotHelperConfidenceHigh];
                    [network setPassword: @"123456789"];
                    NEHotspotHelperResponse *response = [cmd createResponse: kNEHotspotHelperResultSuccess];
                    NSLog(@"Response CMD: %@", response);
                    [response setNetworkList: @[network]];
                    [response setNetwork: network];
                    [response deliver];
                }
            }
        }
    }];
    // 注册成功 returnType 会返回一个 Yes 值，否则 No
    NSLog(@"3.Result: %@", returnType == YES ? @"Yes" : @"No");
}

#pragma mark - tableView delegate & datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.networks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"networkCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    NEHotspotNetwork *network = self.networks[indexPath.row];
    
    cell.textLabel.text = network.SSID;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",network.signalStrength];
    
    return cell;
}


- (void)onClicklocalNetwork:(UIBarButtonItem*)sender{
    if(!_localNetworkView){
        _localNetworkView = [[LocalNetworkView alloc]initWithFrame:CGRectMake(self.view.width-200, self.view.y, 200, 200)];
        [self.view addSubview:_localNetworkView];
        [_localNetworkView setDelegate:self];
        _localNetworkView.hidden = YES;
    }
    _localNetworkView.hidden = !_localNetworkView.hidden;
}

@end

