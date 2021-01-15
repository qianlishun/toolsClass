//
//  USMediaBrowserView.h
//  PVUS
//
//  Created by mrq on 2020/9/14.
//  Copyright © 2020 SonopTek. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface USMediaBrowserView : UIView

- (void)setVideoURL:(NSURL*)url;

- (void)setImageURL:(NSURL*)url;

@end

NS_ASSUME_NONNULL_END
