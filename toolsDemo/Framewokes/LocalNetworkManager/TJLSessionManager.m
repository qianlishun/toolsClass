//
//  TJLSessionManager.m
//  TJLSessionManager
//
//  Created by Terry Lewis II on 12/7/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//

#import "TJLSessionManager.h"

// 广播对接码
// 长度在1至15个字符之间，由ASCII字母、数字和“-”组成，不能以“-”为开头或结尾，不能包含除了“-”之外的其他特殊字符
#define ServiceType @"Smart-US"

@interface TJLSessionManager () <MCAdvertiserAssistantDelegate, MCNearbyServiceBrowserDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate, MCNearbyServiceAdvertiserDelegate, UIAlertViewDelegate>
@property(strong, nonatomic) MCSession *currentSession;
@property(strong, nonatomic) MCAdvertiserAssistant *advertisingAssistant;
@property(strong, nonatomic) MCNearbyServiceAdvertiser *advertiser;
@property(strong, nonatomic) MCNearbyServiceBrowser *browser;
@property(strong, nonatomic) MCPeerID *peerID;
@property(nonatomic, copy) void(^receiveDataBlock)(NSData *data, MCPeerID *peer);
@property(nonatomic, copy) void(^receiveResourceBlock)(MCPeerID *peer, NSURL *url);
@property(nonatomic, copy) void(^connectionStatus)(MCPeerID *peer, MCSessionState state);
@property(nonatomic, copy) void(^browserConnected)(void);
@property(nonatomic, copy) void(^browserCancelled)(void);
@property(nonatomic, copy) void(^didFindPeer)(MCPeerID *peer, NSDictionary *info);
@property(nonatomic, copy) void(^invitationHandler)(BOOL connect, MCSession *session);
@property(nonatomic, copy) void(^inviteBlock)(MCPeerID *peer, NSData *context);
@property(nonatomic, copy) void(^didStartReceivingResource)(NSString *name, MCPeerID *peer, NSProgress *progress);
@property(nonatomic, copy) void(^finalResource)(NSString *name, MCPeerID *peer, NSURL *url, NSError *error);
@property(nonatomic, copy) void(^streamBlock)(NSInputStream *inputStream, MCPeerID *peer, NSString *streamName);
@property(nonatomic, assign) BOOL receiveOnMainQueue;
@property(nonatomic, assign) BOOL statusOnMainQueue;
@property(nonatomic, assign) BOOL resourceFinalOnMainQueue;
@property(nonatomic, assign) BOOL resourceStart;
@end

@implementation TJLSessionManager
- (instancetype)initWithDisplayName:(NSString *)displayName {
    return [self initWithDisplayName:displayName securityIdentity:nil encryptionPreferences:MCEncryptionNone serviceType:ServiceType];
}

- (instancetype)initWithDisplayName:(NSString *)displayName securityIdentity:(NSArray *)security encryptionPreferences:(MCEncryptionPreference)preference serviceType:(NSString *)type {
    self = [super init];
    if(!self) {
        return nil;
    }
    self.peerID = [[MCPeerID alloc]initWithDisplayName:displayName];
    self.currentSession = [[MCSession alloc]initWithPeer:self.peerID securityIdentity:security encryptionPreference:preference];
    self.session.delegate = self;
    self.serviceType = type;
    return self;
}

- (void)advertiseForBrowserViewController {
    [self advertiseForBrowserViewControllerWithDiscoveryInfo:nil];
}

- (void)advertiseForBrowserViewControllerWithDiscoveryInfo:(NSDictionary *)info {
    self.advertiser = [[MCNearbyServiceAdvertiser alloc]initWithPeer:self.peerID discoveryInfo:info serviceType:self.serviceType];
    self.advertiser.delegate = self;
    [self.advertiser startAdvertisingPeer];
}

- (void)advertiseForProgrammaticDiscovery {
    [self advertiseForProgrammaticDiscoveryWithDiscoveryInfo:nil];
}

- (void)advertiseForProgrammaticDiscoveryWithDiscoveryInfo:(NSDictionary *)info {
    self.advertisingAssistant = [[MCAdvertiserAssistant alloc]initWithServiceType:self.serviceType discoveryInfo:info session:self.session];
    self.advertisingAssistant.delegate = self;
    [self.advertisingAssistant start];
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler {
    self.invitationHandler = [invitationHandler copy];
    if(self.inviteBlock) self.inviteBlock(peerID, context);
}

- (void)advertiserAssistantDidDismissInvitation:(MCAdvertiserAssistant *)advertiserAssistant {
    //TODO implement
}

- (void)advertiserAssitantWillPresentInvitation:(MCAdvertiserAssistant *)advertiserAssistant {
    //TODO implement
}

- (void)browseForProgrammaticDiscovery {
    self.browser = [[MCNearbyServiceBrowser alloc]initWithPeer:self.peerID serviceType:self.serviceType];
    self.browser.delegate = self;
    [self.browser startBrowsingForPeers];
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    //TODO implement
}

- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    if(self.didFindPeer) self.didFindPeer(peerID, info);
}

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error {
    //TODO implement
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    if(self.resourceFinalOnMainQueue) {
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            if(self.finalResource) self.finalResource(resourceName, peerID, localURL, error);
        }];
    }
    else {
        if(self.finalResource) self.finalResource(resourceName, peerID, localURL, error);
    }

}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    if(self.receiveOnMainQueue) {
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            if(self.receiveDataBlock) self.receiveDataBlock(data, peerID);
        }];
    }
    else {
        if(self.receiveDataBlock) self.receiveDataBlock(data, peerID);
    }
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    if(self.streamBlock) self.streamBlock(stream, peerID, streamName);
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    if(self.resourceStart) {
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            if(self.didStartReceivingResource) self.didStartReceivingResource(resourceName, peerID, progress);
        }];
    }
    else {
        if(self.didStartReceivingResource) self.didStartReceivingResource(resourceName, peerID, progress);
    }
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    if(self.statusOnMainQueue) {
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            if(self.connectionStatus) self.connectionStatus(peerID, state);
        }];
    }
    else {
        if(self.connectionStatus) self.connectionStatus(peerID, state);
    }
}

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    [browserViewController dismissViewControllerAnimated:YES completion:^{
        if(self.browserConnected) self.browserConnected();
    }];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    [browserViewController dismissViewControllerAnimated:YES completion:^{
        if(self.browserCancelled) self.browserCancelled();
    }];
}

- (NSError *)sendDataToAllPeers:(NSData *)data {
    return [self sendDataToAllPeers:data withMode:MCSessionSendDataReliable];
}

- (NSError *)sendDataToAllPeers:(NSData *)data withMode:(MCSessionSendDataMode)mode {
    NSError *error;
    [self.session sendData:data toPeers:self.session.connectedPeers withMode:mode error:&error];
    return error;
}

- (NSError *)sendData:(NSData *)data toPeers:(NSArray *)peers {
    return [self sendData:data toPeers:peers withMode:MCSessionSendDataReliable];
}

- (NSError *)sendData:(NSData *)data toPeers:(NSArray *)peers withMode:(MCSessionSendDataMode)mode {
    NSError *error;
    [self.session sendData:data toPeers:peers withMode:mode error:&error];
    return error;
}

- (void)receiveDataOnMainQueue:(BOOL)mainQueue block:(void (^)(NSData *data, MCPeerID *peer))dataBlock {
    self.receiveDataBlock = [dataBlock copy];
    self.receiveOnMainQueue = mainQueue;
}

- (NSProgress *)sendResourceWithName:(NSString *)name atURL:(NSURL *)url toPeer:(MCPeerID *)peer complete:(void (^)(NSError *error))compelete {
    return [self.session sendResourceAtURL:url withName:name toPeer:peer withCompletionHandler:compelete];
}

- (void)peerConnectionStatusOnMainQueue:(BOOL)mainQueue block:(void (^)(MCPeerID *peer, MCSessionState state))status {
    self.connectionStatus = [status copy];
    self.statusOnMainQueue = mainQueue;
}

- (void)browseWithControllerInViewController:(UIViewController *)controller connected:(void (^)(void))connected canceled:(void (^)(void))cancelled {
    self.browserConnected = [connected copy];
    self.browserCancelled = [cancelled copy];
    MCBrowserViewController *browser = [[MCBrowserViewController alloc]initWithServiceType:self.serviceType session:self.session];
    browser.delegate = self;
    [controller presentViewController:browser animated:YES completion:nil];
}

- (NSArray *)connectedPeers {
    return self.session.connectedPeers;
}

- (void)didReceiveInvitationFromPeer:(void (^)(MCPeerID *peer, NSData *context))invite; {
    self.inviteBlock = [invite copy];
}

- (void)invitePeerToConnect:(MCPeerID *)peer connected:(void (^)(void))connected {
    [self.browser invitePeer:peer toSession:self.session withContext:nil timeout:30];
}

- (void)startReceivingResourceOnMainQueue:(BOOL)mainQueue block:(void (^)(NSString *name, MCPeerID *peer, NSProgress *progress))block {
    self.didStartReceivingResource = [block copy];
    self.resourceStart = mainQueue;
}

- (void)receiveFinalResourceOnMainQueue:(BOOL)mainQueue complete:(void (^)(NSString *name, MCPeerID *peer, NSURL *url, NSError *error))block {
    self.finalResource = [block copy];
    self.resourceFinalOnMainQueue = mainQueue;
}

- (NSOutputStream *)streamWithName:(NSString *)name toPeer:(MCPeerID *)peerID error:(NSError * __autoreleasing *)error {
    return [self.session startStreamWithName:name toPeer:peerID error:error];
}

- (void)didReceiveStreamFromPeer:(void (^)(NSInputStream *inputStream, MCPeerID *peer, NSString *streamName))streamBlock {
    self.streamBlock = [streamBlock copy];
}

- (void)didFindPeerWithInfo:(void (^)(MCPeerID *peer, NSDictionary *info))found {
    self.didFindPeer = [found copy];
}

- (void)disconnectSession {
    [self.session disconnect];
}

- (void)stopAdvertising {
    [self.advertiser stopAdvertisingPeer];
    [self.advertisingAssistant stop];
}

- (void)stopBrowsing {
    [self.browser stopBrowsingForPeers];
}

- (BOOL)isConnected {
    return self.session.connectedPeers && self.session.connectedPeers.count > 0;
}

- (void)connectToPeer:(BOOL)connect {
    self.invitationHandler(connect, self.session);
}

- (MCSession *)session {
    return self.currentSession;
}

- (MCPeerID *)firstPeer {
    return self.session.connectedPeers.firstObject;
}
@end

