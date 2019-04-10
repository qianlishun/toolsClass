//
//  LocalNetworkView.h
//  SmartUS
//
//  Created by mrq on 2019/4/3.
//  Copyright © 2019 SonopTek. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum  {
    MCSessionStateNotConnected,     // Not connected to the session.
    MCSessionStateConnecting,       // Peer is connecting to the session.
    MCSessionStateConnected         // Peer is connected to the session.
}LocalNetworkState;

@protocol LocalNetworkDelegate <NSObject>
- (void)onLocalNetworkDidChangeState:(LocalNetworkState)state;
- (void)onLocalNetworkReceiveData:(NSData*)data;
- (void)onLocalNetworkReceiveStream:(NSData*)data;
@end

@interface LocalNetworkView : UIView
- (void)setDelegate:(id)delegate;
- (void)sendLocalNetworkData:(NSData*)data;
- (void)sendLocalNetworkStream:(NSData*)data;

@property (nonatomic,copy) NSString *peerID;

@end

