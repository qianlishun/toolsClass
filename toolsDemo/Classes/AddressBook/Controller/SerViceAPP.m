//
//  SerViceAPP.m
//  SerVe
//
//  Created by qianhaifeng on 16/5/5.
//  Copyright © 2016年 qianhaifeng. All rights reserved.
//

#import "SerViceAPP.h"
#import "GCDAsyncSocket.h"
#import "GCDAsyncSocket+category.h"
#import <UIKit/UIKit.h>

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"


@interface SerViceAPP()<GCDAsyncSocketDelegate>{
    NSTimer *testTimer;
}

@property(nonatomic, strong)GCDAsyncSocket *serve;
@property(nonatomic, strong)NSMutableArray *socketConnectsM;
@property(nonatomic, strong)NSThread *checkThread;

@end

static SerViceAPP *instance;
@implementation SerViceAPP

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] init];
    });
    return instance;
}

-(NSThread *)checkThread{
    return _checkThread = _checkThread?:[[NSThread alloc]initWithTarget:self selector:@selector(checkClientOnline) object:nil];
}

-(GCDAsyncSocket *)serve{
    if (!_serve) {
        _serve = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
        _serve.delegate = self;
    }
    return _serve;
}

-(NSMutableArray *)socketConnectsM{
    return _socketConnectsM= _socketConnectsM?:[NSMutableArray array];
}

-(void)openSerVice{
    NSError *error;
    if (self.serve.isDisconnected) {
        [self.checkThread start];
        BOOL sucess = [self.serve acceptOnPort:5002 error:&error];
        NSLog(sucess?@"端口开启成功,并监听客户端请求连接...":@"端口开启失...");
    }
}

- (void)closeService{
    if (!self.checkThread.isCancelled) {
        [self.checkThread cancel];
    }
    if (self.serve.isConnected) {
        @synchronized (_serve) {
            [self.serve disconnect];
        }
    }
}
#pragma delegate

- (void)socket:(GCDAsyncSocket *)serveSock didAcceptNewSocket:(GCDAsyncSocket *)clientSocket{
    NSLog(@"%@ IP: %@: %hu 客户端请求连接...",clientSocket,clientSocket.connectedHost,clientSocket.connectedPort);
    // 1.将客户端socket保存起来
    clientSocket.timeNew = [NSDate date];
    [self.socketConnectsM addObject:clientSocket];
    self.userNumberBlock?self.userNumberBlock(self.socketConnectsM.count):nil;
    [clientSocket readDataWithTimeout:-1 tag:0];
    [self startSendData];
}

- (void)startSendData{
    [self testSendData];
}

static double timeindex3 = 0;
static double timeindex2 = 0;
static int count2 = 0;
- (void)testSendData{
    if(self.socketConnectsM.count){
        double now = [NSDate date].timeIntervalSince1970*1000;

        if(timeindex2==0){
            timeindex2 = now;
            timeindex3 = now;
        }else if(now - timeindex2 >=1){
            UIImage *image = [UIImage imageNamed:@"qrcode54"];
            NSData * imgData = UIImageJPEGRepresentation(image, 1.0);
            [self.socketConnectsM.firstObject writeData:imgData withTimeout:-1 tag:0];
            
            timeindex2 = now;
            count2 ++;
        }
        if(now-timeindex3>=1000){
            NSLog(@"timecount %d",count2);
            timeindex3 = now;
            count2 = 0;
        }

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.00005 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startSendData];
        });
    }else{
    }
}

- (void)socket:(GCDAsyncSocket *)clientSocket didReadData:(NSData *)data withTag:(long)tag  {
    NSString *clientStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    ![clientStr isEqualToString:@"heart"] && clientStr.length!=0 &&self.messageBlock?self.messageBlock(clientSocket,clientStr):nil;
    for (GCDAsyncSocket *socket in self.socketConnectsM) {
         if (![clientSocket isEqual:socket]) {
             //群聊 发送给其他客户端
             if(![clientStr isEqualToString:@"heart"] && clientStr.length!=0)
             {
                 [self writeDataWithSocket:socket str:clientStr];
             }
         }
         else{socket.timeNew = [NSDate date];}
    }
    [clientSocket readDataWithTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"又下线");
    [self.socketConnectsM enumerateObjectsUsingBlock:^(GCDAsyncSocket *client, NSUInteger idx, BOOL * _Nonnull stop) {
        if([client isEqual:sock]){
            [self.socketConnectsM removeObject:client];
            *stop = YES;
        }
    }];
}

-(void)exitWithSocket:(GCDAsyncSocket *)clientSocket{
    [self writeDataWithSocket:clientSocket str:@"成功退出\n"];
    [self.socketConnectsM enumerateObjectsUsingBlock:^(GCDAsyncSocket *client, NSUInteger idx, BOOL * _Nonnull stop) {
        if([client isEqual:clientSocket]){
            [self.socketConnectsM removeObject:client];
            *stop = YES;
        }
    }];
    NSLog(@"当前在线用户个数:%ld",self.socketConnectsM.count);
    self.userNumberBlock?self.userNumberBlock(self.socketConnectsM.count):nil;
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
//    NSLog(@"数据发送成功..");
}

- (void)writeDataWithSocket:(GCDAsyncSocket*)clientSocket str:(NSString*)str{
    [clientSocket writeData:[str dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}

#pragma checkTimeThread

//开启线程 启动runloop 循环检测客户端socket最新time
- (void)checkClientOnline{
    @autoreleasepool {
        [NSTimer scheduledTimerWithTimeInterval:35 target:self selector:@selector(repeatCheckClinetOnline) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]run];
    }
}

//移除 超过心跳的 client
- (void)repeatCheckClinetOnline{
    if (self.socketConnectsM.count == 0) {
        return;
    }
    NSDate *date = [NSDate date];
    NSMutableArray *arrayNew = [NSMutableArray array];
    for (GCDAsyncSocket *socket in self.socketConnectsM ) {
        if ([date timeIntervalSinceDate:socket.timeNew]>30) {
            continue;
        }
        [arrayNew addObject:socket   ];
    }
    self.socketConnectsM = arrayNew;
    self.userNumberBlock?self.userNumberBlock(self.socketConnectsM.count):nil;
}


//获取设备当前网络IP地址
- (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ /*IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6,*/ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ /*IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4,*/ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

//获取所有相关IP信息
- (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

@end
