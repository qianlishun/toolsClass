//
//  LocalNetworkView.m
//  SmartUS
//
//  Created by mrq on 2019/4/3.
//  Copyright © 2019 SonopTek. All rights reserved.
//

#import "LocalNetworkView.h"
#import "TJLSessionManager.h"

@interface LocalNetworkView()<UITableViewDataSource, UIAlertViewDelegate, NSStreamDelegate, UIActionSheetDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property(strong, nonatomic) TJLSessionManager *sessionManager;
@property(strong, nonatomic) NSMutableArray *datasource;
@property(strong, nonatomic) NSMutableData *streamData; // inputData
@property(strong, nonatomic) NSOutputStream *outputStream;
@property(strong, nonatomic) NSInputStream *inputStream;
@property (nonatomic,strong) NSData *outputData;
@property (nonatomic,weak) id theDelegate;
@end

@implementation LocalNetworkView

- (void)setDelegate:(id)delegate{
    _theDelegate = delegate;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        __weak typeof (self) weakSelf = self;
        self.datasource = [NSMutableArray new];
        self.peerID = [NSString stringWithFormat:@"SmartUS %@", @(arc4random_uniform(100))];
        self.sessionManager = [[TJLSessionManager alloc]initWithDisplayName:self.peerID];
        
        [self.sessionManager didReceiveInvitationFromPeer:^void(MCPeerID *peer, NSData *context) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Accept Connection?" message:[NSString stringWithFormat:@"Can %@%@", peer.displayName, @" Connect?"] delegate:strongSelf cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            [alertView show];
        }];
        
        [self.sessionManager peerConnectionStatusOnMainQueue:YES block:^(MCPeerID *peer, MCSessionState state) {
            if([_theDelegate respondsToSelector:@selector(onLocalNetworkDidChangeState:)]){
                [_theDelegate onLocalNetworkDidChangeState:(LocalNetworkState)state];
            }
            if(state == MCSessionStateConnected) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Connected!" message:[NSString stringWithFormat:@"Now connected with %@", peer.displayName] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertView show];
            }
        }];
        
        [self.sessionManager receiveDataOnMainQueue:YES block:^(NSData *data, MCPeerID *peer) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            
            if (data.length>1000) {
                if([_theDelegate respondsToSelector:@selector(onLocalNetworkReceiveStream:)]){
                    [_theDelegate onLocalNetworkReceiveStream:data];
                }
            }else{
                NSString *string = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                [strongSelf.datasource addObject:@[string, peer.displayName]];
                [strongSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datasource.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                if([_theDelegate respondsToSelector:@selector(onLocalNetworkReceiveData:)]){
                    [_theDelegate onLocalNetworkReceiveData:data];
                }
            }
        }];
        
        [self.sessionManager receiveFinalResourceOnMainQueue:YES complete:^(NSString *name, MCPeerID *peer, NSURL *url, NSError *error) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            NSData *data = [NSData dataWithContentsOfURL:url];
            [strongSelf.datasource addObject:@[name, [UIImage imageWithData:data], peer.displayName]];
            
            [strongSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datasource.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        
        [self.sessionManager didReceiveStreamFromPeer:^(NSInputStream *stream, MCPeerID *peer, NSString *streamName) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            strongSelf.inputStream = stream;
            strongSelf.inputStream.delegate = self;
            [strongSelf.inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
            [strongSelf.inputStream open];
            
        }];
        
        UIButton *advertiseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [advertiseButton setFrame:CGRectMake(0, 0, 80, 30)];
        [advertiseButton setTitle:NSLocalizedString(@"advertise", nil) forState:UIControlStateNormal];
        [advertiseButton addTarget:self action:@selector(advertise:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:advertiseButton];
        
        UIButton *browseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [browseButton setFrame:CGRectMake(frame.size.width-60, 0, 80, 30)];
        [browseButton setTitle:NSLocalizedString(@"browse", nil) forState:UIControlStateNormal];
        [browseButton addTarget:self action:@selector(browse:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:browseButton];
        
        [advertiseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [browseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, frame.size.width, frame.size.height-30)];
        [self addSubview:self.tableView];
        self.tableView.dataSource = self;
    }
    return self;
}

- (void)advertise:(UIButton *)sender {
    //广播通知
    [self.sessionManager advertiseForBrowserViewController];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Tips" message:[NSString stringWithFormat:@"startAdvertisingPeer[%@]",self.peerID] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}


- (void)browse:(UIButton *)sender {
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [self.sessionManager browseWithControllerInViewController:vc connected:^{
        NSLog(@"connected");
    }                                                 canceled:^{
        NSLog(@"cancelled");
    }];
}

- (void)sendLocalNetworkData:(NSData *)data{
    if(self.sessionManager.connectedPeers.count==0){
        return;
    }
    NSError *error = [self.sessionManager sendDataToAllPeers:data];
    if(!error) {
        //there was no error.
    }
    else {
        NSLog(@"%@", error);
    }
}

- (void)sendLocalNetworkStream:(NSData *)data{
    if(self.sessionManager.connectedPeers.count==0){
        return;
    }
    NSError *error = [self.sessionManager sendDataToAllPeers:data];
    if(!error) {
        //there was no error.
    }
    else {
        NSLog(@"%@", error);
    }
   /*
    NSError *err;
//    if(!self.outputStream){
    for (MCPeerID *peer in self.sessionManager.connectedPeers) {
        NSOutputStream *outputStream = [self.sessionManager streamWithName:peer.displayName toPeer:peer error:&err];
        outputStream.delegate = self;
        [outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        //    }
        self.outputData = data;
        if(err || !outputStream) {
            NSLog(@"%@", err);
        }
        else {
            [outputStream open];
        }
    }
    */
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"lnCell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"lnCell"];
    }
    NSArray *array = self.datasource[(NSUInteger)indexPath.row];
    cell.textLabel.text = array.firstObject;
    cell.detailTextLabel.text = array.lastObject;
    if(array.count == 3)
        cell.imageView.image = array[1];
    
    return cell;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.sessionManager connectToPeer:buttonIndex == 1];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    if(eventCode == NSStreamEventHasBytesAvailable) {
        NSInputStream *input = (NSInputStream *)aStream;
        uint8_t buffer[1024];
        NSInteger length = [input read:buffer maxLength:1024];
        [self.streamData appendBytes:(const void *)buffer length:(NSUInteger)length];
        NSLog(@"received");
    }
    else if(eventCode == NSStreamEventHasSpaceAvailable) {
        NSData *data = self.outputData;
        if(data){
            NSOutputStream *output = (NSOutputStream *)aStream;
            [output write:data.bytes maxLength:data.length];
            [output close];
            self.outputData = nil;
        }
    }
    if(eventCode == NSStreamEventEndEncountered) {
        [aStream close];
        [aStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        if([aStream isKindOfClass:[NSInputStream class]]) {
            if([_theDelegate respondsToSelector:@selector(onLocalNetworkReceiveStream:)]){
                [_theDelegate onLocalNetworkReceiveStream:self.streamData];
            }
            self.streamData = nil;
        }
    }
    if(eventCode == NSStreamEventErrorOccurred) {
        NSLog(@"error");
    }
}

- (NSMutableData *)streamData {
    if(!_streamData) {
        _streamData = [NSMutableData data];
    }
    return _streamData;
}

@end
