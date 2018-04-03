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

@interface TwoController ()
@property (nonatomic,strong) NSArray *networks;

@end

@implementation TwoController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 200, 60);
    button.center=self.view.center;
    button.backgroundColor=[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];

    [button setTitle:@"第二个控制器" forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    UITextView *textFiled = [[UITextView alloc]initWithFrame:CGRectMake(self.view.width/2, 100, 200, 30)];
    textFiled.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:textFiled];
    
    [self scanWifiInfos];
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
@end

