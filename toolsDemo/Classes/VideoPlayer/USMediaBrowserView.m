//
//  USMediaBrowserView.m
//  PVUS
//
//  Created by mrq on 2020/9/14.
//  Copyright © 2020 SonopTek. All rights reserved.
//

#import "USMediaBrowserView.h"
#import "SelVideoPlayer.h"
#import "SelPlayerConfiguration.h"
#import "Masonry.h"
@interface USMediaBrowserView()

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) SelVideoPlayer *player;

@end

@implementation USMediaBrowserView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.hidden = YES;
        [self addSubview:self.imageView];
        
        SelPlayerConfiguration *config = [[SelPlayerConfiguration alloc]init];
        config.shouldAutoPlay = NO;
        config.supportedDoubleTap = YES;
        config.shouldAutorotate = NO;
        config.repeatPlay = NO;
        config.videoGravity = SelVideoGravityResizeAspect;
        
        _player = [[SelVideoPlayer alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) configuration:config];
        _player.backgroundColor = [UIColor blackColor];
        [self addSubview:_player];
        self.player.hidden = YES;

    }
    return self;
}

- (void)setImageURL:(NSURL *)url{
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    self.imageView.image = image;
    
    self.imageView.hidden = NO;
    self.player.hidden = YES;
}

- (void)setVideoURL:(NSURL *)url{
    [self.player setVideoURL:url];
    self.player.hidden = NO;
    self.imageView.hidden = YES;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    [self.imageView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.player setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
}

@end
